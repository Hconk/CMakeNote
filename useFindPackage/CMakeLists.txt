cmake_minimum_required(VERSION 3.10)

project( main )

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake )

find_package(ADD)

if(ADD_FOUND)
    include_directories(${ADD_INCLUDE_DIR})
else(ADD_FOUND)
    message(FATAL_ERROR "ADD library not fount")
endif(ADD_FOUND)

add_executable( main main.cpp )

target_link_libraries(main ${ADD_LIBRARY} )


