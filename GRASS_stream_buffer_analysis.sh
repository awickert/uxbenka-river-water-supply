#! /bin/bash

# Based on a range of possible precipitation-rate inputs, builds vectorized
# stream networks (>= 0.1 m3/s), creates a 200-meter buffer around them, clips
# these to the extent of a study watershed, and prints the area of this
# buffered region for comparison to the area of the study watershed.

# The purpose of this is to assess the region of reasonable habitability near
# the Maya site of Uxbenka through periods of climate change.

# Written as part of a collaboration with Amy Thompson and Keith Prufer.


# File to export threshold drainage area , area covered by buffer
outfile=Adrain_Abuffer.csv

# Import base data sets
r.in.gdal input=SRTM.tif output=SRTM
v.in.ogr input=basin.gpkg output=basin

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

# For a more general survey through the possible drainage areas, in order
# to produce a plot of these at consistent intervals
# Comment out to use the hydrologically determined values above.
#DrainageArray=($(seq 5000 10000 70000))
# This set is chosen specifically for the study basin here
declare -a DrainageAreaArray=(500 1000 2000 4000 8000 16000 32000 64000 128000)

# And this now applies the runoff ratio, rounded to 18.5%
declare -a DrainageAreaArray=(4988
3776
13928
4242
3178
10034
3690
2743
7842
6053
4653
27766
7696
6060
62235)


for A in ${DrainageAreaArray[@]}
do
    echo $A
    r.stream.extract elevation=SRTM stream_vector=streams_$A threshold=$A memory=4000
done

for A in ${DrainageAreaArray[@]}
do
    echo $A
    v.buffer input=streams_$A output=streams_${A}_outer_buffer distance=331 --o
    v.buffer input=streams_$A output=streams_${A}_inner_buffer distance=10 --o
    v.overlay binput=streams_${A}_inner_buffer ainput=streams_${A}_outer_buffer output=streams_${A}_buffered operator=not --o
    v.overlay ainput=streams_${A}_buffered atype=area binput=basin output=streams_${A}_buffered_inbasin operator=and --o
done

# Get area of whole basin
# New GRASS -- no need to make column first
v.to.db map=basin option=area units=kilometers columns=area_km2

# Area of buffer around all streams, in basin
for A in ${DrainageAreaArray[@]}
do
    echo $A
    v.to.db map=streams_${A}_buffered_inbasin option=area units=kilometers columns=area_km2
done

# Univariate statistics -- get sum of area
# This will just append to the existing $outfile to prevent accidental
# data loss
echo "-------------------------" >> $outfile
echo "Athresh,Awithin" >> $outfile
echo -e "AThresh\tAwithin"
for A in ${DrainageAreaArray[@]}
do
    echo -n $A >> $outfile
    echo -n "," >> $outfile
    Awithin=$(v.univar map=streams_${A}_buffered_inbasin column=area_km2 | grep -oP '(?<=sum: )[^ ]*')
    echo $Awithin >> $outfile
    echo -e "$A\t$Awithin"
done

echo -n "basin," >> $outfile
Abasin=$(v.univar map=basin column=area_km2 | grep -oP '(?<=sum: )[^ ]*')
echo $Abasin >> $outfile
echo -e "basin\t$Abasin"

