cmake_minimum_required(VERSION 3.10)

project( useDynamicLib )

include_directories( ../dynamic_lib )

link_directories( ../dynamic_lib/build )
add_executable( useDynamicLib useDynamicLib.cpp )

target_link_libraries( useDynamicLib add )
