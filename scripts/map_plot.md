Script to make a map and add points
=========================================

Load libraries


```r
library(raster)
```

```
## Loading required package: sp
```

```r
library(dismo)
library(maptools)
```

```
## Loading required package: foreign
```

```
## Loading required package: grid
```

```
## Loading required package: lattice
```

```
## Checking rgeos availability: FALSE Note: when rgeos is not available,
## polygon geometry computations in maptools depend on gpclib, which has a
## restricted licence. It is disabled by default; to enable gpclib, type
## gpclibPermit()
```



Get climate data. Use highest scale resolution (10deg) for faster download at large scale. Other options are 5, 2.5 and 0.5 (which requires downloading individual tiles)


```r
w <- getData("worldclim", var = "bio", res = 10)
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```
## Warning: there is no package called 'rgdal'
```

```r
names(w)
```

```
##  [1] "bio1"  "bio2"  "bio3"  "bio4"  "bio5"  "bio6"  "bio7"  "bio8" 
##  [9] "bio9"  "bio10" "bio11" "bio12" "bio13" "bio14" "bio15" "bio16"
## [17] "bio17" "bio18" "bio19"
```

```r
# Plot first bioclim dimension (MAT) to check download worked
plot(w, 1)
```

![plot of chunk loadclimdata](figure/loadclimdata.png) 



Load file with location data. Longitude column ('lon') should precede latitude ('lat')


```r
d <- read.csv("Aphaeno2013_sampling_locations.csv")
head(d)
```

```
##                  site_name state    lon   lat
## 1  Reed Bingham State Park    GA -83.11 31.12
## 2              Cabin Creek    WV -81.03 38.11
## 3 Great Smoky Mountains NP    TN -83.00 35.00
## 4                 Piedmont    GA -83.00 31.00
## 5        Francis Marion NF    SC -83.00 32.00
## 6      Sesquicentennial SP    SC -80.00 34.00
```

```r
str(d)
```

```
## 'data.frame':	30 obs. of  4 variables:
##  $ site_name: Factor w/ 30 levels "Aroostook SP",..: 24 3 7 21 6 27 4 9 23 18 ...
##  $ state    : Factor w/ 13 levels "GA","MA","ME",..: 1 13 10 1 8 8 8 9 4 4 ...
##  $ lon      : num  -83.1 -81 -83 -83 -83 ...
##  $ lat      : num  31.1 38.1 35 31 32 ...
```


Extract bioclimatic variables from worldclim data. Note bioclim temperature data is multiplied by 10 (no decimal), so transform by dividing by 10.


```r
# Extract climate values for site lon/lat from bioclim data
dbio1 <- extract(w, d[, c("lon", "lat")])

dbio1 <- cbind(d, dbio1[, 1])
colnames(dbio1)[5] <- "MATx10"
dbio1$MAT <- dbio1$MATx10/10
head(dbio1)
```

```
##                  site_name state    lon   lat MATx10  MAT
## 1  Reed Bingham State Park    GA -83.11 31.12    192 19.2
## 2              Cabin Creek    WV -81.03 38.11    109 10.9
## 3 Great Smoky Mountains NP    TN -83.00 35.00    112 11.2
## 4                 Piedmont    GA -83.00 31.00    192 19.2
## 5        Francis Marion NF    SC -83.00 32.00    183 18.3
## 6      Sesquicentennial SP    SC -80.00 34.00    169 16.9
```

```r

# Write to file
write.table(dbio1, file = "Aphaen2013_sites_MAT.txt", quote = FALSE, sep = "\t", 
    row.names = FALSE)
```



Plot NorthEastern US and add points for sampling sites. Note MAT is still multiplied by 10.


```r
plot(w, 1, xlim = c(-90, -60), ylim = c(25, 50), axes = TRUE)
points(dbio1$lon, dbio1$lat, col = "black", pch = 20, cex = 0.75)
```

![plot of chunk plot](figure/plot.png) 


