/*  Function that finds which points are inside a polygon */

#include <R.h>
#include <Rmath.h>
#include <Rinternals.h>

int lsign();


/* routine that sorts data */

void sort_c(arrinn,m,indxx)
  int     *m,*indxx;
double  *arrinn;

{
  int l,j,ir,indxt,i,n,*indx;
  double q,*arrin;
  
  arrin = arrinn-1; indx = indxx-1;
  n = *m;
  for (j=1;j<=n;j++)indx[j]=j;
  if(n ==1)return;
  l = (n >> 1) +1;
  ir = n;
  for(;;) {
    if(l>1)
      q = arrin[(indxt=indx[--l])];
    else {
      q = arrin[(indxt = indx[ir])];
      indx[ir]=indx[1];
      if ( --ir == 1){
        indx[1]=indxt;
        return;
      }
    }
    i = l;
    j = l <<1;
    while( j <= ir){
      if( j < ir && arrin[indx[j]] < arrin[indx[j+1]])j++;
      if(q < arrin[indx[j]]){
        indx[i]=indx[j];
        j += (i=j);
      }
      else j = ir+1;
    }
    indx[i] = indxt;
  }
}




void 
  geomarghc(x,y,n,xp,yp,lx,nlx,inni,tmpinni)
  
  double *x,*y,*xp,*yp;
int *n,*lx,*nlx,*inni,*tmpinni;

{
  
  int i,j,i1,i2;
  
  for(i1 =0; i1 <=*n-1 ;i1 ++) {
    inni[i1]=0;
    for(i2 =0; i2 <=*nlx-2; i2 ++){
      tmpinni[i2] = 0;
      for(i = lx[i2], j = lx[i2+1]-1 ; i < lx[i2+1] ; j = i++) {
        if(((( yp[i] <= y[i1]) && ( y[i1] < yp[j] )) ||
           (( yp[j] <= y[i1]) && ( y[i1] < yp[i] ))) && 
           ( x[i1]  < (xp[j] - xp[i])*(y[i1]-yp[i]) / 
           (yp[j] - yp[i]) + xp[i] ))
          tmpinni[i2] = !tmpinni[i2];
        /*        if(i2 == 0) inni[i1] = !inni[i1]; */
      }
    }
    if(tmpinni[0] == 1) {
      inni[i1] = 1;
      if(*nlx > 2) {
        for(i2 =1; i2 <=*nlx-2; i2 ++){
          if(tmpinni[i2] ==1)  inni[i1] = 0;
        }
      }
    }
  }
}


/*  Function that finds which points are inside a polygon */

void marghc(x,y,n,xp,yp,m,lx,nlx,inni,a,a1)
  
  double *x,*y,*xp,*yp,*a,*a1;
int *n,*m,*lx,*nlx,*inni;

{
  
  double eps,pi,a3[20],a4;
  int i,j,k ;
  
  eps = 1e-6;
  pi = 2*atan2(1.,0.);
  for(i=0; i<=*n-1 ;i++) {
    inni[i]=0; a4 =0;
    for(j=0; j<=*nlx-2; j++){
      a3[j]=0;
      for(k = lx[j]; k<=lx[j+1]-1; k++){
        a[k] = atan2(yp[k]-y[i]-eps*eps,xp[k]-x[i]-eps*eps);
        a[k] = a[k]-(lsign(a[k])-1)*pi;
      } 
      for(k = lx[j]+1; k<=lx[j+1]-1; k++) a1[k]=a[k]-a[k-1];
      a1[lx[j]]=a[lx[j]]-a[lx[j+1]-1];
      
      for(k = lx[j]; k<=lx[j+1]-1; k++){
        a1[k]= a1[k]+eps*(lsign(fabs(fabs(a1[k])-pi)-eps)-1);
        a1[k]=a1[k]-(lsign(a1[k]-pi)+1)*pi-(lsign(a1[k]+pi)-1)*pi;
        a3[j]=a3[j]+a1[k] ;
      }
      a4 = a4 + fabs(a3[j]) ;
    }
    if( fabs(a4-2.*pi) <= 0.1) inni[i]=1;
  }
}

int lsign(x)
  double(x) ;
{
    int sign1;
    if(x == 0) sign1=0;
    else if(x > 0) sign1 = 1;
    else sign1 = -1;
    return(sign1);
}



void skurdp( x1, y1, x2, y2, x3, y3, x4, y4,xs, ys,find, t1,s1) 
  
  double x1,y1,x2,y2,x3,y3,x4,y4,*xs,*ys,*t1,*s1;
int *find;

{
  double t,s,eps=1e-7,eps1=1e-6,det;
  
  if(fabs(x2-x1) < eps)x2=x2+eps1;
  if(fabs(x4-x3) < eps)x4=x4+eps1;
  if(fabs(y2-y1) < eps)y2=y2+eps1;
  if(fabs(y4-y3) < eps)y4=y4+eps1;
  
  det = (x2-x1)*(y3-y4)-(x3-x4)*(y2-y1);
  s = ((x2-x1)*(y3-y1)-(y2-y1)*(x3-x1)) /det;
  t = ((x3-x1)*(y3-y4)-(y3-y1)*(x3-x4)) /det;
  if(t <0 || t >1 || s <0 || s >1) *find=0;
  else { *find=1;*xs=x1+t*(x2-x1);*ys=y1+t*(y2-y1); }
  *t1 = t;*s1=s;
}

int inside(x,y,xb,yb,nxb,ab,ab1) 
  
  double *x,*y,*xb,*yb,*ab,*ab1;
int *nxb;
{
  int n,lx[2],nlx,inni;
  n=1;nlx=2;inni=0;
  lx[0]=0;lx[1]=*nxb-1;
  marghc(x,y,&n,xb,yb,nxb,lx,&nlx,&inni,ab,ab1);
  return(inni);
}




/*  Program that finds the longersection with any edge of a polygon 
 Can be any number up to 20.  */

void find_cut(x1,y1,x2,y2,xb,yb,nxb,xs,ys,nsk,side,order,ts,ss)
  double x1,y1,x2,y2,*xb,*yb,*xs,*ys,*ts,*ss;
int nxb,*nsk,*side,*order;

{
  int i,tmp=0,k=0;
  for(i = 0;i<nxb-1;i++) {
    skurdp(x1,y1,x2,y2,xb[i],yb[i],xb[i+1],yb[i+1],xs+k,ys+k,&tmp,ts+k,ss+k);
    if(tmp==1) {side[k]=i;k++;}
  }
  if(k>0)sort_c(ts,&k,order);
  *nsk=k;
}

/*  Defines a polygon that cuts an edge Do not allow the same line to cut twice */

void define_poly(x,y,xb,yb,xr,yr,n,nxb,nxr,mark,rside,rs,rt,ab,ab1,in_or_out)
  
  double *x,*y,*xb,*yb,*xr,*yr,*rs,*rt,*ab,*ab1;
int *n,*nxb,*nxr,*mark,*rside,in_or_out;

{
  int i,j,i2[2],nsk[1],i1,
  side[50],order[50];
  double xs[50],ys[50],ts[50],ss[50];
  
  i2[0]=1;i2[1]=0;
  i1 = inside(x,y,xb,yb,nxb,ab,ab1);
  if(in_or_out == 1) i1 = !i1;
  for ( i=0; i <*n-1;i++){
    find_cut(x[i],y[i],x[i+1],y[i+1],xb,yb,*nxb,xs,ys,nsk,side,order,ts,ss);
    if(*nsk==0 && i1 == 1) {
      xr[*nxr] = x[i];yr[*nxr]=y[i];(*nxr)++;
    }
    else {
      for(j=0;j<*nsk;j++){
        i1=i2[i1];
        if(j==0 && i1!=1){xr[*nxr]=x[i];yr[*nxr]=y[i];(*nxr)++;}
        if(i1==1)mark[*nxr]=2;else mark[*nxr]=1;
        rside[*nxr]=side[order[j]-1];rs[*nxr]=ss[order[j]-1];rt[*nxr]=ts[order[j]-1];
        xr[*nxr]=xs[order[j]-1];yr[*nxr]=ys[order[j]-1];(*nxr)++;
      }
    }
  }
}


void fill_in(s1,s2,up,xb,yb,nxb,xr,yr,nxr) 
  int s1,s2,*nxb,*nxr,up;
double *xb,*yb,*xr,*yr;
{
  int i;
  if(up==1) {
    if(s1 < s2){
      for(i=s1+1;i<=s2;i++){
        xr[*nxr]=xb[i];yr[*nxr]=yb[i];(*nxr)++;
      }
    }
    else {
      for(i=s1+1;i<*nxb;i++){
        xr[*nxr]=xb[i];yr[*nxr]=yb[i];(*nxr)++;
      }
      for(i=1;i<=s2;i++){
        xr[*nxr]=xb[i];yr[*nxr]=yb[i];(*nxr)++;
      }
    }
  }
  else {
    if(s1 > s2){
      for(i=s1;i>=s2+1;i--){
        xr[*nxr]=xb[i];yr[*nxr]=yb[i];(*nxr)++;
      }
    }
    else {
      for(i=s1;i>=0;i--){
        xr[*nxr]=xb[i];yr[*nxr]=yb[i];(*nxr)++;
      }
      for(i=*nxb-1;i>=s2+1;i--){
        xr[*nxr]=xb[i];yr[*nxr]=yb[i];(*nxr)++;
      }
    }
  }
}


void post_filter(s,side,up,mark,xp,yp,buid,n,xb,yb,nxb,xr,yr,nxr)
  
  int *s,*up,*mark,*n,*nxb,*buid,*nxr,*side;
double *xp,*yp,*xb,*yb,*xr,*yr;

{
  int k1,k2,bp,ind;
  k1 = k2 = bp  = 0;
  ind=1;
  while(k2 < *n) {
    if(buid[k1]==0 && (ind==0 || mark[k1]==2)){ 
      if(ind== 1) bp = k1;
      ind=0; /* Visar i byrjunarpunkt */
xr[*nxr]=xp[k1];yr[*nxr]= yp[k1];buid[k1]=1;(*nxr)++;k2++;
if(mark[k1]==1) {
  if(side[k1] != side[s[k1]-1]) fill_in(side[k1],side[s[k1]-1],up[k1],xb,yb,nxb,xr,yr,nxr);
  if(s[k1]-1 == bp){
    xr[*nxr]=xp[bp];yr[*nxr]=yp[bp];(*nxr)++;
    xr[*nxr]=yr[*nxr]=-999999;(*nxr)++;
    k1 = s[k1]-1;
    k1++; /* hlaupa yfir byrjunarpunkt.*/  
ind = 1;
  }
  else k1=s[k1]-1;
}
else k1++;
    }
    else k1++;
  }
}


/*  Defines the cutpoints of a line with a border */

void define_line(x,y,xb,yb,xr,yr,n,nxb,nxr,plot,ab,ab1)
  
  double *x,*y,*xb,*yb,*xr,*yr,*ab,*ab1;
int *n,*nxb,*nxr,*plot;

{
  int i,j,i2[2],nsk[1],i1,side[50],order[50],i3,nxr0;
  double xs[50],ys[50],ts[50],ss[50];
  
  i2[0]=1;i2[1]=0;
  nxr0 = *nxr; i3 = 0; 
  
  i1 = inside(x,y,xb,yb,nxb,ab,ab1);
  
  for ( i=0; i <*n-1;i++){
    find_cut(x[i],y[i],x[i+1],y[i+1],xb,yb,*nxb,xs,ys,nsk,side,order,ts,ss);
    if(*nsk>0) i3=1;
    if(*nsk==0 && i1 == 1) {
      xr[*nxr] = x[i];yr[*nxr]=y[i];(*nxr)++;
    }
    else {
      for(j=0;j<*nsk;j++){
        i1=i2[i1];
        if(i1==1) {
          xr[*nxr]=xs[order[j]-1];yr[*nxr]=ys[order[j]-1];(*nxr)++;}
        else {
          if(j==0){xr[*nxr]=x[i];yr[*nxr]=y[i];(*nxr)++;}
          xr[*nxr]=xs[order[j]-1];yr[*nxr]=ys[order[j]-1];(*nxr)++;
          xr[*nxr]=yr[*nxr]=-9999999;(*nxr)++;
        }
      }
    }
  }
  i1 = inside(x+*n-1,y+*n-1,xb,yb,nxb,ab,ab1);
  if(i1==1){xr[*nxr]=x[*n-1];yr[*nxr]=y[*n-1];(*nxr)++;}
  if(i3==0 && !*plot) *nxr=nxr0; /* ef oll lina inni */
}

/* Take number of line_segments and define cut points */

void define_multiline(x,y,xb,yb,xr,yr,n,nxb,nxr,li1,li2,nlx,plot,ab,ab1) 
  
  double *x,*y,*xb,*yb,*xr,*yr,*ab,*ab1;
int *n,*nxb,*nxr,*li1,*li2,*nlx,*plot;
{
  int i1,i2,i,n1;
  for(i=0;i<*nlx;i++) {
    i1 = li1[i]-1;
    i2 = li2[i]-1;
    n1 = i2-i1+1;
    if(i2-i1 > 0) define_line(x+i1,y+i1,xb,yb,xr,yr,&n1,nxb,nxr,plot,ab,ab1);
    if(*plot) {xr[*nxr]=yr[*nxr]=-9999999;(*nxr)++;}
  }
}

/* void define_multipoly(x,y,xb,yb,xr,yr,n,nxb,nxr,li1,li2,nlx,ab,ab1) */

/* double *x,*y,*xb,*yb,*xr,*yr,*ab,*ab1; */
/* int *n,*nxb,*nxr,*li1,*li2,*nlx; */
/* { */
/*   int i,i1,i2,n1; */
/*   int *mark,*rside; */
/*   double *rs,*rt; */


/*   for(i=0;i<*nlx;i++) { */
/*     i1 = li1[i]-1; */
/*     i2 = li2[i]-1; */
/*     n1 = i2-i1+1; */
/*     if(i2-i1 > 1)  */
/*       define_poly(x+i1,y+i1,xb,yb,xr,yr,&n1,nxb,nxr,mark,rside,rs,rt,ab,ab1); */
/*     xr[*nxr]=yr[*nxr]=-9999999;(*nxr)++; */
/*     } */

/* } */


double distance_x(x,y,x1,y1)
  double	x,y,x1,y1;
{
    double  dist;
    dist=sqrt((x-x1)*(x-x1)+(y-y1)*(y-y1));
    return(dist);
    
}

double distance(lat,lon,lat1,lon1)
  double	lat,lon,lat1,lon1;
{
    double 	dist,rad = 6367,tiny=1e-8;  /* radius of earth in km.  */
if((fabs(lat-lat1)+fabs(lon-lon1))<tiny)dist= 0; 
else dist = rad*acos(sin(lat)*sin(lat1)
                       +cos(lat)*cos(lat1)*cos(lon-lon1));
return(dist);

}

/* 	spherical program that calculates spherical variogram. */

double spherical(dist,range,sill,nugget)
  double dist,range,sill,nugget;

  {
    double	 x,cs;
    x = dist/range ;
    if( x > 1 ) cs = 0;
    else cs = (sill-(sill-nugget)*(1.5*x-0.5*x*x*x)-nugget);
    cs = cs/sill;
    return(cs);
  }
  
  
  
  
  void covmat(lat,lon,finallist,maxnr,vgr,cov,isub,subareas,dst)
    double 	*lat,*lon,*cov,*vgr;
  int	*finallist,maxnr,*isub,*subareas;
  double  (*dst)();
  {
    int 	i,j;
    double	dist;
    
    for (i=0;i<maxnr;i++) {
      for (j = 0;j<=i;j++){
        if(j == i) cov[i*(maxnr+1)+j] = 1;
        else if((*subareas==1) && (isub[i] !=isub[j]) && isub[i]!=0 && isub[j]!=0){
          cov[i*(maxnr+1)+j] =0;
          cov[j*(maxnr+1)+i] =0;		
        }	
        else {
          dist=dst(lat[finallist[i]],lon[finallist[i]],
                   lat[finallist[j]],lon[finallist[j]]);
          
          cov[i*(maxnr+1)+j] = spherical(dist,vgr[0],vgr[1],vgr[2]);
          cov[j*(maxnr+1)+i] = cov[i*(maxnr+1)+j];
        }
      }
    }
    i = maxnr;
    for (j = 0;j<maxnr;j++) {
      cov[i*(maxnr+1)+j]=1; cov[j*(maxnr+1)+i]=1;
    }
    cov[maxnr*(maxnr+1)+maxnr] = 0;
  }
  
  
  
  
  void rightside(lat,lon,finallist,latgr,longr,maxnr,vgr,rhgtside,dst)
    double 	*lat,*lon,*rhgtside,latgr,longr,*vgr;
  int	*finallist,maxnr;
  double  (*dst)();
  
  {
    int	i;
    double 	dist;
    for (i = 0;i<maxnr;i++){
      dist =dst(lat[finallist[i]],lon[finallist[i]],latgr,longr); 
      rhgtside[i]=spherical(dist,vgr[0],vgr[1],vgr[2]);
    }
    rhgtside[maxnr] = 1;
  }
  
  
  
  
  
  
  void ludcmp(a,n,indx,d,vv)
    int n,*indx;
  double *a,*d,*vv;
  {
    int i,imax=0,j,k;
    double big,dum,sum,temp;
    *d=1.0;
    for (i=0;i<=n-1;i++) {
      big=0.0;
      for (j=0;j<=n-1;j++)
        if ((temp=fabs(a[i*n+j])) > big) big=temp;
        if (big == 0.0) {/*printf("Singular matrix in routine LUDCMP")*/;return;} 
        vv[i]=1.0/big;
    }
    for (j=0;j<=n-1;j++) {
      for (i=0;i<j;i++) {
        sum=a[i*n+j];
        for (k=0;k<i;k++) sum -= a [i*n+k]*a[k*n+j];
        a[i*n+j]=sum;
      }
      big=0.0;
      for (i=j;i<n;i++) {
        sum=a[i*n+j];
        for (k=0;k<j;k++)
          sum -= a[i*n+k]*a[k*n+j];
        a[i*n+j]=sum;
        if ( (dum=vv[i]*fabs(sum)) >= big) {
          big=dum;
          imax=i;
        }
      }
      if (j != imax) {
        for (k=0;k<n;k++) {
          dum=a[imax*n+k];
          a[imax*n+k]=a[j*n+k];
          a[j*n+k]=dum;
        }
        *d = - (*d);
        vv[imax]=vv[j];
      }
      indx[j]=imax;
      if (a[j*n+j] == 0.0) a[j*n+j]=1.0e-20;
      if (j != n-1) {
        dum=1.0/(a[j*n+j]);
        for (i=j+1;i<n;i++) a[i*n+j] *= dum;
      }
    }
    /*	free_vector(vv,i,n); */
  }
  
#
  
  
  
  void lubksb(a,n,indx,b)
    double	 *a,*b;
  int	 n,*indx;
  {
    int i,ii=-1,ip,j;
    double sum;
    
    for (i=0;i<n;i++) {
      ip=indx[i];
      sum=b[ip];
      b[ip]=b[i];
      if (ii!=-1)
        for (j=ii;j<=i-1;j++) sum -= a[i*n+j]*b[j];
      else if (sum) ii=i;
      b[i]=sum;
    }
    for (i=n-1;i>=0;i--) {
      sum=b[i];
      for (j=i+1;j<n;j++) sum -= a[i*n+j]*b[j];
      b[i]=sum/a[i*n+i];
    }
  }
  
  
  void solve(a,b,d,n,indx,v)
    double	*a,*b,*d,*v;
  int 	*n,*indx;
  
  {
    ludcmp(a,*n,indx,d,v);
    lubksb(a,*n,indx,b);
  }
  
  
  
  
  
  
  
  /* #include <math.h> */
  
  /* void indexx(arrinn,m,indxx) */
  /* int     *m,*indxx; */
  /* double  *arrinn; */
  
  /* { */
  /*         int l,j,ir,indxt,i,n,*indx; */
  /*         double q,*arrin; */
  
  /* 	arrin = arrinn-1; indx = indxx-1; */
  /* 	n = *m; */
  /*         for (j=1;j<=n;j++)indx[j]=j; */
  /*         if(n ==1)return; */
  /*         l = (n >> 1) +1; */
  /*         ir = n; */
  /*         for(;;) { */
  /*                 if(l>1) */
  /*                         q = arrin[(indxt=indx[--l])]; */
  /*                 else { */
  /*                         q = arrin[(indxt = indx[ir])]; */
  /*                         indx[ir]=indx[1]; */
  /*                         if ( --ir == 1){ */
  /*                                 indx[1]=indxt; */
  /*                                 return; */
  /*                         } */
  /*                 } */
  /*                 i = l; */
  /*                 j = l <<1; */
  /*                 while( j <= ir){ */
  /*                         if( j < ir && arrin[indx[j]] < arrin[indx[j+1]])j++; */
  /*                         if(q < arrin[indx[j]]){ */
  /*                                 indx[i]=indx[j]; */
  /*                                 j += (i=j); */
  /*                         } */
  /*                         else j = ir+1; */
  /*                 } */
  /*                 indx[i] = indxt; */
  /*         } */
  /* } */
  
  
  /* example of a c program called by Splus.*/
  
  void capply(a,na,index,index1,nr,nc,operation,outcome,number)
    
    double	*a,*outcome;
  int	*na,*nr,*nc,*index,*index1,*operation,*number;
  
  {
    
    int	i;
    
    if( *operation == 1){ /* sum  */
  for(i =0;i<*na;i++ ){
    outcome[(index1[i]-1)*(*nr)+index[i]-1]=outcome[(index1[i]-1)*(*nr)+index[i]-1]+a[i];
    number[(index1[i]-1)*(*nr)+index[i]-1]=1;
  }
    }
  }
  
  
  /*      program elcont
   program that in connection with a Splus program makes shaded 
   contour lines.   */
  
  
  
  
  void element(nx,ny,el,nel) 
    
    int     nx,ny,nel,el[][4];
  
    {
      
      int i,j;
      
      for(i=0; i<=nx-2;i++){
        for(j=0; j<=ny-2;j++){
          el[j*(nx-1)+i][0]=i+nx*j;
          el[j*(nx-1)+i][1]=i+nx*j+1;
          el[j*(nx-1)+i][2]=i+nx*(j+1)+1;
          el[j*(nx-1)+i][3]=i+nx*(j+1);
        }
      }
    }
    
    
    void csort(z,ind)  /*  sort the values */
  
  double *z;
    int *ind;
    
    {
      int     i1[3]={0,0,0},i;
      
      if(z[ind[0]]>=z[ind[1]] && z[ind[1]]>=z[ind[2]]) {
        i1[0]=ind[2];i1[1]=ind[1];i1[2]=ind[0];}
      else if(z[ind[0]]>=z[ind[2]] && z[ind[2]]>=z[ind[1]]) {
        i1[0]=ind[1];i1[1]=ind[2];i1[2]=ind[0];}
      else if(z[ind[1]]>=z[ind[0]] && z[ind[0]]>=z[ind[2]]) {
        i1[0]=ind[2];i1[1]=ind[0];i1[2]=ind[1];}
      else if(z[ind[1]]>=z[ind[2]] && z[ind[2]]>=z[ind[0]]) {
        i1[0]=ind[0];i1[1]=ind[2];i1[2]=ind[1];}
      else if(z[ind[2]]>=z[ind[1]] && z[ind[1]]>=z[ind[0]]) {
        i1[0]=ind[0];i1[1]=ind[1];i1[2]=ind[2];}
      else if(z[ind[2]]>=z[ind[0]] && z[ind[0]]>=z[ind[1]]) {
        i1[0]=ind[1];i1[1]=ind[0] ;i1[2]=ind[2];}
      
      for (i=0;i<=2;i++){ind[i]=i1[i];}
    }
    
    void sort(arrinn,m,indxx)
      int     *m,*indxx;
    double  *arrinn;
    
    {
      int l,j,ir,indxt,i,n,*indx;
      double q,*arrin;
      
      arrin = arrinn-1; indx = indxx-1;
      n = *m;
      for (j=1;j<=n;j++)indx[j]=j;
      if(n ==1)return;
      l = (n >> 1) +1;
      ir = n;
      for(;;) {
        if(l>1)
          q = arrin[(indxt=indx[--l])];
        else {
          q = arrin[(indxt = indx[ir])];
          indx[ir]=indx[1];
          if ( --ir == 1){
            indx[1]=indxt;
            return;
          }
        }
        i = l;
        j = l <<1;
        while( j <= ir){
          if( j < ir && arrin[indx[j]] < arrin[indx[j+1]])j++;
          if(q < arrin[indx[j]]){
            indx[i]=indx[j];
            j += (i=j);
          }
          else j = ir+1;
        }
        indx[i] = indxt;
      }
    }
    
    void triangle(x1,y1,z1,x2,y2,z2,x3,y3,z3,polyx,polyy,npoly,ncont,cont)
      
      double  x1,y1,z1,x2,y2,z2,x3,y3,z3,*cont,polyy[][6],polyx[][6];
    int     npoly[],ncont;
    {
      int i,ind,indmax,nct12,nct23,nct13,nc12[160],nc13[160],nc23[160];
      double xc12[160],yc12[160],xc23[160],yc23[160],xc13[160],yc13[160],rat,rat1;
      
      for(i =0 ; i<=ncont-1; i++){
        nc13[i]=0;nc12[i]=0;nc23[i]=0;
      }
      nct12=0;nct13=0;nct23=0;ind=0;indmax=0; 
      
      
      /* find intersection of lines with edges of triangles.   */
      /* corner points of triangles arranged so z1<z2<z3 */
      
      
      for(i=0; i <= ncont-1 ; i++){
        if(cont[i] > z3 && indmax == 0)indmax=i;
        if(cont[i] > z1 && cont[i] < z2 ) {
          if(ind == 0) ind = i ; 
          rat  = (cont[i] - z1 )/(z2-z1) ;
          rat1 = (cont[i] - z1 )/(z3-z1) ;
          xc12[i] = x1 + rat*(x2-x1) ; 
          yc12[i] = y1 + rat*(y2-y1) ; 
          xc13[i] = x1 + rat1*(x3-x1) ; 
          yc13[i] = y1 + rat1*(y3-y1) ;
          nct12++ ; nct13++;nc12[i]++;nc13[i]++;
        }
        else if( cont[i] > z2 && cont[i] < z3 ) {       
          if(ind==0) ind=i;       
          rat  = (cont[i] - z2 )/(z3-z2) ;
          rat1 = (cont[i] - z1 )/(z3-z1) ;
          xc23[i] = x2 + rat*(x3-x2) ; 
          yc23[i] = y2 + rat*(y3-y2) ; 
          xc13[i] = x1 + rat1*(x3-x1) ; 
          yc13[i] = y1 + rat1*(y3-y1) ; 
          nct23++ ; nct13++;nc23[i]++;nc13[i]++;
        }
      }
      /*      Make the polygons.  */
      
      if(nct13 == 0) {
        polyx[indmax][0] = x1 ; polyx[indmax][1] = x2;
        polyx[indmax][2] = x3; 
        polyy[indmax][0] = y1 ; polyy[indmax][1] = y2;
        polyy[indmax][2] = y3; npoly[indmax]=3;
      }
      else {
        if(nc12[ind] != 0) {
          polyx[ind][0] = xc12[ind] ; polyx[ind][1] = xc13[ind];
          polyx[ind][2] = x1; 
          polyy[ind][0] = yc12[ind] ; polyy[ind][1] = yc13[ind];
          polyy[ind][2] = y1; npoly[ind]=3;
          
        }
        else if( nc23[ind]  != 0) { 
          polyx[ind][0] = xc23[ind] ; polyx[ind][1] = xc13[ind];
          polyx[ind][2] = x1; polyx[ind][3] = x2; 
          polyy[ind][0] = yc23[ind] ; polyy[ind][1] = yc13[ind];
          polyy[ind][2] = y1; polyy[ind][3] = y2; npoly[ind]=4;
        }
        if(indmax >  ind+1) {
          for( i = ind+1 ; i< indmax ; i++) {
            if(nc12[i-1] != 0) {
              if(nc12[i] != 0) { 
                polyx[i][0] = xc12[i] ; 
                polyx[i][1] = xc13[i];
                polyx[i][2] = xc13[i-1] ; 
                polyx[i][3] = xc12[i-1];
                polyy[i][0] = yc12[i] ; 
                polyy[i][1] = yc13[i];
                polyy[i][2] = yc13[i-1] ; 
                polyy[i][3] = yc12[i-1];
                npoly[i] = 4;
              }
              else if(nc23[i] != 0){
                polyx[i][0] = xc23[i] ; 
                polyx[i][1] = xc13[i];
                polyx[i][2] = xc13[i-1] ; 
                polyx[i][3] = xc12[i-1];
                polyx[i][4] = x2;
                polyy[i][0] = yc23[i] ; 
                polyy[i][1] = yc13[i];
                polyy[i][2] = yc13[i-1] ; 
                polyy[i][3] = yc12[i-1];
                polyy[i][4] = y2;
                npoly[i] = 5;
              }
            }
            else if(nc23[i-1] !=0 ){    
              if(nc23[i] != 0){
                polyx[i][0] = xc23[i] ; 
                polyx[i][1] = xc13[i];
                polyx[i][2] = xc13[i-1] ; 
                polyx[i][3] = xc23[i-1];
                polyy[i][0] = yc23[i] ; 
                polyy[i][1] = yc13[i];
                polyy[i][2] = yc13[i-1] ; 
                polyy[i][3] = yc23[i-1];
                npoly[i] = 4;
              }
            }
          }
        }
        
        /*      Final point of triangle.  */
        
        
        if(nc12[indmax-1] != 0) {
          polyx[indmax][0] = xc12[indmax-1] ; 
          polyx[indmax][1] = xc13[indmax-1];
          polyx[indmax][2] = x3;
          polyx[indmax][3] = x2;
          polyy[indmax][0] = yc12[indmax-1] ; 
          polyy[indmax][1] = yc13[indmax-1];
          polyy[indmax][2] = y3;
          polyy[indmax][3] = y2;
          npoly[indmax]= 4 ;  
        }
        else {
          polyx[indmax][0] = xc23[indmax-1];
          polyx[indmax][1] = xc13[indmax-1];
          polyx[indmax][2] = x3;
          polyy[indmax][0] = yc23[indmax-1] ; 
          polyy[indmax][1] = yc13[indmax-1];
          polyy[indmax][2] = y3;
          npoly[indmax] = 3;  
        }
      }       
      
    }
    
    
    
    
    
    
    
    
    /*  elcont divides each rectangle into 4 triangles and finds the
     location of the contour lines in the rectangle.  */
    
    void elcont(x1,y1,z1,lx1,nx,ny,cont,ncont,polyx,polyy,el,nel,
                maxsize,err,inni,cutreg,indd,white)   
      
      double *x1,*y1,*z1,*cont,*polyx,*polyy;
    int *nx,*ny,*ncont,*lx1,*nel,el[][4],*maxsize,*err,
    *inni,*cutreg,*indd,*white;
    
    {
      
      
      
      int   i,j,j1,j2,ind[3],npoly1[160],index[4],
                                              cind,k,inni1[4],suminni,kb,buid,ns=4;
      
      double  polyx1[160][6],polyy1[160][6],
                                        x[5],y[5],z[5];
      
      
      cind=0 ;
      *nel= (*nx-1)*(*ny-1);
      element(*nx,*ny,el,*nel);  /* find the number of elements */
    
    for(i=0 ; i<=*nel-1 ; i++){
      
      suminni = 0; /*  for checks if inside */
    for(j =0  ; j<=3 ; j++){
      x[j]= x1[el[i][j]] ; y[j]= y1[el[i][j]]; 
      z[j]=z1[el[i][j]];  
      if(*cutreg==1 ) { inni1[j] = inni[el[i][j]]; /*borders included */
    suminni= suminni+inni1[j];}
    }
    buid = 0;
    
    /*      Find center of rectangle and  the value at it.  */
    
    /*      Check if some parts of the rectangle are outside the borders. */
    
    if(z[0]< -99998 || z[1] < -99998 || z[2] <  -99998 || z[3] < -99998) {
      x[4] = (x[0]+x[1]+x[2]+x[3])/4;
      y[4] = (y[0]+y[1]+y[2]+y[3])/4;
      z[4] =0;
      j2 = 0;
      for(k=0;k<=3;k++){
        if(z[k] > -99998){z[4]=z[4]+z[k];j2++;}
      }
      buid = 1;
      if( j2>0  ) {
        z[4] = z[4]/j2;
        for(j = 0;j <=3;j++){
          for(j1 =0  ; j1 <=159; j1++ ){
            npoly1[j1]=0;
          }
          ind[0]=indd[j*3]; ind[1]=indd[j*3+1]; 
          ind[2]=indd[j*3+2];                             
          csort(z,ind);  /*  sort the values */
    if(z[ind[0]] > -99998) {        /* outside borders */
    triangle(x[ind[0]],y[ind[0]],z[ind[0]],x[ind[1]],y[ind[1]],z[ind[1]],
             x[ind[2]],y[ind[2]],z[ind[2]],polyx1,polyy1,npoly1,*ncont,cont);
      if ( *white == 1)kb = 1 ; else kb=0;
      for( k = kb; k<=*ncont-1 ; k++){
        if(npoly1[k]!=0){
          for (j1=0; j1<=npoly1[k]-1;j1++){
            polyx[cind] = polyx1[k][j1];
            polyy[cind] = polyy1[k][j1];
            cind++;
          }
          polyx[cind]=cont[k]; polyy[cind]=99999 ;cind++; 
          if(cind>*maxsize-6){
            /*printf(" Not enough space.Add ca. %d  \n",
             ((*nel/(k-2))-1)*(*maxsize));*/ *err=1;return ; }
        }
      }
    }
        }
      }
    }
    
    
    /*      Finished handling borders */
    
    /*      Look if the whole elementis in the same contourline.  */
    if((*cutreg==0 || suminni != 0) && buid == 0){
      buid=0;
      sort(z,&ns,index);
      buid = 0;
      for (k=0;k<*ncont-1;k++) {
        if(z[index[0]-1] <=  cont[k]){
          if(z[index[3]-1] <= cont[k]){ 
            if(*white == 0 || k!=1){
              for( j= 0;j<=3;j++){
                polyx[cind] = x[j];
                polyy[cind] = y[j];
                cind++;
              }                               
              polyx[cind] = cont[k];
              polyy[cind] = 99999;
              cind++;
              buid = 1;
            }
            else buid=1;
          }
          break;
        }
      }
      
      
      if ( buid == 0) {
        x[4] = (x[0]+x[1]+x[2]+x[3])/4;
        y[4] = (y[0]+y[1]+y[2]+y[3])/4;
        z[4] = (z[0]+z[1]+z[2]+z[3])/4;
        
        /*                              Divide rectangle in 4 triangles, find contours for each of 
         them.  */
        
        
        for(j = 0;j <=3;j++){
          for(j1 =0  ; j1 <=159; j1++ ){
            npoly1[j1]=0;
          }
          ind[0]=indd[j*3]; ind[1]=indd[j*3+1]; 
          ind[2]=indd[j*3+2];csort(z,ind);  /*  sort the values */
        triangle(x[ind[0]],y[ind[0]],z[ind[0]],x[ind[1]],y[ind[1]],z[ind[1]],
                 x[ind[2]],y[ind[2]],z[ind[2]],polyx1,polyy1,npoly1,*ncont,cont);
        
        /*      Combine polygons   */
        
        if ( *white == 1)kb = 1 ; else kb=0;
        for( k = kb; k<=*ncont-1 ; k++){
          if(npoly1[k]!=0){
            for (j1=0; j1<=npoly1[k]-1;j1++){
              polyx[cind] = polyx1[k][j1];
              polyy[cind] = polyy1[k][j1];
              cind++;
            }
            polyx[cind]=cont[k]; polyy[cind]=99999 ;cind++; 
            if(cind>*maxsize-6){
              /*printf(" Not enough space.Add ca. %d  \n",
               ((*nel/(k-2))-1)*(*maxsize));*/ *err=1;return ; }
          }
        }
        }
      }
    }
    }
    
    }
    
    
    
    /* Function that marks propable points in the neighbourhood of a point
     that is to be estimated.            */
    
    double distance(),spherical(),distance_x();
    /*void covmat(),rightside(),sort_c(),solve();*/
    
    
    void neighbour(nr,reitur,n,m,npts_in_reit,pts_in_reit,indrt,maxnr,stdcrt,stdrrt,
                   dir,i1,li1,list,nlist,ldir,rat,isub,isubgr,subareas)
      
      int     nr,*reitur,*npts_in_reit,*pts_in_reit,maxnr,*list,*nlist,n,m,
      *stdcrt,*stdrrt,*dir,*ldir,*indrt,*i1,li1,*isub,*isubgr,*subareas;
    double  rat;
    
    {
      int colnr,rownr,i,j1,crt,rrt,k,rt,j,nrt=0,sub=0,m1,qua[5];    
      
      rownr = (nr)/n + 1; colnr = nr+1 - n*(rownr-1); /* Number of point */
    rt = (rownr-1)*(n+1) + colnr;
    for(i=1;i<=4;i++)qua[i]=0;
    
    if((*subareas==1) && (isubgr[nr]>0))sub=1;    /* check areas*/
    
    /*    Find the neighbourhoods.  */
    
    
    k = 0 ;
    for (j1 = 0;j1<li1-1;j1++){   
      for (i=i1[j1];i<i1[j1+1];i++) { 
        crt = stdcrt[i]+colnr;
        rrt = stdrrt[i]+rownr;
        if(rrt>0 && crt>0 && rrt<=(m+1) && crt <= (n+1) ){
          rt=(rrt-1)*(n+1)+crt;
          if(npts_in_reit[rt] >0 ){
            nrt++;
            for( j=0;j<npts_in_reit[rt];j++) {
              m1 = pts_in_reit[indrt[rt]+j];
              if((sub==0) || (isubgr[nr]==isub[m1])||isubgr[nr]==0||isub[m1]==0){
                if(qua[dir[i]]<rat/2*maxnr) {
                  list[k] = m1;
                  ldir[k] = dir[i];qua[dir[i]]++;k++;/* Number of quadrant */
                }
              }
              if(k == (500-1)) {
                /*              printf("warning 2"); */
                break;
              }
            }
          }
        }
      }
      if( nrt >=maxnr || k > rat*maxnr) break; 
    }
    *nlist = k-1;
    }
    
    
    
    /*      select_pts 
     Function that selects the best points according to certain
     criteria from a list returned by the program neighbour.   */
    
    void select_pts(latgr,longr,list,ldir,nlist,lat,lon,maxnr,option,finallist,nr,treitur,maxdist,order,dist,
                    xnewint,dst)
      
      double     latgr,longr,*lat,*lon,*maxdist,*dist;
    int        *list,*ldir,nlist,*finallist,*maxnr,option,nr,*treitur,*order,*xnewint;
    double  (*dst)();
    
    {       
      int   i,qua[5],k,j,minnumber,k1;
      minnumber = nlist/10; if(minnumber <2 && *maxnr >8 )minnumber=2;
      for(i=1;i<=4;i++)qua[i]=0;
      
      for( i=0;i<=nlist;i++) {      
        dist[i]=dst(latgr,longr,lat[list[i]],lon[list[i]]);
        qua[ldir[i]]++;             /* Number of points in quadrant */
      }
      if(option==1){  /* No care taken of direction in which points are */
    nlist ++;sort_c(dist,&nlist,order);nlist--;
    for (i = 0; i<*maxnr;i++)finallist[i]=list[order[i]-1];
    if(*maxdist > 0) {
      if(dist[order[0]-1]>*maxdist) *maxnr = 0; /* too faraway from datapoints */
    }
      }
      else if(option==2) { /* Care taken of directions quadrant search */
    nlist++;sort_c(dist,&nlist,order);nlist --;
    if(*maxdist >0 ){ /* check minimum distance */
    if(dist[order[0]-1] > *maxdist) *maxnr=0;
    }
    if(*maxnr == 0) k=0;
    else {
      k = 0;
      for(i = 1;i <= 4;i++){
        k1 = 0;
        for(j=0;j<=nlist;j++){
          if(ldir[order[j]-1]==i){
            finallist[k] = list[order[j]-1];k++;k1++;
            if(k1 > *maxnr/4-1) break;
          }
        } 
      }
    }
    *maxnr = k; 
      }
      else if(option==3) { /* Points in each square */
    nlist ++;sort_c(dist,&nlist,order);nlist--;
    if(*maxdist >0 ){ /* check minimum distance */
    if(dist[order[0]-1] > *maxdist) *maxnr=0;
    }           
    for(i = 0; i <*maxnr;i++){ 
      dist[order[i]-1] =dist[order[i]-1]*treitur[list[order[i]-1]];
      treitur[list[order[i]-1]]++;
    }
    for(i = 0;i<*maxnr;i++)treitur[list[order[i]-1]]++;
    nlist ++;sort_c(dist,&nlist,order);nlist--;
    for (i = 0; i<*maxnr;i++) finallist[i] = list[order[i]-1];
      }                             
      else if(option ==4){ /* All points within given distance */
    k=0;        
        for(i=0;i<nlist;i++){ 
          if(dist[i]< *maxdist){finallist[k]=list[i];k++;}          
        }
        *maxnr = k; 
      }
      /*    more efficient to put right hand side in here but for the
       structure of the program is it not done.   */
    }
    
    /*      pointkriging
     Function that does pointkriging.  The function involves
     neighbourhood search algorithm that searches for likely 
     points to use.  
     */
    
    void c_pointkriging(lat,lon,z,nlat,latgr,longr,zgr,nlatgr,reitur,n,m,pts_in_reit,
                        npts_in_reit,maxnumber,vgr,stdcrt,stdrrt,dir,i1,li1,option,inni,
                        cov,rhgtside,x,indrt,jrt,maxrt,treitur,rat,maxdist,mz,isub,isubgr,
                        subareas,variance,varcalc,rhgtsbck,sill,minnumber,suboption,x_y,degree,lagrange,
                        zeroset)
      
      double *lat,*lon,*latgr,*longr,*z,*vgr,*zgr,*cov,*x,*rhgtside,*maxdist,*rat,*mz,
      *rhgtsbck,*sill,*variance,*lagrange;
    
    int        *reitur,*n,*m,*nlat,*nlatgr,*stdcrt,*stdrrt,*dir,*pts_in_reit,
    *npts_in_reit,*option,*inni,*maxnumber,*indrt,*jrt,*maxrt,*i1,*li1,*treitur,
    *isub,*isubgr,*subareas,*varcalc,*minnumber,*suboption,*x_y,*degree,*zeroset;
    
    
    {
      int   i,j,ldir[500],list[500],nlist,finallist[500],order[500],maxnr,
      xnewint[500];
      double        dist[500],d,z1;
      double (*dst)(); /* pointer to distance function */
    if(*x_y==1) dst=distance_x;else dst=distance;
    for ( i=0; i <*nlat;i++){  
      
      npts_in_reit[reitur[i]]++;
    }
    for( i = 0; i<*maxrt;i++){
      indrt[i+1]=indrt[i]+npts_in_reit[i];
    }
    for ( i=0; i <*nlat;i++){
      if(npts_in_reit[reitur[i]]>0){
        pts_in_reit[indrt[reitur[i]]+jrt[reitur[i]]]=i;
        jrt[reitur[i]]++;
      }
    }
    for ( i=0; i <*nlatgr;i++) {
      if(inni[i] ==1 ) {
        neighbour(i,reitur,*n,*m,npts_in_reit,pts_in_reit,indrt,*maxnumber,
                  stdcrt,stdrrt,dir,i1,*li1,list,&nlist,ldir,*rat,isub,isubgr,subareas);
        if(nlist < *maxnumber) { maxnr = nlist;}
        else {maxnr = *maxnumber;}
        if(maxnr > *minnumber){
          select_pts(latgr[i],longr[i],list,ldir,nlist,lat,lon,&maxnr,*option,
                     finallist,i,treitur,maxdist,order,dist,xnewint,dst);
          if(maxnr<*minnumber){ zgr[i]=*mz;}
          else {
            if(maxnr> *maxnumber){
              maxnr = *maxnumber;
              *option = *suboption;
              select_pts(latgr[i],longr[i],list,ldir,nlist,lat,lon,&maxnr,*option,
                         finallist,i,treitur,maxdist,order,dist,xnewint,dst);
              *option=4;
            }
            
            covmat(lat,lon,finallist,maxnr,vgr,cov,isub,subareas,dst);
            rightside(lat,lon,finallist,latgr[i],longr[i],maxnr,
                      vgr,rhgtside,dst);
            maxnr++; 
            /* backup of right hand side */ 
            for(j =0;j<maxnr;j++)rhgtsbck[j]=rhgtside[j]; 
            solve(cov,rhgtside,&d,&maxnr,order,dist);
            for (j=0;j<(maxnr-1);j++) {
              zgr[i]=zgr[i]+rhgtside[j]*z[finallist[j]]; }
            
            if(*zeroset==1){ /* set to zero if zeroes are near */
            z1 = 0;
              for(j=0;j<2;j++) {
                z1 = z1+z[finallist[j]];
              }
              if(z1==0)zgr[i] =0;
            }
            
            
          }
          /*              Calculate variance */
          if(*varcalc == 1) {
            for(j=0;j<maxnr;j++)
              variance[i]=variance[i]+rhgtside[j]*rhgtsbck[j];
            variance[i] = *sill*(1-variance[i]);
            lagrange[i] = rhgtside[maxnr-1]; /* Lagranges multiplier */
          }
        }
        else zgr[i] = *mz; /* no point found */
      }
    }
    }
    
    
    
    
    /*	combinert
     Function that combines extremely dense data.  Takes average within
     each small square defined by latgr and longr) median and sdev later
     */
    
    void combinert(lat,lon,z,nlat,reitur,pts_in_reit,npts_in_reit,indrt,jrt,maxrt,
                   newlat,newlon,newz,newn,nnewlat,option,fill,fylla,grdlat,grdlon,n,minnumber,
                   wsp,nr,order,wlat,rat,wz)
      
      double	*lat,*lon,*z,*newlat,*newlon,*newz,*grdlat,*grdlon,*wsp,*wz,*wlat,*rat;
    
    int *nlat,*reitur,*pts_in_reit,*npts_in_reit,*indrt,*jrt,*maxrt,*nnewlat,*option,*newn,
    *fill,*fylla,*n,*minnumber,*nr,*order;
    
    {
      int	i,j,k,m1,rnr,cnr,nr_out,nr1_out,j1;
      double 	tmp,tmp1,tmp2=0.0;
      
      k=0;
      for ( i=0; i <*nlat;i++){  
        npts_in_reit[reitur[i]]++;
      }
      for( i = 0; i<*maxrt;i++){
        indrt[i+1]=indrt[i]+npts_in_reit[i];
      }
      for ( i=0; i <*nlat;i++){
        if(npts_in_reit[reitur[i]]>0){
          pts_in_reit[indrt[reitur[i]]+jrt[reitur[i]]]=i;
          jrt[reitur[i]]++;
        }
      }
      k = 0;
      if(*option == 6) { /* allt */
    for ( i=1; i <=*maxrt;i++) {
      if(npts_in_reit[i]>=*minnumber){
        for(j=0;j<npts_in_reit[i];j++){
          m1 = pts_in_reit[indrt[i]+j];
          newlat[k]=lat[m1];
          newlon[k]=lon[m1];
          newz[k]=z[m1];
          newn[k]=npts_in_reit[i];
          fylla[k]=0;
          k++;
        }
      }
      
      else {
        if(*fill == 1) {
          rnr = (i-1)/(*n-1);
          cnr = i- (rnr)*(*n-1);
          newlat[k] = grdlat[rnr];newlon[k]=grdlon[cnr-1];newz[k] = 0;
          fylla[k] = 1;k++;
        }
      }
    }
      }
      
      if(*option == 1  ) { /* mean */
    for ( i=1; i <=*maxrt;i++) {
      if(npts_in_reit[i]>=*minnumber){ 
        tmp1 = tmp2 = 0;
        for(j=0;j<npts_in_reit[i];j++){
          m1 = pts_in_reit[indrt[i]+j];
          newlat[k]=newlat[k]+lat[m1]*wlat[m1];
          newlon[k]=newlon[k]+lon[m1]*wlat[m1];
          newz[k]=newz[k]+z[m1]*wz[m1];
          tmp1 = tmp1 + wlat[m1];	
          tmp2 = tmp2 + wz[m1];
        }
        if ( tmp1 == 0) { 
          newlat[k] = 0; newlon[k] = 0;
          for(j=0;j<npts_in_reit[i];j++){
            m1 = pts_in_reit[indrt[i]+j];
            newlat[k]=newlat[k]+lat[m1];
            newlon[k]=newlon[k]+lon[m1];
            tmp1 ++;
          }
        }
        if ( tmp2 == 0) { 
          newz[k] = 0;
          for(j=0;j<npts_in_reit[i];j++){
            m1 = pts_in_reit[indrt[i]+j];
            newz[k]=newz[k]+z[m1];
            tmp2 ++;
          }
        }
        newlat[k]=newlat[k]/(tmp1);
        newlon[k]=newlon[k]/(tmp1);
        newz[k]=newz[k]/(tmp2);
        newn[k]=npts_in_reit[i];
        fylla[k]=0;
        k++;
      }
      
      else {
        if(*fill == 1) {
          rnr = (i-1)/(*n-1);
          cnr = i- (rnr)*(*n-1);
          newlat[k] = grdlat[rnr];newlon[k]=grdlon[cnr-1];newz[k] = 0;
          fylla[k] = 1;k++;
        }
      }
    }
      }
      else if(*option == 2) { /* sum */
    for ( i=1; i <=*maxrt;i++) {
      if(npts_in_reit[i]>=*minnumber){ 
        tmp1 = 0;
        for(j=0;j<npts_in_reit[i];j++){
          m1 = pts_in_reit[indrt[i]+j];
          newlat[k]=newlat[k]+lat[m1]*wlat[m1];
          newlon[k]=newlon[k]+lon[m1]*wlat[m1];
          newz[k]=newz[k]+z[m1];
          tmp1 = tmp1 + wlat[m1];						
        } 
        if ( tmp1 == 0) { 
          newlat[k] = 0; newlon[k] = 0;
          for(j=0;j<npts_in_reit[i];j++){
            m1 = pts_in_reit[indrt[i]+j];
            newlat[k]=newlat[k]+lat[m1];
            newlon[k]=newlon[k]+lon[m1];
            tmp1 ++;
          }
        }
        newlat[k]=newlat[k]/(tmp1);
        newlon[k]=newlon[k]/(tmp1);
        newn[k]=npts_in_reit[i];
        fylla[k]=0;
        k++;
      }
      else {
        if(*fill == 1) {
          rnr = (i-1)/(*n-1);
          cnr = i- (rnr)*(*n-1);
          newlat[k] = grdlat[rnr];newlon[k]=grdlon[cnr-1];newz[k] = 0;
          fylla[k] = 1;k++;
        }
      }
    }
    
      }
      
      /*	find variance for each square  */
      
      else if(*option == 4) {
        for ( i=1; i <=*maxrt;i++) {
          if(npts_in_reit[i]>=*minnumber){ 
            tmp = 0;tmp1=0;
            for(j=0;j<npts_in_reit[i];j++){
              m1 = pts_in_reit[indrt[i]+j];
              newlat[k]=newlat[k]+lat[m1]*wlat[m1];
              newlon[k]=newlon[k]+lon[m1]*wlat[m1];
              newz[k]=newz[k]+z[m1]*z[m1]*wz[m1];
              tmp = tmp + z[m1]*wz[m1];
              tmp1 = tmp1+wlat[m1];
              tmp2 = tmp2+wz[m1];
            } 
            if ( tmp1 == 0) { 
              newlat[k] = 0; newlon[k] = 0;
              for(j=0;j<npts_in_reit[i];j++){
                m1 = pts_in_reit[indrt[i]+j];
                newlat[k]=newlat[k]+lat[m1];
                newlon[k]=newlon[k]+lon[m1];
                tmp1 ++;
              }
            }
            
            newlat[k]=newlat[k]/(tmp1);
            newlon[k]=newlon[k]/(tmp1);
            newz[k]=(newz[k]-tmp*tmp*tmp2)/(tmp2);
            newn[k]=npts_in_reit[i];
            fylla[k]=0;
            k++;
          }
          else {
            if(*fill == 1) {
              rnr = (i-1)/(*n-1);
              cnr = i- (rnr)*(*n-1);
              newlat[k] = grdlat[rnr];newlon[k]=grdlon[cnr-1];newz[k] = 0;
              fylla[k] = 1;k++;
            }
          }
        }
      }
      
      
      
      /*	Find median for each square */
      
      else if(*option ==3) {
        for ( i=1; i <=*maxrt;i++) {
          if(npts_in_reit[i]>=*minnumber){ 
            for(j=0;j<npts_in_reit[i];j++){
              nr[j]  =pts_in_reit[indrt[i]+j];
              wsp[j] = z[nr[j]];
            }
            j++; sort_c(wsp,&j,order);/*sort */
      j = npts_in_reit[i]/2+1;
      j = nr[order[j]-1];
      if(npts_in_reit[i] == 1) j=nr[0];
      newlat[k] = lat[j];
      newlon[k] = lon[j];
      newz[k] = z[j];
      newn[k]=npts_in_reit[i];
      fylla[k]=0;
      k++;
          }
          else {
            if(*fill == 1) {
              rnr = (i-1)/(*n-1);
              cnr = i- (rnr)*(*n-1);
              newlat[k] = grdlat[rnr];newlon[k]=grdlon[cnr-1];newz[k] = 0;
              fylla[k] = 1;k++;
            }
          }
        }
      }
      
      
      /*	Remove outliers  */
      
      else if(*option ==5) {
        for ( i=1; i <=*maxrt;i++) {
          if(npts_in_reit[i]>=*minnumber){ 
            if(npts_in_reit[i] <3){
              for(j=0;j<npts_in_reit[i];j++){
                nr[j] = pts_in_reit[indrt[i]+j];
                newlat[k]=lat[nr[j]];
                newlon[k]=lon[nr[j]];
                newz[k]=z[nr[j]];
                newn[k]=nr[j]; /* ATH */
      newn[k]=npts_in_reit[i];
      k++;
              }
            }
            else {
              nr_out = *rat*npts_in_reit[i];
              if(nr_out < 1 ) nr_out = 1;
              nr1_out = npts_in_reit[i] - nr_out; /* index for */
      if(nr1_out > nr_out) {
        for(j=0;j<npts_in_reit[i];j++){
          nr[j]  =pts_in_reit[indrt[i]+j];
          wsp[j] = z[nr[j]];
        }
        j++; sort_c(wsp,&j,order);/*sort */
      
      for(j=nr_out+1;j<=nr1_out;j++){
        j1 = nr[order[j]-1];
        newlat[k] = lat[j1];
        newlon[k] = lon[j1];
        newz[k] = z[j1];
        newn[k] = i;
        k++;
      }
      }
            }			      
          }
          else {
            if(*fill == 1) {
              rnr = (i-1)/(*n-1);
              cnr = i- (rnr)*(*n-1);
              newlat[k] = grdlat[rnr];newlon[k]=grdlon[cnr-1];newz[k] = 0;
              fylla[k] = 1;k++;
            }
          }
        }
      }
      
      
      
      *nnewlat = k;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*# 	include	<math.h>*/
    /* 	Function that calculates variogram.  */
    
    double distance(),distance_x();
    
    
    void c_variogram(lat,lon,z,d_dist,number,dist,vario,n,ndist,option,evennumber,varioa,dista,numbera,zzp,xy)
      double 	*lat,*lon,*z,*d_dist,*dist,*vario,*dista,*varioa;
    int  	*number,*n,*ndist,*evennumber,*numbera,*option,*zzp,*xy;
    
    {
      int 	i,j,ind,tel=0,fjoldi,k=0;
      double	d,diff,v1,v2,tiny;
      double  (*dst)();
      
      tiny=1e-5;
      if(*xy==1) dst=distance_x;else dst=distance;
      if(*zzp == 1) tiny = -99999999; /* zero-zero pairs included tok tvo null af*/
    v1 = 0.25; v2 = 4.0;
    for(i = 1; i <*n ; i++){
      for(j = 0; j < i ; j++){
        d = dst(lat[i],lon[i],lat[j],lon[j]);
        diff = z[i]-z[j]; diff = diff*diff;
        ind = d/(*d_dist); 
        if((ind < *ndist) && ((fabs(z[i])>tiny) ||(fabs(z[j])>tiny))){
          number[ind]++;
          dist[ind] = dist[ind] + d;
          if(*option==1) vario[ind] = vario[ind]+pow(diff,v1);
          else	vario[ind] = vario[ind] + diff;
        }
      }
    }
    if(*evennumber==1) { /*  Even number in each group */
    for(i = 0;i <*ndist;i++) tel = tel+number[i];
      fjoldi = tel*10 /(*ndist);
      for(i = 0;i <*ndist;i++) {
        varioa[k] = varioa[k]+vario[i] ;
        numbera[k] = numbera[k]+number[i]; 
        dista[k] = dista[k]+dist[i];
        if(numbera[k] > fjoldi )k++;
      }
      *ndist=k;
      for ( i = 0 ; i <*ndist;i++){
        if(numbera[i] != 0){
          if(*option==1)vario[i]=pow(varioa[i]/numbera[i],v2)/(0.457+0.494/numbera[i]); 
          else	vario[i] = varioa[i]/numbera[i];
          dist[i] = dista[i]/numbera[i];
          number[i] = numbera[i];
        }
        else { vario[i] = 0; dist[i] = 0;}
      }
    }
    else {
      for ( i = 0 ; i <*ndist;i++){
        if(number[i] != 0){
          if(*option==1)vario[i] =pow(vario[i]/number[i],v2)/(0.457+0.494/number[i]); 
          else	vario[i] = vario[i]/number[i];
          dist[i] = dist[i]/number[i];
        }
      }
    }
    }
    
    
    
    /* orthogonal projection of a point x,y on a line segment from x1,y1 to 
     x2,y2.  
     */
    
    void orthproj(x1,y1,x2,y2,x,y,d3,pardist,perdist)
      double x1,y1,x2,y2,x,y,*d3,*pardist,*perdist;
    {
        double d1,d2,d;
        d1 = (x - x1)*(x - x1) + (y - y1)*(y - y1);
        d2 = (x - x2)*(x - x2) + (y - y2)*(y - y2);
        d = (x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1);
        *d3 = (d + d1 - d2)/(2*d);
        if(*d3 >= -1 && *d3 <= 2) { /* calculate distance.*/  
    *pardist = *d3*sqrt(d);
    *perdist = sqrt(d1- *pardist*(*pardist));
        }
    }
    
    
    /* find the distance along a curve xc,yc from a point  marked by xp,yp. 
     dc stores the distance from the beginning of the curve to point i.   
     returns both distance from curve and distance along curve.  
     */
    
    void Curvedist(xc,yc,dc,nc,xp,yp,dp,mindist,np)
      double *xc,*yc,*dc,*xp,*yp,*dp,*mindist;
    int *nc,*np;
    {
      int i,j;
      double d,perdist=0.0,pardist=0.0;
      for( i = 0;i < *np;i++) {
        mindist[i] = 99999; 
        for(j = 0;j < *nc-1;j++){
          orthproj(xc[j],yc[j],xc[j+1],yc[j+1],xp[i],yp[i],&d,&pardist,&perdist); 
          if( d >= -1 && d <= 2) {
            if(perdist < mindist[i]) {
              mindist[i]  = perdist;
              dp[i] = dc[j] + pardist;
            }
          }
        }
      }
    }
    
    
    /* useC1.c                                    */
    /* Calling C with an integer vector using .C  */   
    void useC(int *i) {
      i[0] = 11;
    }
    
    