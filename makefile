ALL_FILES := $(shell find coffeecross)
LOVE_VERSION := 11.3
LOVE_FILES := love.dll lua51.dll mpg123.dll msvcp120.dll msvcr120.dll OpenAL32.dll SDL2.dll license.txt

all: build/game.love

%:
	mkdir -p "$@"

build/tmp/love-win32.zip: build/tmp/
	curl -L "https://bitbucket.org/rude/love/downloads/love-$(LOVE_VERSION)-win32.zip" -o "$@"

build/tmp/love-macos.zip: build/tmp/
	curl -L "https://bitbucket.org/rude/love/downloads/love-$(LOVE_VERSION)-macos.zip" -o "$@"

build/tmp/love.app: build/tmp/love-macos.zip
	unzip -qo build/tmp/love-macos.zip -d build/tmp

build/game.app.zip: build/tmp/love.app
	cd build/tmp/ && zip -qr ../../"$@" love.app

build/tmp/game.exe: build/tmp/love-win32.zip build/game.love
	unzip -qoj build/tmp/love-win32.zip "*/love.exe" -d build/tmp/
	cat build/tmp/love.exe build/game.love > "$@"

build/game-win32.zip: build/tmp/love-win32.zip build/tmp/game.exe
	unzip -qoj build/tmp/love-win32.zip $(addprefix */,$(LOVE_FILES)) -d build/tmp
	zip -qj "$@" $(addprefix build/tmp/,$(LOVE_FILES)) build/tmp/game.exe

build/game.love: build/ $(ALL_FILES)
	cd coffeecross && zip -qr ../"$@" *

clean:
	rm -rf build/*

package: build/game-win32.zip
