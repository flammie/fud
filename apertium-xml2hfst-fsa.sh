grep --color '<e><p><l>[a-z]*<s n="vblex"/></l><r>[a-z]*<s n="vblex"/></r></p></e>' ../../apertium/apertium-fin-deu/apertium-fin-deu.fin-deu.dix | sed -f apertium-xml2hfst-fsa.sed 

# $ echo voittaa | hfst-lookup models/fi_ftb-ud-train.tropical-a1.hfst           
# hfst-lookup: warning: It is not possible to perform fast lookups with OpenFST, std arc, tropical semiring
# format automata.
# Using HFST basic transducer format and performing slow lookups                                           
# > voittaa       voittaa|VERB|Mood=Ind|Number=Sing|Person=3|Tense=Pres|VerbForm=Fin|Voice=Act    10.110037
# voittaa voittaa|VERB|Case=Lat|InfForm=1|VerbForm=Inf|Voice=Act  10.264188
