#!/bin/bash

zip_dir=$(pwd)

cd "$zip_dir"

for zip_file in *.zip; do
	if [ -f "$zip_file" ]; then
		# exclude the .zip extension
		dir_name="${zip_file%.zip}"

		mkdir -p "${dir_name}"

		mv "$zip_file" "$dir_name"

		cd "$dir_name"

		unzip "$zip_file"

		cd ..

		echo "$zip_file extracted to $dir_name"

	fi
done


echo "All zip files extracted."
