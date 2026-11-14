# Raasta Tests

# For now, a simple test runner without a framework
# Tests use assert-style checks

# Collect test sources — each test_*.cpp has its own main()
file(GLOB TEST_SOURCES test_*.cpp)

foreach(test_src ${TEST_SOURCES})
    get_filename_component(test_name ${test_src} NAME_WE)
    
    # Build each test from the test source + all project sources except main.cpp
    file(GLOB_RECURSE PROJECT_SOURCES ${CMAKE_SOURCE_DIR}/src/*.cpp)
    list(FILTER PROJECT_SOURCES EXCLUDE REGEX ".*main\\.cpp$")
    
    add_executable(${test_name} ${test_src} ${PROJECT_SOURCES})
    
    target_include_directories(${test_name} PRIVATE
        ${CMAKE_SOURCE_DIR}/include
        ${HTTPLIB_INCLUDE_DIR}
    )
    
    if(nlohmann_json_FOUND)
        target_link_libraries(${test_name} PRIVATE nlohmann_json::nlohmann_json)
    else()
        target_include_directories(${test_name} PRIVATE ${NLOHMANN_JSON_INCLUDE_DIR})
    endif()
    
    if(RAASTA_ENABLE_MYSQL)
        target_include_directories(${test_name} PRIVATE ${MYSQL_INCLUDE_DIR})
        target_link_libraries(${test_name} PRIVATE ${MYSQL_LIBRARY})
    endif()
    
    find_package(Threads REQUIRED)
    target_link_libraries(${test_name} PRIVATE Threads::Threads)
    
    add_test(NAME ${test_name} COMMAND ${test_name})
endforeach()
