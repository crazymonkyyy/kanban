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

struct ValidationError
{
    int lineNumber;
    string message;
    string line;
}

class ValidationResult
{
    ValidationError[] errors;
    ValidationError[] warnings;
    int columns;
    int cards;
    int items;
    bool isValid;

    void addError(int line, string msg, string content = "")
    {
        errors ~= ValidationError(line, msg, content);
        isValid = false;
    }

    void addWarning(int line, string msg, string content = "")
    {
        warnings ~= ValidationError(line, msg, content);
    }
}

ValidationResult validateKantban(string filename)
{
    auto result = new ValidationResult();
    result.isValid = true;

    if (!exists(filename))
    {
        result.addError(0, "File does not exist", filename);
        return result;
    }

    try
    {
        string[] lines = readText(filename).splitLines();
        bool inColumn = false;
        bool inCard = false;
        string currentCard = "";
        int lineNum = 0;

        foreach (line; lines)
        {
            lineNum++;
            string trimmed = line.strip();

            // Skip empty lines
            if (trimmed.length == 0)
                continue;

            // Column headers
            if (trimmed.startsWith("# "))
            {
                if (trimmed.length <= 2)
                {
                    result.addWarning(lineNum, "Column header is empty", line);
                }
                else
                {
                    result.columns++;
                }
                inColumn = true;
                inCard = false;
            }
            // Card headers
            else if (trimmed.startsWith("## "))
            {
                if (!inColumn)
                {
                    result.addError(lineNum, "Card found outside of column", line);
                }
                if (trimmed.length <= 3)
                {
                    result.addError(lineNum, "Card title is empty", line);
                }
                else
                {
                    currentCard = trimmed[3 .. $];
                    result.cards++;
                }
                inCard = true;
            }
            // Items
            else if (trimmed.startsWith("- "))
            {
                if (!inCard)
                {
                    result.addError(lineNum, "Item found outside of card", line);
                    continue;
                }

                result.items++;

                // Validate flexible checkbox syntax
                bool hasValidCheckbox = false;
                bool isEmpty = false;

                // Check for exact empty checkboxes first
                if (trimmed == "- [ ]" || trimmed == "- [x]" || trimmed == "- [X]")
                {
                    hasValidCheckbox = true;
                    isEmpty = true;
                }
                // Check standard format: "- [x]" or "- [ ]"
            else if (trimmed.length >= 6 && trimmed[2] == '[' && trimmed[4] == ']')
                {
                    hasValidCheckbox = true;
                    isEmpty = trimmed.length <= 6 || trimmed[6 .. $].strip.length == 0;
                }
                // Check flexible format: "- [x ]" or "- [ x]"
            else if (trimmed.length >= 7 && trimmed[2] == '[' && trimmed[5] == ']')
                {
                    hasValidCheckbox = true;
                    isEmpty = trimmed.length <= 7 || trimmed[7 .. $].strip.length == 0;
                }

                if (hasValidCheckbox)
                {
                    if (isEmpty)
                    {
                        result.addWarning(lineNum, "Item text is empty", line);
                    }
                }
                else if (trimmed.length <= 2)
                {
                    result.addWarning(lineNum, "Item text is empty", line);
                }
                else
                {
                    // Plain format without checkboxes - this is OK
                    result.addWarning(lineNum, "Item uses plain format (no checkbox)", line);
                }
            }
            // Invalid lines
            else
            {
                result.addError(lineNum, "Invalid line format", line);
            }
        }

        // Structure validation
        if (result.columns == 0)
        {
            result.addError(0, "No columns found in file");
        }
        if (result.cards == 0)
        {
            result.addWarning(0, "No cards found in file");
        }

    }
    catch (Exception e)
    {
        result.addError(0, "Failed to read file: " ~ e.msg);
    }

    return result;
}

todolist[][] parseKantban(string filename)
{
    if (!exists(filename))
        return [];

    todolist[][] result;
    todolist[] col;
    todolist cur;

    foreach (line; File(filename).byLineCopy)
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
            bool done = false;
            string item;

            // Check for various checkbox formats
            if (line.length >= 6 && line[2] == '[' && line[4] == ']')
            {
                // Format: "- [x]" or "- [ ]"
                done = (line[3] == 'x' || line[3] == 'X');
                item = line.length > 6 ? line[6 .. $].strip.idup : "";
            }
            else if (line.length >= 7 && line[2] == '[' && line[5] == ']')
            {
                // Format: "- [x ]" or "- [ x]" - flexible spacing
                done = (line[3] == 'x' || line[3] == 'X' || line[4] == 'x' || line[4] == 'X');
                item = line.length > 7 ? line[7 .. $].strip.idup : "";
            }
            else
            {
                // Plain format: "- item"
                item = line.length > 2 ? line[2 .. $].strip.idup : "";
                done = false;
            }

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

void main(string[] args)
{
    if (args.length != 2)
    {
        writeln("Usage: validate <file.kantban>");
        writeln("Validates the format and structure of a kanban file");
        return;
    }

    string filename = args[1];

    writeln("Validating: ", filename);
    writeln("=" ~ "=".replicate(filename.length + 12));

    // Format validation
    auto result = validateKantban(filename);

    // Parse validation
    todolist[][] data;
    try
    {
        data = parseKantban(filename);
    }
    catch (Exception e)
    {
        result.addError(0, "Parser failed: " ~ e.msg);
    }

    // Report results
    if (result.isValid && result.errors.length == 0)
    {
        writeln("✓ VALID");
    }
    else
    {
        writeln("✗ INVALID");
    }

    writeln();
    writeln("Statistics:");
    writeln("  Columns: ", result.columns);
    writeln("  Cards:   ", result.cards);
    writeln("  Items:   ", result.items);

    if (data.length > 0)
    {
        int totalParsedItems = 0;
        foreach (col; data)
        {
            foreach (card; col)
            {
                totalParsedItems += card.items.length;
            }
        }
        writeln("  Parsed:  ", totalParsedItems, " items in ", data.length, " columns");
    }

    if (result.errors.length > 0)
    {
        writeln();
        writeln("ERRORS:");
        foreach (error; result.errors)
        {
            if (error.lineNumber > 0)
            {
                writeln("  Line ", error.lineNumber, ": ", error.message);
                if (error.line.length > 0)
                    writeln("    > ", error.line);
            }
            else
            {
                writeln("  ", error.message);
            }
        }
    }

    if (result.warnings.length > 0)
    {
        writeln();
        writeln("WARNINGS:");
        foreach (warning; result.warnings)
        {
            if (warning.lineNumber > 0)
            {
                writeln("  Line ", warning.lineNumber, ": ", warning.message);
                if (warning.line.length > 0)
                    writeln("    > ", warning.line);
            }
            else
            {
                writeln("  ", warning.message);
            }
        }
    }

    if (!result.isValid)
    {
        writeln();
        writeln("File is invalid and may not work with the kanban application.");
    }
    else if (result.warnings.length > 0)
    {
        writeln();
        writeln("File is valid but has some issues that should be addressed.");
    }
    else
    {
        writeln();
        writeln("File is perfectly valid! ✓");
    }
}
