% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataset_doc.R
\docType{data}
\name{reg.bc}
\alias{reg.bc}
\title{Bormicon regions}
\format{
The format is: List of 16 $ Vestur :'data.frame': 1221 obs. of 2
variables: ..$ lat: num [1:1221] 65.5 65.5 65.5 65.5 65.5 ...  ..$ lon: num
[1:1221] -24.4 -24.4 -24.3 -24.2 -24.1 ...  $ Vestfirdir :'data.frame': 664
obs. of 2 variables: ..$ lat: num [1:664] 65.5 65.5 65.4 65.4 65.4 ...  ..$
lon: num [1:664] -21 -21 -21 -20.9 -21 ...  $ Mid.Nordur :'data.frame': 560
obs. of 2 variables: ..$ lat: num [1:560] 67.2 67.2 67.2 67.2 67.2 ...  ..$
lon: num [1:560] -24 -24 -24 -24 -24 ...  $ Grunnslod.nordur:'data.frame':
146 obs. of 2 variables: ..$ lat: num [1:146] 66.2 66.2 66.2 66.2 66.2 ...
..$ lon: num [1:146] -17 -17 -17.1 -17.1 -17.2 ...  $ Nordaustur
:'data.frame': 561 obs. of 2 variables: ..$ lat: num [1:561] 66.3 66.3 66.3
66.3 66.3 ...  ..$ lon: num [1:561] -15 -15.1 -15.1 -15.2 -15.3 ...  $
Austur :'data.frame': 707 obs. of 2 variables: ..$ lat: num [1:707] 64.5
64.5 64.6 64.6 64.5 ...  ..$ lon: num [1:707] -14.5 -14.5 -14.4 -14.4 -14.5
...  $ Rosagardur :'data.frame': 329 obs. of 2 variables: ..$ lat: num
[1:329] 64.5 64.5 64.5 64.5 64.5 ...  ..$ lon: num [1:329] -10.4 -10.4 -10.4
-10.4 -10.4 ...  $ Sudaustur :'data.frame': 19 obs. of 2 variables: ..$ lat:
num [1:19] 64.2 64.2 64.2 64.3 64.3 ...  ..$ lon: num [1:19] -15 -15 -15
-14.9 -14.9 ...  $ Sudur.Sudaustur :'data.frame': 788 obs. of 2 variables:
..$ lat: num [1:788] 63.4 63.4 63.4 63.4 63.4 ...  ..$ lon: num [1:788] -19
-19 -18.9 -18.9 -18.8 ...  $ Sudur.Sudvestur :'data.frame': 546 obs. of 2
variables: ..$ lat: num [1:546] 64 64 64 64 64 ...  ..$ lon: num [1:546]
-22.7 -22.7 -22.7 -22.7 -22.7 ...  $ Kantur.NW :'data.frame': 557 obs. of 2
variables: ..$ lat: num [1:557] 67.2 67.2 67.2 67.2 67.2 ...  ..$ lon: num
[1:557] -24 -24 -24 -24 -24 ...  $ Kantur.NE :'data.frame': 642 obs. of 2
variables: ..$ lat: num [1:642] 63.5 63.5 63.5 63.5 63.5 ...  ..$ lon: num
[1:642] -10.2 -10.2 -10.2 -10.2 -10.2 ...  $ Sudur.Dypi :'data.frame': 1283
obs. of 2 variables: ..$ lat: num [1:1283] 64 64 64 64 64 ...  ..$ lon: num
[1:1283] -13.2 -13.2 -13.2 -13.2 -13.2 ...  $ Reykjaneshr :'data.frame': 188
obs. of 2 variables: ..$ lat: num [1:188] 63 63 63 63 63 ...  ..$ lon: num
[1:188] -24 -24 -24 -24 -24.1 ...  $ Vestur.Dypi :'data.frame': 1010 obs. of
2 variables: ..$ lat: num [1:1010] 63 63 63 63 63 ...  ..$ lon: num [1:1010]
-25 -25 -25 -25 -25 ...  $ Nordur.Dypi :'data.frame': 7 obs. of 2 variables:
..$ lat: num [1:7] 68.5 70 72.5 72.5 70 68.5 68.5 ..$ lon: num [1:7] -8 -4
-4 -21 -21 -27 -8 - attr(*, "area")= num [1:16] 50437 31953 22803 10501
16024 ...  - attr(*, "txtloc")=List of 2 ..$ lat: num [1:16] 64.6 66.6 67
66.3 67 ...  ..$ lon: num [1:16] -25.6 -24.2 -19.2 -19.4 -15.6 ...
}
\description{
A list of the Bormicon regions
}
\details{
Used in \code{\link{inside.reg.bc}} to assign region numbers to data.
}
\examples{

data(reg.bc)
## maybe str(reg.bc) ; plot(reg.bc) ...

}
