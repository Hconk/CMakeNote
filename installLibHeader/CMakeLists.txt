cmake_minimum_required(VERSION 3.10)

project( add )
add_library( add add.cpp )

install(TARGETS add 
    ARCHIVE DESTINATION /usr/local/lib/
    )
install(FILES add.hpp DESTINATION /usr/local/include )