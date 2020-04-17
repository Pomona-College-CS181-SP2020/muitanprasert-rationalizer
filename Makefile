.PHONY : all deploy clean

all : app/elm.js

app/elm.js : src/HomePage.elm src/*.elm
	elm make $< --output=$@

deploy : app/elm.js
	git subtree push --prefix app origin gh-pages

clean : rm app/elm.js