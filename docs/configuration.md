# Configuration System Documentation

## Overview
The Kanban application uses a configuration system defined in `configs.d` that controls various aspects of the application's appearance and behavior, including fonts, colors, layout, and sizing.

## Configuration Elements

### String Configurations
These are defined as `enum` constants at the top of `configs.d`:

```d
enum titlefontname="Noto Sans";      // Font name for card titles
enum textfontname="Noto Sans";       // Font name for card items
enum textsize=22;                    // Base text size in pixels
enum colorschemename="Solarized-Dark"; // Color scheme name
enum layout="Justified";             // Layout style (currently unused)
enum boxstyle="Rounded-30";         // Box rounding style (currently unused)
```

### Color System
The application uses the Solarized color palette system:

1. **Color CSV**: Colors are loaded from `color.csv` which contains 512 predefined color schemes
2. **Palette Generation**: The `initpalette()` function generates a 16-color palette based on the selected color scheme
3. **Color Mapping**: Colors are mapped to semantic purposes (background, text, accents, etc.)

### Font System
The font system handles font loading and downloading:

1. **Font Discovery**: The `findfont()` function locates fonts on the system
2. **Font Downloading**: If a font is not found locally, it attempts to download it from Google Fonts
3. **Font Paths**: Fonts are stored in `~/.local/share/fonts/` by default

### Font Functions
```d
string titlefontpath() => findfont(titlefontname);  // Get path to title font
string textfontpath() => findfont(textfontname);   // Get path to text font
string findfont(string font="");                  // Find or download a font
```

## Implementation Details

### Color Scheme Selection
The `tocolorschemerow()` function converts a color scheme name to a row index in the `color.csv` file by:
1. Normalizing the color scheme name (converting spaces to hyphens, lowercase)
2. Searching for a matching row in the CSV data
3. Returning the row index or a default value (136) if not found

### Palette Initialization
The `initpalette()` function:
1. Uses `tocolorschemerow()` to find the correct color scheme
2. Calls `csvRowToPalette()` to convert the CSV row to a 16-color palette
3. Stores the palette in the global `palette` variable

### Font Loading Process
The `findfont()` function:
1. Checks if the font parameter is empty and uses the fallback font if so
2. Checks if the font path looks like a file path and verifies its existence
3. Constructs a file path in the standard fonts directory using the font name
4. Checks if the font file exists locally
5. If not found, attempts to download it from Google Fonts using the font name
6. Parses the Google Fonts CSS response to extract the font file URL
7. Downloads the font file to the local system

## Configuration Validation
Several `static assert` statements ensure configuration consistency:
```d
static assert(boxstyle=="Rounded-30");    // Validates box style
static assert(layout=="Justified");      // Validates layout
static assert(colorschemename=="Solarized-Dark"); // Validates color scheme
```

## Customization

### Changing Fonts
To use different fonts:
1. Modify `titlefontname` and `textfontname` enums
2. The system will automatically find or download the fonts

### Changing Colors
To use different color schemes:
1. Modify `colorschemename` enum to a different scheme from `color.csv`
2. The palette will be regenerated with the new scheme

### Changing Text Size
To change text size:
1. Modify `textsize` enum to a different value
2. All text elements will scale accordingly

## Error Handling

### Font Loading Failures
- Falls back to `fallbackfont` ("Noto Sans") if the primary font fails
- Uses `assert(runonce, "ran twice meaning something is very wrong")` to prevent infinite recursion

### File System Issues
- Uses `exists()` function to check file existence with proper tilde expansion
- Handles both relative and absolute file paths

## Dependencies

### External Libraries
- Relies on `std.file` for file system operations
- Uses `std.process` for executing shell commands
- Depends on `parin` for some utility functions

### Network Dependencies
- Requires internet access to download fonts from Google Fonts
- Uses `curl` command-line tool for HTTP requests