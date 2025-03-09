#!/bin/bash

# Use it from the images directory:
# ./make_tumb.sh my_photo.jpg

src="$1"
dst="thumbs/${src/%.jpg/.png}"

echo "$src -> $dst"

magick "$src" \
       -background none \
       -resize 360x203 \
       -gravity center  \
       -extent 360x203 \
       "$dst"
