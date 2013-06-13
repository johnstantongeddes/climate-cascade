Script to make a map and add points
=========================================

Load libraries


```r
# sessionInfo()

library(raster)
```

```
## Loading required package: sp
```

```r
library(rgdal)  # NOTE: have to have [gdal](http://www.gdal.org/) and [PROJ.4](http://trac.osgeo.org/proj/) install on PATH
```

```
## rgdal: version: 0.8-9, (SVN revision 470) Geospatial Data Abstraction
## Library extensions to R successfully loaded Loaded GDAL runtime: GDAL
## 1.9.0, released 2011/12/29 Path to GDAL shared files: /usr/share/gdal/1.9
## Loaded PROJ.4 runtime: Rel. 4.7.1, 23 September 2009, [PJ_VERSION: 470]
## Path to PROJ.4 shared files: (autodetected)
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

```r
library(maps)
library(ggplot2)
```



Get climate data. Use highest scale resolution (10deg) for faster download at large scale. Other options are 5, 2.5 and 0.5 (which requires downloading individual tiles)


```r
w <- getData("worldclim", var = "bio", res = 10)
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
## 3 Great Smoky Mountains NP    TN -83.00 35.00    150 15.0
## 4                 Piedmont    GA -83.00 31.00    192 19.2
## 5        Francis Marion NF    SC -83.00 32.00    185 18.5
## 6      Sesquicentennial SP    SC -80.00 34.00    171 17.1
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



Create same plot using ggplot2, with help from [stackoveflow](http://stackoverflow.com/questions/9422167/how-do-i-plot-a-single-point-on-a-world-map-using-ggplot2)

TODO: need to add MAT to plot....


```r
eUSA <- map_data("state", region = c("florida", "south carolina", "north carolina", 
    "georgia", "virginia", "west virginia", "maryland", "delaware", "new jersey", 
    "rhode island", "new york", "connecticut", "massachusetts", "pennyslvania", 
    "vermont", "new hampshire", "maine", "alabama", "tennessee", "kentucky", 
    "ohio"))

p <- ggplot(legend = FALSE) + geom_path(data = eUSA, aes(x = long, y = lat, 
    group = group)) + theme(panel.background = element_blank()) + theme(panel.grid.major = element_blank()) + 
    theme(panel.grid.minor = element_blank()) + theme(axis.text.x = element_blank(), 
    axis.text.y = element_blank()) + theme(axis.ticks = element_blank()) + xlab("") + 
    ylab("")

# Sites to add to plot:
sites <- d[, c("lon", "lat")]
p <- p + geom_point(data = sites, aes(lon, lat), colour = "green", size = 4)
p
```

![plot of chunk ggplot](figure/ggplot.png) 


Hmmm...looks like points are out of place...probably due to Google Earth giving DD'MM'SS and R plots expecting DD.DDDD


