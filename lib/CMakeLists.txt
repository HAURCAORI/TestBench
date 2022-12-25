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
    string(SUBSTRING ${lib} ${index} -1 EXTENSION)
    set(${result} ${EXTENSION})
endmacro()

if(NOT LIBRARY_SEARCH_DIRS)
    SUBDIRLIST(LIBRARY_SEARCH_DIRS ${CMAKE_CURRENT_LIST_DIR})
else()
    foreach(dir ${LIBRARY_SEARCH_DIRS})
        if(NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/${dir}")
            message(FATAL_ERROR "Can't find library directory: ${dir}")
        endif()
    endforeach()
endif()


foreach(subdir ${LIBRARY_SEARCH_DIRS})
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

            set(lib_path "${LIB_DIR}/${lib_check}")

            if(WIN32)
                if(${lib_extension} STREQUAL ".lib")
                    #add_library(${lib_name} STATIC IMPORTED)
                    list(APPEND STATIC_LIBRARIES ${lib_path})
                elseif(${lib_extension} STREQUAL ".dll")
                    #add_library(${lib_name} SHARED IMPORTED)
                    list(APPEND SHARED_LIBRARIES ${lib_path})
                else()
                    message(FATAL_ERROR "Unknown extension: ${lib_check}")
                endif()
            else()
                if(${lib_extension} STREQUAL ".a")
                    #add_library(${lib_name} STATIC IMPORTED)
                    list(APPEND STATIC_LIBRARIES ${lib_path})
                elseif(${lib_extension} STREQUAL ".so")
                    #add_library(${lib_name} SHARED IMPORTED)
                    list(APPEND SHARED_LIBRARIES ${lib_path})
                else()
                    message(FATAL_ERROR "Unknown extension: ${lib_check}")
                endif()
            endif()

            #set_target_properties(${lib_name} PROPERTIES
            #    IMPORTED_LOCATION "${LIB_DIR}/${lib_check}"
            #    INTERFACE_INCLUDE_DIRECTORIES "${LIB_INCLUDE_DIR}"
            #)

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

set(STATIC_LIBRARIES ${STATIC_LIBRARIES} PARENT_SCOPE)
set(SHARED_LIBRARIES ${SHARED_LIBRARIES} PARENT_SCOPE)

#add_library(bar SHARED IMPORTED) # or STATIC instead of SHARED
#set_target_properties(bar PROPERTIES
#  IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/lib/libbar.so"
#  INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/include/libbar"
#)

#set(FOO_SRCS "foo.cpp")
#add_executable(foo ${FOO_SRCS})
#target_link_libraries(foo bar) # also adds the required include path