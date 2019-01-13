cmake_minimum_required(VERSION 3.10)

project( useStaticLib )

include_directories( ../static_lib )

link_directories( ../static_lib/build )
add_executable( useStaticLib useStaticLib.cpp )

target_link_libraries( useStaticLib add )