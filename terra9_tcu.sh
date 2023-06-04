#!/bin/bash
# Quick and dirty shell script to concatenate some textures from Doom2 into Terra9.wad
# You will need to place both iwads in the input directory.
mkdir temp
mkdir output
deutex -overwrite -dir ./temp -doom2 ./input -flats -patches -extract ./input/doom2.wad
deutex -overwrite -dir ./temp -doom ./input -textures -extract ./input/doom.wad
mkdir ./temp/graphics
cp ./input/data/textures/terra9.txt ./temp/textures
cp ./input/data/graphics/* ./temp/graphics
cp ./input/data/patches/* ./temp/patches
deutex -overwrite -dir ./temp -doom ./input -build ./input/data/terra9info.txt temp/temptex.wad
deutex -doom ./input -join ./input/data/terra9.wad temp/temptex.wad
rm -r ./temp
cp ./input/data/terra9.wad output
cp ./input/data/terra9.deh output
