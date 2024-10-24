all: build cname publish

build:
	zola build
	make cname
	git add .

serve:
	zola serve

cname:
	echo "edoncode.dev" >> docs/CNAME

publish:
	git commit -am "new article"
	git push
