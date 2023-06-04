#!/bin/bash
mkdir output
deutex -overwrite -dir ./output -doom2 ./input -flats -patches -extract ./input/doom2.wad
deutex -overwrite -dir ./output -doom ./input -textures -extract ./input/doom.wad
mkdir ./output/textures
mkdir ./output/graphics
cp ./input/data/textures/terra9.txt ./output/textures
cp ./input/data/graphics/* ./output/graphics
cp ./input/data/patches/* ./output/patches
deutex -overwrite -dir ./output -doom ./input -build ./input/data/terra9.txt temptex.wad
rm -r ./output
deutex -doom ./input -join terra9.wad temptex.wad
rm temptex.wad
