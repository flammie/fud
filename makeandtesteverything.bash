#!/bin/bash

while read l ; do
    bash make-fud.bash $l
    bash test-fud.bash $l
done < treebanks.tsv | tee alltests.log
