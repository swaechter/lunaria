#!/bin/bash

# Enable status code handling in case of an error
set -e

# Define the colors
TITLE="\e[1m"
SUBTITLE="\e[1m"
COMMAND="\e[32m"
CLEAN="\e[0m"

function pushd ()
{
    command pushd "$@" > /dev/null
}

function popd ()
{
    command popd > /dev/null
}

function check_system ()
{
    echo "Going to check the local development environment"

    # Check for all commands
    declare -a commands=("wget" "git" "cmake" "i686-elf-as" "i686-elf-gcc" "i686-elf-ld" "qemu-system-i386")
    for i in "${commands[@]}"
    do
        if ! [ -x "$(command -v "$i")" ]; then
            echo "Command $i is not installed. Please install it."
            exit 1
        else
            echo "Found $i"
        fi
    done

    echo "Checked the system"
}

function setup_system ()
{
    echo "Going to setup the local development environment"
    # TODO
    echo "Done setting up the local development environment. Please reboot your system!"
}

function clean_project ()
{
    echo "Going to clean"

    # Clean the project build and image
    rm -rf build
    rm -f iso/boot/kernel

    echo "Done cleaning"
}

function build_project ()
{
    echo "Going to build"

    # Create the directory
    mkdir -p build

    # Build the project
    pushd build
    cmake ..
    make
    popd

    echo "Done building"
}

function package_project ()
{
    echo "Going to package"

    # Build the project
    build_project

    # Check the binary
    if grub-file --is-x86-multiboot build/src/kernel; then
        echo "Binary is multiboot"
    else
        echo "Binary is not multiboot - aborting"
        exit 1
    fi

    cp build/src/kernel iso/boot/kernel
    grub-mkrescue -o os.iso iso

    echo "Done packaging"
}

function run_qemu ()
{
    echo "Going to run ISO in QEMU"

    # Package the ISO
    package_project

    # Run the project in Qemu
    echo "Press Ctrl + Alt + G to release the focus"
    qemu-system-i386 -cdrom os.iso

    echo "Done running"
}

function run_bochs ()
{
    echo "Going to run ISO in Bochs"
    # TODO
    echo "Done running"
}

function show_about ()
{
    echo "Lunaria OS Command Line Interface"
    echo "Author: Simon Wächter <waechter.simon@gmail.com>"
}

function show_help ()
{
    echo -e "---------------------------------------------------------------------"
    echo -e "${TITLE}Welcome to the Lunaria OS Command Line Interface${CLEAN}"
    echo -e "---------------------------------------------------------------------"
    echo -e ""
    echo -e "${SUBTITLE}Usage:${CLEAN}  ${COMMAND}script.sh <Command>${CLEAN}"
    echo -e ""
    echo -e "${SUBTITLE}Commands for development environment${CLEAN}"
    echo -e ""
    echo -e "        ${COMMAND}setup${CLEAN}             Setup the local development environment"
    echo -e "        ${COMMAND}check${CLEAN}             Check the local development environment"
    echo -e "        ${COMMAND}clean${CLEAN}             Clean the project"
    echo -e "        ${COMMAND}build${CLEAN}             Build the project without tests"
    echo -e "        ${COMMAND}package${CLEAN}           Package the OS as a bootable ISO"
    echo -e "        ${COMMAND}run-qemu${CLEAN}          Run the ISO in QEMU"
    echo -e "        ${COMMAND}run-bochs${CLEAN}         Run the ISO in Bochs"
    echo -e ""
    echo -e "${SUBTITLE}General commands${CLEAN}"
    echo -e ""
    echo -e "        ${COMMAND}about${CLEAN}             Show the general information"
    echo -e "        ${COMMAND}help${CLEAN}              Show this help"
    echo -e ""
}

# Check to not execute the script as root user (Prevent user access issues)
if [ "$EUID" -eq 0 ]; then
    echo "Please do not execute this script as root. The script will prompt you for access rights via sudo"
    exit
fi

# Change the directory
pushd "$(dirname "$0")"

command="$1"

case $command in
    setup)
        setup_system
        ;;
    check)
        check_system
        ;;
    clean)
        clean_project
        ;;
    build)
        build_project
        ;;
    package)
        package_project
        ;;
    run-qemu)
        run_qemu
        ;;
    run-bochs)
        run_bochs
        ;;
    about)
        show_about
        ;;
    *)
        show_help
        ;;
esac

# Change back to the original directory
popd
