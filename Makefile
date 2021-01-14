default: all

all: jar script man docker

script: class
	mkdir -p build/bin
	echo '#!/bin/bash\n\njava -cp build com.heinthanth.uit.Main "$$@"' > build/bin/uit.sh
	chmod +x build/bin/uit.sh

jar: class
	jar cmvf META-INF/MANIFEST.MF build/uit.jar -C build .

class: clean node
	JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8 javac -g:none -Werror -d build -cp src src/com/heinthanth/uit/Main.java

man:
	mkdir -p build/man/
	pandoc man/uit.1.md -s -t man -o build/man/uit.1
	gzip build/man/uit.1

docker:
	sudo docker build -t uit .

node:
	javac -d build src/com/heinthanth/uit/Utils/GenerateNode.java
	java -cp build com.heinthanth.uit.Utils.GenerateNode src/com/heinthanth/uit/Runtime

clean:
	rm -rf build

.PHONY: all script jar class man clean