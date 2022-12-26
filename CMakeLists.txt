# <CMake Minimum Version>
cmake_minimum_required(VERSION 3.11)

# <Project Property>
set(PROGRAM_NAME "main")
project(
  ${PROGRAM_NAME}
  VERSION 1.0
  LANGUAGES CXX)

# <CMake Options>
#set(CMAKE_VERBOSE_MAKEFILE ON)

# <Compiler Options>
set(CMAKE_CXX_COMPILER g++)
add_compile_options(-Wall -O2 -std=c++17)
add_link_options(-Wl,--copy-dt-needed-entries)

# <Set Directories>
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

# <Project Variable>
set(PROGRAM_SOURCE_DIR  "${PROJECT_SOURCE_DIR}/src")
set(PROGRAM_INCLUDE_DIR "${PROJECT_SOURCE_DIR}/include")
set(PROGRAM_LIBRARY_DIR "${PROJECT_SOURCE_DIR}/LIB")
set(PROGRAM_LIBRARY_TARGETS)  # Program Include Targets
set(PROGRAM_STATIC_LIBRARIES)
set(PROGRAM_SHARED_LIBRARIES)

# <Set Targets(Executable & Library)>
# PROGRAM_SOURCE_FILES [list] : Compile file list.
# If varialbe is empty, search all files.
set(PROGRAM_SOURCE_FILES

)

# PROGRAM_LIBRARY_NAMES [list] : Include libray list.
# If varialbe is empty, search all files.
set(PROGRAM_LIBRARY_NAMES
#    hdf5_cxx
)

# PROGRAM_LIBRARY_FILES [list] : Specific library files to include.
set(PROGRAM_LIBRARY_FILES 
  libhdf5_cpp.so
  libmpi.so
)

#= Processing =#
add_subdirectory(lib)
add_subdirectory(src)