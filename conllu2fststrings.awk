BEGIN {IFS="\t";}
NF == 10 {
    gsub(/:/, "\\:");
    if ($6 != "_") {
        printf("%s:%s|%s|%s\n", $2, $3, $4, $6);
    } else {
        printf("%s:%s|%s\n", $2, $3, $4);
    }
}
