#!/usr/bin/env python3
from plistlib import dump, load, FMT_XML

path = "build/tmp/love.app/Contents/Info.plist"

print("Reading Info.plist...")

with open(path, 'rb') as fp:
    plist = load(fp, fmt=FMT_XML)

print("Patching data...")
# see https://love2d.org/wiki/Game_Distribution#Creating_a_macOS_Application
plist['CFBundleIdentifier'] = 'eu.cafehaine.coffeecross'
plist['CFBundleName'] = 'CoffeeCross'
plist.pop('UTExportedTypeDeclarations', None)

print("Writing patched data...")

with open(path, 'wb') as fp:
	dump(plist, fp, fmt=FMT_XML)

print("Done.")
