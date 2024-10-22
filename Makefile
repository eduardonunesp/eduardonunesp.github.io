all: build cname

build:
	zola build
	make cname

cname:
	echo "edoncode.dev" >> docs/CNAME
