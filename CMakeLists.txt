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

# Library variable
set(GLOBAL_INCLUDE_DIR "include")
set(LIBRARY_INCLUDE_DIRS)

set(LIBRARY_TARGETS)


add_subdirectory(lib)

add_subdirectory(src)

include_directories(${PROJECT_INCLUDE_DIR} ${LIBRARY_INCLUDE_DIRS})