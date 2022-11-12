# Define the required minimum CMake version and the project with the used languages
cmake_minimum_required(VERSION 3.18)
project(lunaria LANGUAGES ASM-ATT C)

# Define the C/C++ standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# Use our cross compiler
set(CMAKE_ASM-ATT_COMPILER "i686-elf-as")
set(CMAKE_C_COMPILER "i686-elf-gcc")
set(CMAKE_CXX_COMPILER "i686-elf-g++")

# Define some common compiler settings
set(CMAKE_ASM-ATTFLAGS "--32 -g")
set(CMAKE_C_FLAGS "-c -g -m32 -std=gnu99 -ffreestanding -O2 -Wall -Wextra")
set(CMAKE_CXX_FLAGS "-c -g -m32 -std=gnu99 -ffreestanding -O2 -Wall -Wextra")
set(CMAKE_C_LINK_EXECUTABLE "${CMAKE_C_COMPILER} <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES> -ffreestanding -O0 -nostdlib -g")

# Add the kernel
add_subdirectory(src)
