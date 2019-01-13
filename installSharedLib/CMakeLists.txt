cmake_minimum_required(VERSION 3.10)

project( add )

add_library( add SHARED add.cpp )

install(TARGETS add 
    LIBRARY DESTINATION /usr/local/lib 
    )
install(FILES add.hpp DESTINATION /usr/local/include )

