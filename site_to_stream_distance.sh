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
    v.db.addcolumn map=plazuelas columns="distance_to_rivers_$A double precision"
    v.distance from=plazuelas to=streams_$A upload=dist column=distance_to_rivers_$A
done

v.db.select map=plazuelas sep='\t' file=plazuelas.tsv

# And then I did the rest of the means, edits, etc. by hand


# Let's flesh out the rest of this with the other numbers
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
11513
500 1000 2000 4000 8000 16000 32000 64000 128000)

for A in ${DrainageAreaArray[@]}
do
    echo $A
    v.db.addcolumn map=plazuelas columns="distance_to_rivers_$A double precision"
    v.distance from=plazuelas to=streams_$A upload=dist column=distance_to_rivers_$A
done

v.db.select map=plazuelas sep='\t' file=plazuelas.tsv --o

