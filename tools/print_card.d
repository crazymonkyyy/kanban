#!/usr/bin/dmd -run
import std.stdio;
import std.file;
import std.string;
import std.array;
import std.path;
import std.conv;

import format; // Import the format module to use the parsing functions

void main(string[] args) {
    if (args.length < 4) {
        writeln("Usage: ", baseName(args[0]), " <file.kantban> <x> <y>");
        writeln("  <file.kantban> - Path to the .kantban file");
        writeln("  <x> - Column index (0-based)");
        writeln("  <y> - Card index within column (0-based)");
        return;
    }

    string filePath = args[1];
    int x = to!int(args[2]);
    int y = to!int(args[3]);

    // Check if file exists
    if (!exists(filePath)) {
        writeln("Error: File '", filePath, "' does not exist.");
        return;
    }

    // Parse the file directly using the file path
    auto board = openkantban(filePath);

    // Validate indices
    if (x < 0 || x >= board.length) {
        writeln("Error: Column index ", x, " is out of bounds. Valid range: 0 to ", board.length - 1);
        return;
    }

    if (y < 0 || y >= board[x].length) {
        writeln("Error: Card index ", y, " is out of bounds for column ", x, ". Valid range: 0 to ", board[x].length - 1);
        return;
    }

    // Print the specific card
    auto card = board[x][y];
    writeln("Column ", x, ", Card ", y, ":");
    writeln("Title: ", card.title);
    writeln("Items:");
    foreach(i, item; card.items) {
        string status = card.crossed[i] ? "[x] " : "[ ] ";
        writeln("  ", status, item);
    }
}