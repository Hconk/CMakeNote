cmake_minimum_required(VERSION 3.10)

project( add )

aux_source_directory(. SRC )

add_library(add ${SRC} )