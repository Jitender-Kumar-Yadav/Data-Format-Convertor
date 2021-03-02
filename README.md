# Data-Format-Convertor
A small SML project to interconvert files between various formats such as csv, tsv, asv, etc.

1. Run csv2dsv.sml
2. to convert a csv file with name with path "p" to a tsv file with path "q", run
csv2tsv("p", "q");
3. To convert a tsv file "p" to a csv file "q", run
tsv2csv("p", "q");
4. To convert file "p" with delimiter character c1 to anither file "q" with delimiter c2, run
convertDelimiters("p", c1, "q", c2);

Note the following:
An asv file has delimiter "&"
A csv file has delimiter ","
A ssv file has delimiter ";"
A tsv file has delimiter "\t"
