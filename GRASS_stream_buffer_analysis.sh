#! /bin/bash

# Based on a range of possible precipitation-rate inputs, builds vectorized
# stream networks (>= 0.1 m3/s), creates a 200-meter buffer around them, clips
# these to the extent of a study watershed, and prints the area of this
# buffered region for comparison to the area of the study watershed.

# The purpose of this is to assess the region of reasonable habitability near
# the Maya site of Uxbenka through periods of climate change.

# Written as part of a collaboration with Amy Thompson and Keith Prufer.


# Import base data sets
r.in.gdal input=SRTM.tif output=SRTM-test
v.in.ogr input=basin.gpkg output=basin.test

# Analyze for a range of threshold drainage areas, corresponding to different
# precipitation rates from an analysis of modern precip data (annual,
# wet-season, and dry-season)
declare -a DrainageAreaArray=(923
699
2577
785
588
1856
683
507
1451
1120
861
5137
1424
1121
11513)

for A in ${DrainageAreaArray[@]}
do
    echo $A
    r.stream.extract elevation=SRTM stream_vector=streams_$A threshold=$A memory=4000
done

for A in ${DrainageAreaArray[@]}
do
    echo $A
    v.buffer input=streams_$A output=streams_${A}_buffered distance=200 --o
    v.overlay ainput=streams_${A}_buffered atype=area binput=basin output=streams_${A}_buffered_inbasin operator=and --o
done

# Get area of whole basin
# New GRASS -- no need to make column first
v.to.db map=basin option=area units=kilometers columns=area_km2

# Area of 200 m buffer around all streams, in basin
for A in ${DrainageAreaArray[@]}
do
    echo $A
    v.to.db map=streams_${A}_buffered_inbasin option=area units=kilometers columns=area_km2
done

# Univariate statistics -- get sum of area
for A in ${DrainageAreaArray[@]}
do
    echo $A
    v.univar map=streams_${A}_buffered_inbasin column=area_km2
    echo
    echo
done

echo basin
v.univar map=basin column=area_km2
echo
echo

