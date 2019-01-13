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

## 安装库文件及对应头文件
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

install(TARGETS add 
    ARCHIVE DESTINATION /usr/local/lib/
    )
install(FILES add.hpp DESTINATION /usr/local/include )
```
> 文档链接  
[install](https://cmake.org/cmake/help/v3.13/command/install.html)