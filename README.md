# CMake 使用笔记
> `CMake` [维基百科](https://zh.wikipedia.org/wiki/CMake)  [官方文档](https://cmake.org/documentation/)  
> `CMake` 是个一个开源的跨平台自动化建构系统，可以方便的生成各种工程项目。功能强大，不过由于很多时候不会经常写 `CMakeLists` 也导致很容易忘记用法，经常是在使用时再通过搜索引擎查找某一用法，为了降低每次使用时的检索成本，维护一个备忘录，将一些简单的用法做下记录。并添加代码示例。
> 该项目为个人记录一些 CMake 的简单用法，属于备忘录性质。方便自己检索使用。

## 生成动态库
``` CMake
#设置 CMake 最低版本要求
cmake_minimum_required(VERSION 3.10)

#设置项目名称
project( add )

#自动查找 . 目录下的源码文件，并将文件名存储到SRC变量中
#   aux_source_directory(<dir> <variable>)
aux_source_directory(. SRC )

#最后生成库 add ，SHARED 指定生成动态库
#   add_library(<name> [STATIC | SHARED | MODULE]
#               [EXCLUDE_FROM_ALL]
#               [source1] [source2 ...])
add_library(add SHARED ${SRC} )
```

> 文档链接:  
[cmake_minimum_required](https://cmake.org/cmake/help/v3.13/command/cmake_minimum_required.html)  
[project](https://cmake.org/cmake/help/v3.13/command/project.html)  
[aux_source_directory](https://cmake.org/cmake/help/v3.13/command/aux_source_directory.html)  
[add_library](https://cmake.org/cmake/help/v3.13/command/add_library.html)

## 生成静态库
``` CMake
cmake_minimum_required(VERSION 3.10)

project( add )

aux_source_directory(. SRC )

# 内容基本同生成动态库， 在最后生成库时不加 SHARED 表明生成默认库，默认为静态库
add_library(add ${SRC} )
```

## 生成可执行文件
``` CMake
cmake_minimum_required(VERSION 3.10)

project( demo )

# add_executable 为生成可执行文件
#       add_executable(<name> [WIN32] [MACOSX_BUNDLE]
#               [EXCLUDE_FROM_ALL]
#               [source1] [source2 ...])
add_executable(demo demo.cpp)
```

> 文档链接:  
[add——executable](https://cmake.org/cmake/help/v3.13/command/add_executable.html)

## 链接静态库
``` CMake 
cmake_minimum_required(VERSION 3.10)

project( useStaticLib )

# 添加 include 查找目录
# include_directories([AFTER|BEFORE] [SYSTEM] dir1 [dir2 ...])
# 默认情况下添加在当前查找目录列表的最后
include_directories( ../static_lib )

# 添加链接库查找目录
# link_directories([AFTER|BEFORE] directory1 [directory2 ...])
link_directories( ../static_lib/build )

add_executable( useStaticLib useStaticLib.cpp )

# 将目标文件与库文件进行链接
# target_link_libraries(<target> ... <item>... ...)
target_link_libraries( useStaticLib add )
```
> 文档链接:  
[include_directories](https://cmake.org/cmake/help/v3.13/command/include_directories.html)  
[include_directories](https://cmake.org/cmake/help/v3.13/command/link_directories.html)   
[target_link_libraries](https://cmake.org/cmake/help/v3.13/command/target_link_libraries.html)  

## 链接动态库
``` CMake
# 内容同链接静态库, 运行时需要动态库文件
cmake_minimum_required(VERSION 3.10)

project( useDynamicLib )

include_directories( ../dynamic_lib )

link_directories( ../dynamic_lib/build )
add_executable( useDynamicLib useDynamicLib.cpp )

target_link_libraries( useDynamicLib add )
```

## 安装静态库文件及对应头文件
``` CMake
cmake_minimum_required(VERSION 3.10)

project( add )

add_library( add add.cpp )

# 安装目标到指定文件夹，用法如下
# install(TARGETS <target>... [...])
# install({FILES | PROGRAMS} <file>... DESTINATION <dir> [...])
# install(DIRECTORY <dir>... DESTINATION <dir> [...])
# install(SCRIPT <file> [...])
# install(CODE <code> [...])
# install(EXPORT <export-name> DESTINATION <dir> [...])
# RUNTIME: 可执行文件
# ARCHIVE: 静态库
# LIBRARY: 动态库
install(TARGETS add 
    ARCHIVE DESTINATION /usr/local/lib/
    )
install(FILES add.hpp DESTINATION /usr/local/include )
```
> 文档链接  
[install](https://cmake.org/cmake/help/v3.13/command/install.html)  

## 安装动态库文件及对应头文件
``` CMake
cmake_minimum_required(VERSION 3.10)

project( add )

add_library( add SHARED add.cpp )

# 内容基本同上
# LIBRARY: 该参数指定为动态库文件
install(TARGETS add 
    LIBRARY DESTINATION /usr/local/lib 
    )
install(FILES add.hpp DESTINATION /usr/local/include )
```

## 模块的使用及自定义模块
使用 find_package
``` CMake
cmake_minimum_required(VERSION 3.10)

project( main )

# 设置 CMake 查找module的文件路径
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake )

# 查找 ADD 库
# find_package(<PackageName> [version] [EXACT] [QUIET] [MODULE]
#             [REQUIRED] [[COMPONENTS] [components...]]
#             [OPTIONAL_COMPONENTS components...]
#             [NO_POLICY_SCOPE])
find_package(ADD)

# 在 FindADD.cmake 文件中会定义 ADD_FOUND 变量用于判断是否查找成功
# 在查找成功后会添加 ${ADD_INCLUDE_DIR} 头文件查找路径， 和 ${ADD_LIBRARY} 库文件名两个变量
if(ADD_FOUND)
    include_directories(${ADD_INCLUDE_DIR})
else(ADD_FOUND)
    message(FATAL_ERROR "ADD library not fount")
endif(ADD_FOUND)

add_executable( main main.cpp )

target_link_libraries(main ${ADD_LIBRARY} )
```
> 文档链接  
[find_package](https://cmake.org/cmake/help/v3.13/command/find_package.html)

## Find 模块编写
``` CMake
# 查找文件名，及查找路径路径，查找成功会将路径设置到 ADD_INCLUDE_DIR 变量中
# find_path (<VAR> name1 [path1 path2 ...])
find_path(ADD_INCLUDE_DIR add.hpp /usr/local/include /usr/include )

# 查找库文件名，及查找路径，查找成功会将库文件路径设置到 ADD_LIBRARY 变量中
# find_library (<VAR> name1 [path1 path2 ...])
find_library(ADD_LIBRARY NAMES add PATH /usr/local/lib /usr/lib/ )

# 如果查找成功设置 ADD_FOUND 变量为 true
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
```
> 文档链接  
[find_library](https://cmake.org/cmake/help/v3.13/command/find_library.html)