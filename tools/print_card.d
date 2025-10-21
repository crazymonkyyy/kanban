#!/usr/bin/env -S opend -run tools/print_card.d
import std;
import format;

int main(string[] args) {
    if (args.length < 4) {
        writeln("Usage: ", args[0], " <file.kantban> <x> <y>");
        writeln("Prints the todo card at the specified x,y coordinates");
        return 1;
    }

    string filename = args[1];
    int x = args[2].to!int;
    int y = args[3].to!int;

    // Check if file exists
    if (!std.file.exists(filename)) {
        writeln("Error: File does not exist: ", filename);
        return 1;
    }

    // Load the kanban data
    auto data = openkantban(filename);

    // Check if coordinates are valid
    if (y < 0 || y >= cast(int)data.length) {
        writeln("Error: y coordinate out of bounds. Valid range: 0 to ", data.length - 1);
        return 1;
    }

    if (x < 0 || x >= cast(int)data[y].length) {
        writeln("Error: x coordinate out of bounds for column ", y, ". Valid range: 0 to ", data[y].length - 1);
        return 1;
    }

    // Print the card at the specified coordinates
    auto card = data[y][x];
    writeln("Card at [", y, "][", x, "]:");
    writeln("Title: ", card.title);
    writeln("Items:");
    
    foreach(i, item; card.items) {
        string status = (i < card.crossed.length && card.crossed[i]) ? "[x]" : "[ ]";
        writeln("  ", status, " ", item);
    }

    return 0;
}