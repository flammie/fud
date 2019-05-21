BEGIN {IFS="\t";}
NF == 10 {
    gsub(/:/, "\\:");
    printf("%s:%s|%s|%s\n", $2, $3, $4, $6);
}
