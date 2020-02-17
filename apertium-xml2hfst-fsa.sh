grep --color '<e><p><l>[a-z]*<s n="vblex"/></l><r>[a-z]*<s n="vblex"/></r></p></e>' ../../apertium/apertium-fin-deu/apertium-fin-deu.fin-deu.dix | sed -f apertium-xml2hfst-fsa.sed 
