set(LIBRARY_DIRS
#    hdf5_cxx
)

set(LIBRARY_LIST 
    libhdf5.a
    libmpi.so
)

macro(SUBDIRLIST result curdir)
  file(GLOB children RELATIVE ${curdir} ${curdir}/*)
  set(dirlist "")
  foreach(child ${children})
    if(IS_DIRECTORY ${curdir}/${child})
      list(APPEND dirlist ${child})
    endif()
  endforeach()
  set(${result} ${dirlist})
endmacro()

macro(SUBFILELIST result curdir)
    file(GLOB children RELATIVE ${curdir} ${curdir}/*)
    set(filelist "")
    foreach(child ${children})
        if(EXISTS ${curdir}/${child})
            list(APPEND filelist ${child})
        endif()
    endforeach()
    set(${result} ${filelist})
endmacro()

macro(LIBNAME result lib)
    string(REGEX REPLACE "^lib" "" NAME_REMOVE_LIB ${lib})
    string(FIND ${NAME_REMOVE_LIB} "." index)

    string(SUBSTRING ${NAME_REMOVE_LIB} 0 ${index} NAME_REMOVE_EXTENSION)
    set(${result} ${NAME_REMOVE_EXTENSION})
endmacro()

macro(LIBEXTENSION result lib)
    string(FIND ${lib} "." index REVERSE)
    MATH(EXPR nextindex "${index}+1")
    string(SUBSTRING ${lib} ${nextindex} -1 EXTENSION)
    set(${result} ${EXTENSION})
endmacro()

if(NOT LIBRARY_DIRS)
    SUBDIRLIST(LIBRARY_DIRS ${CMAKE_CURRENT_LIST_DIR})
else()
    foreach(dir ${LIBRARY_DIRS})
        if(NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/${dir}")
            message(FATAL_ERROR "Can't find library directory: ${dir}")
        endif()
    endforeach()
endif()


foreach(subdir ${LIBRARY_DIRS})
    set(LIB_DIR "${CMAKE_CURRENT_LIST_DIR}/${subdir}/lib")
    set(LIB_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/${subdir}/include")
    if(NOT EXISTS ${LIB_DIR})
        continue()
    endif()

    SUBFILELIST(LIB_FILE_LIST ${LIB_DIR})
    
    foreach(lib_check ${LIBRARY_LIST})
        if(lib_check IN_LIST LIB_FILE_LIST)
            if(NOT EXISTS ${LIB_INCLUDE_DIR})
                message(FATAL_ERROR "Can't find library include directory: ${LIB_INCLUDE_DIR}")
            endif()


            LIBNAME(lib_name ${lib_check})
            LIBEXTENSION(lib_extension ${lib_check})
            message("EXTENSION : ${lib_extension}")
            #add_librar(lib_name SHARED IMPORTED)


            list(APPEND LIBRARY_INCLUDE_DIRS ${LIB_INCLUDE_DIR})
            list(REMOVE_ITEM LIBRARY_LIST ${lib_check})
            message(STATUS "Find library: ${lib_check}")
        endif()
    endforeach()
endforeach()

if(LIBRARY_LIST)
    message(FATAL_ERROR "Can't find library: ${LIBRARY_LIST}")
endif()

set(LIBRARY_INCLUDE_DIRS ${LIBRARY_INCLUDE_DIRS} PARENT_SCOPE)


#add_library(bar SHARED IMPORTED) # or STATIC instead of SHARED
#set_target_properties(bar PROPERTIES
#  IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/lib/libbar.so"
#  INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/include/libbar"
#)

#set(FOO_SRCS "foo.cpp")
#add_executable(foo ${FOO_SRCS})
#target_link_libraries(foo bar) # also adds the required include path