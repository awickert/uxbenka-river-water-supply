#! /bin/bash

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


# Import the Plazuela locations
v.in.ogr input=plazuelas.gpkg output=plazuelas --o

for A in ${DrainageAreaArray[@]}
do
    echo $A
    v.db.addcolumn map=plazuelas columns="$A double precision"
    v.distance from=plazuelas to=streams_$A upload=dist column=$A
done

v.db.select map=plazuelas sep='\t' file=plazuelas.tsv

# And then I did the rest of the means, edits, etc. by hand

