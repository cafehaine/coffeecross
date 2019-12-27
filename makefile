ALL_FILES := $(shell find coffeecross)

all: build/game.love

build/:
	mkdir -p build

build/game.love: build/ $(ALL_FILES)
	cd coffeecross && zip -qr ../build/game.love *

clean:
	rm -rf build/*
