cmake_minimum_required (VERSION 3.17)
cmake_policy (SET CMP0053 NEW)
cmake_policy (SET CMP0054 NEW)

project (
  matmul
  VERSION 1.0.0
  LANGUAGES Fortran)

# Prevent from building in source
if ("${PROJECT_SOURCE_DIR}" STREQUAL "${PROJECT_BINARY_DIR}")
   message(SEND_ERROR "In-source builds are disabled. Please
           issue cmake command in separate build directory.")
endif ("${PROJECT_SOURCE_DIR}" STREQUAL "${PROJECT_BINARY_DIR}")

# Set the default build type to release
if (NOT CMAKE_BUILD_TYPE)
  message (STATUS "Setting build type to 'Release' as none was specified.")
  set (CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property (CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug" "Release" "Aggressive")
endif ()

list (APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/support)
#include (esma_check_install_prefix)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/compiler)
#include (esma_compiler)

# Enable some global flags
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -cpp")

add_executable(matmul.x src/matmul.F90)
install(TARGETS matmul.x DESTINATION bin)

add_executable(matmul_interactive.x src/matmul_interactive.F90)
install(TARGETS matmul_interactive.x DESTINATION bin)

#add_executable(matmul_block.x src/matmul_block.F90)
#install(TARGETS matmul_block.x DESTINATION bin)

#add_executable(matmul_loop.x src/matmul_loop.F90)
#install(TARGETS matmul_loop.x DESTINATION bin)

#add_executable(matmul_block_loop.x src/matmul_block_loop.F90)
#install(TARGETS matmul_block_loop.x DESTINATION bin)

add_executable(matmul_block_v2_loop.x src/matmul_block_v2_loop.F90)
install(TARGETS matmul_block_v2_loop.x DESTINATION bin)

