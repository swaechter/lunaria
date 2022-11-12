#include "video.h"

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t* terminal_buffer;

inline uint8_t vga_entry_color(enum vga_color foreground_color, enum vga_color background_color)
{
    return foreground_color | background_color << 4;
}

inline uint16_t vga_entry(unsigned char character, uint8_t color)
{
    return (uint16_t) character | (uint16_t) color << 8;
}

void initialize_terminal(void)
{
    // Reset the row/colum and color
    terminal_row = 0;
    terminal_column = 0;
    terminal_color = vga_entry_color(VGA_COLOR_WHITE, VGA_COLOR_BLACK);

    // Overwrite the screen with whitespaces
    terminal_buffer = (uint16_t*) 0xB8000;
    for (size_t row = 0; row < VGA_HEIGHT; row++) {
        for (size_t column = 0; column < VGA_WIDTH; column++) {
            putc(' ');
        }
    }
}

void putc(char c)
{
    // Print the character
    const size_t index = terminal_row * VGA_WIDTH + terminal_column;
    terminal_buffer[index] = vga_entry(c, terminal_color);

    // Check if we have to reset the column or even the row
    if (++terminal_column == VGA_WIDTH) {
        terminal_column = 0;
        if (++terminal_row == VGA_HEIGHT) {
            terminal_row = 0;
        }
    }
}

void puts(const char* string)
{
    // Iterate over the string and print each character
    size_t length = strlen(string);
    for (size_t i = 0; i < length; i++) {
        putc(string[i]);
    }
}
