#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/*
  The following name(s) appear with different usages
  e.g., with different numbers of arguments:

    marghc

  This needs to be resolved in the tables and any declarations.
*/

/* FIXME: 
   Check these declarations against the C/Fortran source code.
*/

/* .C calls */
extern void combinert(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);
extern void Curvedist(void *, void *, void *, void *, void *, void *, void *, void *, void *);
extern void define_multiline(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);
extern void define_poly(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);
extern void elcont(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);
extern void geomarghc(void *, void *, void *, void *, void *, void *, void *, void *, void *);
extern void marghc(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);
extern void c_pointkriging(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);
extern void post_filter(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);
extern void c_variogram(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);

static const R_CMethodDef CEntries[] = {
    {"combinert",        (DL_FUNC) &combinert,        28},
    {"Curvedist",        (DL_FUNC) &Curvedist,         9},
    {"define_multiline", (DL_FUNC) &define_multiline, 15},
    {"define_poly",      (DL_FUNC) &define_poly,      16},
    {"elcont",           (DL_FUNC) &elcont,           18},
    {"geomarghc",        (DL_FUNC) &geomarghc,         9},
    {"marghc",           (DL_FUNC) &marghc,           11},
    {"c_pointkriging",     (DL_FUNC) &c_pointkriging,     45},
    {"post_filter",      (DL_FUNC) &post_filter,      14},
    {"c_variogram",        (DL_FUNC) &c_variogram,        16},
    {NULL, NULL, 0}
};

void R_init_geo(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
