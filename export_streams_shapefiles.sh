#! /bin/bash

# Export all streams from the final simulations to a set of gpkg files

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

# Streams in basin
for A in ${DrainageAreaArray[@]}
do
    echo $A
    # tmp because of attributes linked to points, not lines
    v.extract input=streams_${A} output=tmp type=line --o
    v.db.droptable map=tmp -f
    v.overlay ainput=tmp atype=line binput=basin output=streams_${A}_inbasin operator=and --o
    v.out.ogr input=streams_${A}_inbasin output=streams_${A}_inbasin format=ESRI_Shapefile --o
done

# Buffers
for A in ${DrainageAreaArray[@]}
do
    echo $A
    v.out.ogr input=streams_${A}_buffered_inbasin output=streams_${A}_buffered_inbasin format=ESRI_Shapefile --o
done


