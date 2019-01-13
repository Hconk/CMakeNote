find_path(ADD_INCLUDE_DIR add.hpp /usr/local/include /usr/include )
find_library(ADD_LIBRARY NAMES add PATH /usr/local/lib /usr/lib/ )

if(ADD_INCLUDE_DIR AND ADD_LIBRARY)
    set(ADD_FOUND true)
endif(ADD_INCLUDE_DIR AND ADD_LIBRARY

if(ADD_FOUND)
    if(NOT ADD_FIND_QUIETLY)
    message(STATUS "Found add: ${ADD_LIBRARY}")
    endif(NOT ADD_FIND_QUIETLY)
else(ADD_FOUND)
    if(ADD_FIND_REQUIRED)
    message(FATAL_ERROR "Could not find hello library")
    endif(ADD_FIND_REQUIRED)
endif(ADD_FOUND)