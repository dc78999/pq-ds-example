#!/bin/bash

base_dir=$(pwd)

build_cmake(){
	echo "Building using Cmake in $1"
	cd "$1"
	mkdir -p build
	cd build
	cmake .. && make
	if [ $? -ne 0 ]; then
		echo "Cmake build failed in $1"
	fi
	cd "$base_dir"
}

build_make(){
	echo "Building using Makefile in $1"
	cd "$1"
	make
	if [ $? -ne 0]; then
		echo "Make build fail in $1"
	fi
	cd "$base_dir"
}

search_and_build(){
	local dir=$1

	if [ -f "$dir/CmakeLists.txt" ]; then
		build_cmake "$dir"
	elif [ -f "$dir/Makefile" ]; then
		build_make "$dir"
	fi
}

recursive_iterate(){
	local current_dir=$1
	for subdir in "$current_dir"/*; do
		if [ -d "$subdir" ]; then
			search_and_build "$subdir"
			recursive_iterate "$subdir"
		fi
	done
}

recursive_iterate "$base_dir"

echo "All project processed."
