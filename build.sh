#!bin/bash

DEFS_SEQ="-std=gnu99 -DARCH64 -ffast-math -DNOPARALLEL -DEXTRA"
DEFS_PAR="-std=gnu99 -DARCH64 -ffast-math -DEXTRA"
DEFS_MEM="-std=gnu99 -DARCH64 -ffast-math -DNOPARALLEL -DEXTRA -DMALLOC_COUNT"

gcc -O2 -c bit_array.c

echo "Compiling sequential algorithm ..."
gcc -O2 -o sg_seq $DEFS_SEQ main.c util.c defs.c bit_array.o \
parallel_succinct_graph.c succinct_tree.c lookup_tables.c -lrt -lm

echo "Compiling parallel algorithm ..."
gcc -O2 -o sg_par $DEFS_PAR main.c util.c defs.c bit_array.o \
parallel_succinct_graph.c succinct_tree.c lookup_tables.c -fcilkplus -lcilkrts \
-lrt -lm 

echo "Compiling sequential algorithm (Working space) ..."
gcc -c malloc_count.c
gcc -O2 -std=gnu99 -o sg_mem $DEFS_MEM main.c util.c defs.c bit_array.o \
malloc_count.o parallel_succinct_graph.c succinct_tree.c lookup_tables.c -lrt \
-lm -ldl
