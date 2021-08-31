#! /bin/bash

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

