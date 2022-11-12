# Define the source
set(KERNEL_SOURCES
    boot.asm
    kernel.c
    video.c
    libk/string.c
)

# Create the kernel
add_executable(kernel ${KERNEL_SOURCES})
set_target_properties(kernel PROPERTIES LINK_FLAGS "-T ${CMAKE_CURRENT_SOURCE_DIR}/linker.ld")
