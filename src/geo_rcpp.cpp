#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

using Rcpp::NumericVector;
using Rcpp::IntegerVector;
using Rcpp::LogicalVector;
using Rcpp::List;
using Rcpp::Nullable;

static inline bool geo_point_in_polygon_single_cpp(double x, double y,
                                                   const NumericVector &poly_x,
                                                   const NumericVector &poly_y) {
  int n = poly_x.size();
  if(n < 3) return false;
  bool inside = false;
  int j = n - 1;
  for(int i = 0; i < n; ++i) {
    double xi = poly_x[i];
    double yi = poly_y[i];
    double xj = poly_x[j];
    double yj = poly_y[j];
    bool intersect = ((yi > y) != (yj > y)) &&
      (x < (xj - xi) * (y - yi) / (yj - yi + 0.0) + xi);
    if(intersect) inside = !inside;
    j = i;
  }
  return inside;
}

static inline bool geo_clip_segment_to_rect_cpp(double x1, double y1, double x2, double y2,
                                                double xmin, double xmax, double ymin, double ymax,
                                                double &ox1, double &oy1, double &ox2, double &oy2) {
  double dx = x2 - x1;
  double dy = y2 - y1;
  double p1 = -dx;
  double p2 = dx;
  double p3 = -dy;
  double p4 = dy;
  double q1 = x1 - xmin;
  double q2 = xmax - x1;
  double q3 = y1 - ymin;
  double q4 = ymax - y1;
  double u1 = 0.0;
  double u2 = 1.0;

  auto clip = [&](double p, double q) {
    if(p == 0.0) {
      return q >= 0.0;
    }
    double t = q / p;
    if(p < 0.0) {
      if(t > u2) return false;
      if(t > u1) u1 = t;
    } else {
      if(t < u1) return false;
      if(t < u2) u2 = t;
    }
    return true;
  };

  if(!clip(p1, q1)) return false;
  if(!clip(p2, q2)) return false;
  if(!clip(p3, q3)) return false;
  if(!clip(p4, q4)) return false;
  if(u1 > u2) return false;

  ox1 = x1 + u1 * dx;
  oy1 = y1 + u1 * dy;
  ox2 = x1 + u2 * dx;
  oy2 = y1 + u2 * dy;
  return true;
}

static inline double geo_spherical_cov_cpp(double dist, double range, double sill, double nugget) {
  if(range <= 0.0 || sill == 0.0) return 0.0;
  double x = dist / range;
  if(x > 1.0) return 0.0;
  double v = sill - (sill - nugget) * (1.5 * x - 0.5 * x * x * x) - nugget;
  return v / sill;
}

static inline double geo_distance_latlon_rad_cpp(double lat, double lon, double lat1, double lon1) {
  const double rad = 6367.0;
  double val = std::sin(lat) * std::sin(lat1) + std::cos(lat) * std::cos(lat1) * std::cos(lon - lon1);
  if(val > 1.0) val = 1.0;
  if(val < -1.0) val = -1.0;
  return rad * std::acos(val);
}

// [[Rcpp::export]]
LogicalVector geo_point_in_polygon_cpp(NumericVector x, NumericVector y,
                                       NumericVector poly_x, NumericVector poly_y) {
  int n = poly_x.size();
  int npts = x.size();
  LogicalVector inside(npts, false);
  if(n < 3) return inside;
  int j = n - 1;
  for(int i = 0; i < n; ++i) {
    double xi = poly_x[i];
    double yi = poly_y[i];
    double xj = poly_x[j];
    double yj = poly_y[j];
    for(int p = 0; p < npts; ++p) {
      double yp = y[p];
      bool intersect = ((yi > yp) != (yj > yp)) &&
        (x[p] < (xj - xi) * (yp - yi) / (yj - yi + 0.0) + xi);
      if(intersect) inside[p] = !inside[p];
    }
    j = i;
  }
  return inside;
}

// [[Rcpp::export]]
LogicalVector geo_point_in_multipolygon_cpp(NumericVector x, NumericVector y,
                                            NumericVector poly_x, NumericVector poly_y,
                                            IntegerVector lxv) {
  int npts = x.size();
  LogicalVector inside(npts, false);
  if(lxv.size() < 2) {
    return geo_point_in_polygon_cpp(x, y, poly_x, poly_y);
  }
  for(int i = 0; i < lxv.size() - 1; ++i) {
    int start = lxv[i];
    int end = lxv[i + 1];
    if(start < 0) start = 0;
    if(end > poly_x.size()) end = poly_x.size();
    if(start >= end) continue;
    NumericVector rx = poly_x[Rcpp::Range(start, end - 1)];
    NumericVector ry = poly_y[Rcpp::Range(start, end - 1)];
    LogicalVector ring_inside = geo_point_in_polygon_cpp(x, y, rx, ry);
    for(int p = 0; p < npts; ++p) {
      inside[p] = inside[p] ^ ring_inside[p];
    }
  }
  return inside;
}

// [[Rcpp::export]]
List geo_clip_polyline_to_rect_cpp(NumericVector x, NumericVector y,
                                   double xmin, double xmax, double ymin, double ymax) {
  std::vector<double> out_x;
  std::vector<double> out_y;
  int n = x.size();
  if(n == 0) {
    return List::create(Rcpp::Named("x") = NumericVector(0),
                        Rcpp::Named("y") = NumericVector(0));
  }
  out_x.reserve(n * 2);
  out_y.reserve(n * 2);

  bool has_prev = false;
  double prev_x = NA_REAL;
  double prev_y = NA_REAL;
  double start_x = NA_REAL;
  double start_y = NA_REAL;
  int part_len = 0;

  auto add_segment = [&](double x1, double y1, double x2, double y2) {
    double cx1, cy1, cx2, cy2;
    if(geo_clip_segment_to_rect_cpp(x1, y1, x2, y2, xmin, xmax, ymin, ymax,
                                    cx1, cy1, cx2, cy2)) {
      if(!out_x.empty()) {
        out_x.push_back(NA_REAL);
        out_y.push_back(NA_REAL);
      }
      out_x.push_back(cx1);
      out_y.push_back(cy1);
      out_x.push_back(cx2);
      out_y.push_back(cy2);
    }
  };

  for(int i = 0; i < n; ++i) {
    double xi = x[i];
    double yi = y[i];
    if(Rcpp::NumericVector::is_na(xi) || Rcpp::NumericVector::is_na(yi)) {
      if(part_len >= 2 && !(prev_x == start_x && prev_y == start_y)) {
        add_segment(prev_x, prev_y, start_x, start_y);
      }
      has_prev = false;
      part_len = 0;
      continue;
    }
    if(has_prev) {
      add_segment(prev_x, prev_y, xi, yi);
    }
    prev_x = xi;
    prev_y = yi;
    has_prev = true;
    if(part_len == 0) {
      start_x = xi;
      start_y = yi;
    }
    part_len++;
  }

  if(part_len >= 2 && !(prev_x == start_x && prev_y == start_y)) {
    add_segment(prev_x, prev_y, start_x, start_y);
  }

  return List::create(Rcpp::Named("x") = out_x, Rcpp::Named("y") = out_y);
}

// [[Rcpp::export]]
List geo_clip_polyline_to_polygon_cpp(NumericVector x, NumericVector y,
                                      NumericVector poly_x, NumericVector poly_y) {
  std::vector<double> out_x;
  std::vector<double> out_y;
  int n = x.size();
  int np = poly_x.size();
  if(n == 0 || np < 3) {
    return List::create(Rcpp::Named("x") = NumericVector(0),
                        Rcpp::Named("y") = NumericVector(0));
  }

  double poly_xmin = poly_x[0];
  double poly_xmax = poly_x[0];
  double poly_ymin = poly_y[0];
  double poly_ymax = poly_y[0];
  for(int i = 1; i < np; ++i) {
    double px = poly_x[i];
    double py = poly_y[i];
    if(px < poly_xmin) poly_xmin = px;
    if(px > poly_xmax) poly_xmax = px;
    if(py < poly_ymin) poly_ymin = py;
    if(py > poly_ymax) poly_ymax = py;
  }

  std::vector<double> ts;
  ts.reserve(16);

  auto add_segment = [&](double x1, double y1, double x2, double y2) {
    if(!out_x.empty()) {
      out_x.push_back(NA_REAL);
      out_y.push_back(NA_REAL);
    }
    out_x.push_back(x1);
    out_y.push_back(y1);
    out_x.push_back(x2);
    out_y.push_back(y2);
  };

  auto process_segment = [&](double x1, double y1, double x2, double y2) {
    if((std::min(x1, x2) > poly_xmax) || (std::max(x1, x2) < poly_xmin) ||
       (std::min(y1, y2) > poly_ymax) || (std::max(y1, y2) < poly_ymin)) {
      return;
    }

    ts.clear();
    for(int j = 0; j < np - 1; ++j) {
      double x3 = poly_x[j];
      double y3 = poly_y[j];
      double x4 = poly_x[j + 1];
      double y4 = poly_y[j + 1];
      double den = (x2 - x1) * (y3 - y4) - (y2 - y1) * (x3 - x4);
      if(std::abs(den) < 1e-12) continue;
      double s = ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)) / den;
      double t = ((x3 - x1) * (y3 - y4) - (y3 - y1) * (x3 - x4)) / den;
      if(t >= 0.0 && t <= 1.0 && s >= 0.0 && s <= 1.0) {
        ts.push_back(t);
      }
    }

    if(ts.empty()) {
      double mx = x1 + 0.5 * (x2 - x1);
      double my = y1 + 0.5 * (y2 - y1);
      if(geo_point_in_polygon_single_cpp(mx, my, poly_x, poly_y)) {
        add_segment(x1, y1, x2, y2);
      }
      return;
    }

    ts.push_back(0.0);
    ts.push_back(1.0);
    std::sort(ts.begin(), ts.end());
    ts.erase(std::unique(ts.begin(), ts.end(),
                         [](double a, double b){ return std::abs(a - b) < 1e-12; }),
             ts.end());
    for(size_t k = 0; k + 1 < ts.size(); ++k) {
      double t0 = ts[k];
      double t1 = ts[k + 1];
      double tm = 0.5 * (t0 + t1);
      double mx = x1 + tm * (x2 - x1);
      double my = y1 + tm * (y2 - y1);
      if(geo_point_in_polygon_single_cpp(mx, my, poly_x, poly_y)) {
        double ax = x1 + t0 * (x2 - x1);
        double ay = y1 + t0 * (y2 - y1);
        double bx = x1 + t1 * (x2 - x1);
        double by = y1 + t1 * (y2 - y1);
        add_segment(ax, ay, bx, by);
      }
    }
  };

  bool has_prev = false;
  double prev_x = NA_REAL;
  double prev_y = NA_REAL;
  double start_x = NA_REAL;
  double start_y = NA_REAL;
  int part_len = 0;

  for(int i = 0; i < n; ++i) {
    double xi = x[i];
    double yi = y[i];
    if(Rcpp::NumericVector::is_na(xi) || Rcpp::NumericVector::is_na(yi)) {
      if(part_len >= 2 && !(prev_x == start_x && prev_y == start_y)) {
        process_segment(prev_x, prev_y, start_x, start_y);
      }
      has_prev = false;
      part_len = 0;
      continue;
    }
    if(has_prev) {
      process_segment(prev_x, prev_y, xi, yi);
    }
    prev_x = xi;
    prev_y = yi;
    has_prev = true;
    if(part_len == 0) {
      start_x = xi;
      start_y = yi;
    }
    part_len++;
  }

  if(part_len >= 2 && !(prev_x == start_x && prev_y == start_y)) {
    process_segment(prev_x, prev_y, start_x, start_y);
  }

  return List::create(Rcpp::Named("x") = out_x, Rcpp::Named("y") = out_y);
}

// [[Rcpp::export]]
List geo_pointkriging_impl_cpp(NumericVector lat, NumericVector lon, NumericVector z,
                               NumericVector latgr, NumericVector longr,
                               NumericVector vgr, int maxnumber, double maxdist,
                               int option, int minnumber, double mz,
                               int zeroset, int varcalc, double sill,
                               IntegerVector reitur, int n, int m,
                               IntegerVector stdcrt, IntegerVector stdrrt,
                               IntegerVector dir, IntegerVector i1,
                               double rat, IntegerVector treitur,
                               Nullable<IntegerVector> isub = R_NilValue,
                               Nullable<IntegerVector> isubgr = R_NilValue,
                               int subareas = 0, int xy = 0, int suboption = 1) {
  int ngrid = latgr.size();
  NumericVector zgr(ngrid, mz);
  NumericVector variance(ngrid, 0.0);
  NumericVector lagrange(ngrid, 0.0);

  double range = vgr[0];
  double v_sill = vgr[1];
  double nugget = vgr[2];

  int ndata = lat.size();
  std::vector<double> sin_lat(ndata), cos_lat(ndata);
  if(xy == 0) {
    for(int i = 0; i < ndata; ++i) {
      sin_lat[i] = std::sin(lat[i]);
      cos_lat[i] = std::cos(lat[i]);
    }
  }

  int maxrt = 0;
  for(int i = 0; i < reitur.size(); ++i) {
    int rt = reitur[i];
    if(rt != NA_INTEGER && rt > maxrt) maxrt = rt;
  }
  std::vector< std::vector<int> > points_by_reit(maxrt + 1);
  for(int i = 0; i < reitur.size(); ++i) {
    int rt = reitur[i];
    if(rt == NA_INTEGER || rt <= 0) continue;
    points_by_reit[rt].push_back(i);
  }

  IntegerVector isub_vec;
  IntegerVector isubgr_vec;
  if(isub.isNotNull()) isub_vec = isub.get();
  if(isubgr.isNotNull()) isubgr_vec = isubgr.get();

  int i1_len = i1.size();

  for(int gi = 0; gi < ngrid; ++gi) {
    int nr = gi + 1;
    int rownr = (nr - 1) / n + 1;
    int colnr = nr - n * (rownr - 1);

    int qua[4] = {0, 0, 0, 0};
    std::vector<int> list_idx;
    std::vector<int> ldir;
    list_idx.reserve((int)std::ceil(rat * maxnumber) + 4);
    ldir.reserve((int)std::ceil(rat * maxnumber) + 4);

    int nrt = 0;
    bool sub = (subareas == 1 && isubgr.isNotNull() && isubgr_vec[nr - 1] > 0);

    for(int j1 = 0; j1 < i1_len - 1; ++j1) {
      int start = i1[j1] + 1;
      int end = i1[j1 + 1];
      if(start > end) continue;
      for(int ii = start; ii <= end; ++ii) {
        int idx = ii - 1;
        int crt = stdcrt[idx] + colnr;
        int rrt = stdrrt[idx] + rownr;
        if(rrt > 0 && crt > 0 && rrt <= (m + 1) && crt <= (n + 1)) {
          int rt = (rrt - 1) * (n + 1) + crt;
          if(rt > maxrt || rt < 0) continue;
          const std::vector<int> &pts = points_by_reit[rt];
          if(!pts.empty()) {
            nrt++;
            for(size_t p = 0; p < pts.size(); ++p) {
              int m1 = pts[p];
              if(!sub || isubgr_vec[nr - 1] == isub_vec[m1] || isubgr_vec[nr - 1] == 0 || isub_vec[m1] == 0) {
                int ddir = dir[idx];
                if(ddir < 1 || ddir > 4) ddir = 1;
                if(qua[ddir - 1] < rat / 2.0 * maxnumber) {
                  list_idx.push_back(m1);
                  ldir.push_back(ddir);
                  qua[ddir - 1] += 1;
                  if((int)list_idx.size() >= (int)(rat * maxnumber)) break;
                }
              }
              if((int)list_idx.size() >= (int)(rat * maxnumber)) break;
            }
          }
        }
        if((int)list_idx.size() >= (int)(rat * maxnumber)) break;
      }
      if(nrt >= maxnumber || (int)list_idx.size() >= (int)(rat * maxnumber)) break;
    }

    int nlist = list_idx.size();
    int maxnr = std::min(maxnumber, nlist);
    if(maxnr < minnumber) {
      zgr[gi] = mz;
      continue;
    }

    auto select_pts = [&](int option_local, int maxnr_local) {
      std::vector<int> finallist;
      if(nlist == 0) return finallist;
      std::vector<double> dist(nlist);
      if(xy == 1) {
        for(int k = 0; k < nlist; ++k) {
          int idx = list_idx[k];
          double dx = lat[idx] - latgr[gi];
          double dy = lon[idx] - longr[gi];
          dist[k] = std::sqrt(dx * dx + dy * dy);
        }
      } else {
        double sin_latgr = std::sin(latgr[gi]);
        double cos_latgr = std::cos(latgr[gi]);
        for(int k = 0; k < nlist; ++k) {
          int idx = list_idx[k];
          double val = sin_lat[idx] * sin_latgr + cos_lat[idx] * cos_latgr * std::cos(lon[idx] - longr[gi]);
          if(val > 1.0) val = 1.0;
          if(val < -1.0) val = -1.0;
          dist[k] = 6367.0 * std::acos(val);
        }
      }
      std::vector<int> order_idx(nlist);
      std::iota(order_idx.begin(), order_idx.end(), 0);
      std::sort(order_idx.begin(), order_idx.end(), [&](int a, int b){ return dist[a] < dist[b]; });

      if(option_local == 1) {
        if(maxdist > 0 && dist[order_idx[0]] > maxdist) return finallist;
        int keepn = std::min(maxnr_local, nlist);
        finallist.reserve(keepn);
        for(int k = 0; k < keepn; ++k) finallist.push_back(list_idx[order_idx[k]]);
        return finallist;
      }
      if(option_local == 2) {
        if(maxdist > 0 && dist[order_idx[0]] > maxdist) return finallist;
        for(int q = 1; q <= 4; ++q) {
          int qcount = 0;
          int qmax = std::max(1, maxnr_local / 4);
          for(int k = 0; k < nlist; ++k) {
            int idx = order_idx[k];
            if(ldir[idx] == q) {
              finallist.push_back(list_idx[idx]);
              qcount++;
              if(qcount >= qmax) break;
            }
          }
        }
        return finallist;
      }
      if(option_local == 3) {
        if(maxdist > 0 && dist[order_idx[0]] > maxdist) return finallist;
        int use_n = std::min(maxnr_local, nlist);
        for(int k = 0; k < use_n; ++k) {
          int idx = order_idx[k];
          int pt = list_idx[idx];
          dist[idx] = dist[idx] * treitur[pt];
          treitur[pt] = treitur[pt] + 1;
        }
        std::sort(order_idx.begin(), order_idx.end(), [&](int a, int b){ return dist[a] < dist[b]; });
        int keepn = std::min(maxnr_local, nlist);
        finallist.reserve(keepn);
        for(int k = 0; k < keepn; ++k) finallist.push_back(list_idx[order_idx[k]]);
        return finallist;
      }
      if(option_local == 4) {
        if(maxdist <= 0) return finallist;
        for(int k = 0; k < nlist; ++k) {
          if(dist[k] <= maxdist) finallist.push_back(list_idx[k]);
        }
        return finallist;
      }
      return finallist;
    };

    std::vector<int> finallist = select_pts(option, maxnr);
    if((int)finallist.size() > maxnumber) {
      finallist = select_pts(suboption, maxnumber);
    }
    if((int)finallist.size() < minnumber) {
      zgr[gi] = mz;
      continue;
    }

    int nsel = finallist.size();
    arma::mat cov(nsel + 1, nsel + 1, arma::fill::zeros);
    arma::vec rhs(nsel + 1, arma::fill::zeros);

    for(int a = 0; a < nsel; ++a) {
      int ia = finallist[a];
      for(int b = 0; b < nsel; ++b) {
        int ib = finallist[b];
        double d_ab = 0.0;
        if(xy == 1) {
          double dx = lat[ia] - lat[ib];
          double dy = lon[ia] - lon[ib];
          d_ab = std::sqrt(dx * dx + dy * dy);
        } else {
          double val = sin_lat[ia] * sin_lat[ib] + cos_lat[ia] * cos_lat[ib] * std::cos(lon[ia] - lon[ib]);
          if(val > 1.0) val = 1.0;
          if(val < -1.0) val = -1.0;
          d_ab = 6367.0 * std::acos(val);
        }
        if(subareas == 1 && isub.isNotNull() &&
           isub_vec[ia] != isub_vec[ib] && isub_vec[ia] != 0 && isub_vec[ib] != 0) {
          cov(a, b) = 0.0;
        } else {
          cov(a, b) = geo_spherical_cov_cpp(d_ab, range, v_sill, nugget);
        }
      }
      double d_grid = 0.0;
      if(xy == 1) {
        double dx = lat[ia] - latgr[gi];
        double dy = lon[ia] - longr[gi];
        d_grid = std::sqrt(dx * dx + dy * dy);
      } else {
        d_grid = geo_distance_latlon_rad_cpp(lat[ia], lon[ia], latgr[gi], longr[gi]);
      }
      rhs[a] = geo_spherical_cov_cpp(d_grid, range, v_sill, nugget);
      cov(a, nsel) = 1.0;
      cov(nsel, a) = 1.0;
    }
    cov(nsel, nsel) = 0.0;
    rhs[nsel] = 1.0;

    arma::vec weights;
    bool ok = arma::solve(weights, cov, rhs);
    if(!ok) {
      double meanz = 0.0;
      for(int a = 0; a < nsel; ++a) meanz += z[finallist[a]];
      meanz /= nsel;
      zgr[gi] = meanz;
      continue;
    }

    double est = 0.0;
    for(int a = 0; a < nsel; ++a) est += weights[a] * z[finallist[a]];
    if(zeroset == 1 && nsel >= 2) {
      if(z[finallist[0]] + z[finallist[1]] == 0.0) est = 0.0;
    }
    zgr[gi] = est;

    if(varcalc == 1) {
      double sumwr = 0.0;
      for(int a = 0; a < nsel + 1; ++a) sumwr += weights[a] * rhs[a];
      variance[gi] = sill * (1.0 - sumwr);
      lagrange[gi] = weights[nsel];
    }
  }

  return List::create(Rcpp::Named("zgr") = zgr,
                      Rcpp::Named("variance") = variance,
                      Rcpp::Named("lagrange") = lagrange);
}
