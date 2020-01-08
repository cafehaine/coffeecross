#!/usr/bin/env python3

lines = []

path = "build/tmp/love.app/Contents/Info.plist"

print("Reading Info.plist...")

with open(path) as data:
	for line in data:
		lines.append(line.rstrip())

print("Patching data...")
#TODO see https://love2d.org/wiki/Game_Distribution#Creating_a_macOS_Application

print("Writing patched data...")

with open(path, 'w') as out:
	out.write("\n".join(lines))

print("Done.")
