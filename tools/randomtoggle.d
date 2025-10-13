#!/usr/bin/env -S dmd -i -run
import std;

// Copy the todolist struct from format.d
struct todolist
{
    string title;
    string[] items;
    bool[] crossed;
    void sanitize()
    {
        if (crossed.length < items.length)
        {
            crossed.length = items.length;
        }
    }
}

todolist[][] openkantban(string where)
{
    if (!exists(where))
        return [];
    todolist[][] result;
    todolist[] col;
    todolist cur;
    foreach (line; File(where).byLineCopy)
    {
        if (line.startsWith("# "))
        {
            if (cur.title.length)
                col ~= cur;
            if (col.length)
                result ~= col;
            col = [];
            cur = todolist();
        }
        else if (line.startsWith("## "))
        {
            if (cur.title.length)
                col ~= cur;
            cur = todolist(line[3 .. $].idup);
        }
        else if (line.startsWith("- "))
        {
            bool done = line.startsWith("- [x]");
            string item = done ? line[6 .. $].idup : line[2 .. $].idup;
            if (line.startsWith("- [ ]"))
                item = line[6 .. $].idup;
            cur.items ~= item;
            cur.crossed ~= done;
        }
    }
    if (cur.title.length)
        col ~= cur;
    if (col.length)
        result ~= col;
    return result;
}

void savekantban(todolist[][] data, string where)
{
    auto f = File(where, "w");
    foreach (col; data)
    {
        f.writeln("# Column");
        foreach (card; col)
        {
            f.writeln("## ", card.title);
            foreach (i, item; card.items)
            {
                bool done = i < card.crossed.length && card.crossed[i];
                f.writeln(done ? "- [x] " : "- [ ] ", item);
            }
        }
    }
}

void main(string[] args)
{
    if (args.length != 2)
    {
        writeln("Usage: randomtoggle <file.kantban>");
        writeln("Randomly toggles completion status of items in kanban file");
        return;
    }

    string filename = args[1];

    if (!exists(filename))
    {
        writeln("Error: File '", filename, "' not found");
        return;
    }

    if (!filename.endsWith(".kantban"))
    {
        writeln("Warning: File doesn't have .kantban extension");
    }

    // Load the kanban data
    auto data = openkantban(filename);

    if (data.length == 0)
    {
        writeln("No data found in file");
        return;
    }

    int totalItems = 0;
    int toggledItems = 0;

    // Count total items first
    foreach (col; data)
    {
        foreach (card; col)
        {
            totalItems += card.items.length;
        }
    }

    writeln("Found ", totalItems, " items across ", data.length, " columns");

    // Randomly toggle items (30% chance each)
    foreach (ref col; data)
    {
        foreach (ref card; col)
        {
            card.sanitize(); // Ensure crossed array is right size

            foreach (i, ref crossed; card.crossed)
            {
                if (uniform(0, 100) < 30) // 30% chance to toggle
                {
                    crossed = !crossed;
                    toggledItems++;

                    string status = crossed ? "[x]" : "[ ]";
                    writeln("  ", status, " ", card.title, ": ", card.items[i]);
                }
            }
        }
    }

    writeln("\nToggled ", toggledItems, " out of ", totalItems, " items");

    // Save back to file
    savekantban(data, filename);
    writeln("Saved changes to ", filename);
}
