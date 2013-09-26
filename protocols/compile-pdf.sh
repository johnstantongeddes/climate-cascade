# bash script to generate pdf files from markdown for protocols
# requires [pandoc]() to be installed

# specify xelatex to allow unicode symbols such as plus-minus and degree symbol when generating pdf
# change default margins (potentially other features) by specifying style file when compiling in pandoc

for i in *.md
do
    echo $i
    pandoc $i -o ${i}.pdf --latex-engine=xelatex -H margins.sty
done

