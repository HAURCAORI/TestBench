macro(PARENTDIR result dir)
    string(FIND ${dir} "/" index REVERSE)
    string(SUBSTRING ${dir} 0 ${index} path)
    set(${result} ${path})
endmacro()


add_executable(${PROGRAM_NAME} main.cpp)
target_link_libraries(${PROGRAM_NAME} PUBLIC ${PROGRAM_LIBRARY_TARGETS})
target_include_directories(${PROGRAM_NAME} PUBLIC ${PROGRAM_INCLUDE_DIR})# ${LIBRARY_INCLUDE_DIRS})

set(runtime_path)
if(PROGRAM_SHARED_LIBRARIES)
    foreach(lib_dir ${PROGRAM_SHARED_LIBRARIES})
        PARENTDIR(parent ${lib_dir})
        list(APPEND runtime_path "-Wl,-R${parent}")
    endforeach()

endif()

target_link_options(main PUBLIC ${runtime_path})