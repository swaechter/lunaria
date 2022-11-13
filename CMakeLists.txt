# Define the required minimum CMake version
cmake_minimum_required(VERSION 3.18)

# Ensure the cross compiler exists
if(NOT EXISTS "${CMAKE_SOURCE_DIR}/compiler")
    message(FATAL_ERROR "Unable to find the cross compiler. Please run ./script.sh setup")
endif()

# Define the C/C++ standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# Use our cross compiler
set(CMAKE_ASM-ATT_COMPILER "${CMAKE_SOURCE_DIR}/compiler/toolchain/bin/i686-elf-as")
set(CMAKE_C_COMPILER "${CMAKE_SOURCE_DIR}/compiler/toolchain/bin/i686-elf-gcc")
set(CMAKE_CXX_COMPILER "${CMAKE_SOURCE_DIR}/compiler/toolchain/bin/i686-elf-g++")

# Define some common compiler settings
set(CMAKE_ASM-ATTFLAGS "--32 -g")
set(CMAKE_C_FLAGS "-c -g -m32 -std=gnu99 -ffreestanding -O2 -Wall -Wextra")
set(CMAKE_CXX_FLAGS "-c -g -m32 -std=gnu99 -ffreestanding -O2 -Wall -Wextra")
set(CMAKE_C_LINK_EXECUTABLE "${CMAKE_C_COMPILER} <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES> -ffreestanding -O0 -nostdlib -g")

# Define the required minimum CMake version and the project with the used languages
project(lunaria LANGUAGES ASM-ATT C)

# Add the kernel
add_subdirectory(src)
