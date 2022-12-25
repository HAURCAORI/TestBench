cmake_minimum_required(VERSION 3.11)

project(
  TestBench
  VERSION 1.0
  LANGUAGES CXX)

set(CMAKE_CXX_COMPILER g++)
add_compile_options(-Wall -O2 -std=c++14)

# Set lib & binary output directory
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Variable
set(GLOBAL_INCLUDE_DIR "include")
set(LIBRARY_INCLUDE_DIRS)

#Library Search DIRS
set(LIBRARY_SEARCH_DIRS
#    hdf5_cxx
)

set(LIBRARY_LIST 
    libhdf5.a
    libmpi.so
)

set(STATIC_LIBRARIES)
set(SHARED_LIBRARIES)
set(LIBRARY_TARGETS)

add_subdirectory(lib)

macro(DIRLASTELEMENT result dir)
    string(FIND ${dir} "/" index REVERSE)
    MATH(EXPR nextindex "${index} + 1")
    string(SUBSTRING ${dir} ${nextindex} -1 name)
    set(${result} ${name})
endmacro()

foreach(static_lib ${STATIC_LIBRARIES})
  DIRLASTELEMENT(lib_name ${static_lib})
  add_library(${lib_name} STATIC IMPORTED)
  set_target_properties(${lib_name} PROPERTIES
    IMPORTED_LOCATION "${static_lib}"
    #INTERFACE_INCLUDE_DIRECTORIES "${LIB_INCLUDE_DIR}"
  )
  list(APPEND LIBRARY_TARGETS ${lib_name})
endforeach()


add_subdirectory(src)


include_directories(${PROJECT_INCLUDE_DIR} ${LIBRARY_INCLUDE_DIRS})
