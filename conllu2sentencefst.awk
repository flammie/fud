BEGIN {IFS="\t"; surf=""; anal=""}
NF == 10 {
    gsub(/:/, "\\:");
    surf = surf $2;
    if ($6 != "_") {
        anal = anal  $3  "|"  $4  "|" $6;
    } else {
        anal = anal  $3  "|"  $4;
    }
    if ($10 !~ /SpaceAfter=No/) {
        surf = surf  " ";
        anal = anal  " "; # FIXME: special?
    }
}
/^$/ {printf("%s:%s\n", surf, anal); surf=""; anal="";}
END {printf("%s:%s\n", surf, anal);}
