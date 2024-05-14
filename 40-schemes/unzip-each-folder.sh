#!/bin/bash

base_dir=$(pwd)

cd "$base_dir"

for dir in */; do

	if [ -d "$dir" ]; then
		cd "$dir"

		# handle the case that no .zip file found
		zip_file=$(find . -maxdepth 1 -type f -name '*.zip' | head -n 1)
		if [ -n "$zip_file" ]; then
			echo "Unzipping $zip_file in $dir"
			unzip "$zip_file"
		else
			echo "No zip file found in $dir"
		fi
		
		cd "$base_dir"
	fi
done

