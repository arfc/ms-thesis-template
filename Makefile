manuscript = main
references = $(wildcard *.bib)
latexopt   = -halt-on-error -file-line-error

all: all-via-pdf

all-via-pdf: $(manuscript).tex $(references)
	pdflatex $(latexopt) --shell-escape $<
	makeglossaries $(manuscript)
	biber $(manuscript)
	pdflatex $(latexopt) $<
	pdflatex $(latexopt) $<

all-via-dvi: 
	latex $(latexopt) $(manuscript)
	biber $(manuscript)
	latex $(latexopt) $(manuscript)
	latex $(latexopt) $(manuscript)
	dvipdf $(manuscript)

epub: 
	latex $(latexopt) $(manuscript)
	biber $(manuscript)
	mk4ht htlatex $(manuscript).tex 'xhtml,charset=utf-8,pmathml' ' -cunihtf -utf8 -cvalidate'
	ebook-convert $(manuscript).html $(manuscript).epub

clean:
	rm -f *.pdf *.dvi *.toc *.aux *.out *.log *.bbl *.blg *.log *.spl *~ *.spl *.zip *.acn *.glo *.ist *.epub *.gls *.glg *.xdy *.lof *.lot *.bcf *.run.xml

realclean: clean
	rm -rf $(manuscript).dvi
	rm -f $(manuscript).pdf

%.ps :%.eps
	convert $< $@

%.png :%.eps
	convert $< $@

zip:
	zip paper.zip *.tex *.eps *.bib

.PHONY: all clean
