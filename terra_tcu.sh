#!/bin/bash
# Quick and dirty shell script to concatenate some textures from Doom2 into Terra9.wad
# You will need to place both iwads in the input directory.
mkdir temp
mkdir output
deutex -overwrite -dir ./temp -doom2 ./input -flats -patches -extract ./input/doom2.wad
deutex -overwrite -dir ./temp -doom ./input -textures -extract ./input/doom.wad
mkdir ./temp/graphics
cp ./input/data/textures/terra1.txt ./temp/textures
cp ./input/data/graphics/* ./temp/graphics
cp ./input/data/patches/* ./temp/patches
deutex -overwrite -dir ./temp -doom ./input -build ./input/data/terrainfo.txt temp/temp.wad
deutex -doom ./input -join ./input/data/terra.wad temp/temp.wad
rm -r ./temp
cp ./input/data/terra.wad output
cp ./input/data/terra.deh output
