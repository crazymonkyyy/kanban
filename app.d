#!/bin/env -S opend -run app.d
import parin;
import format;
import drawing;
import std;

string file = "TODO.kantban";
todolist[][] data;
int[] x;
int y;
void ready()
{
    // Check for command line arguments
    auto args = envArgs();
    if (args.length > 1)
    {
        file = args[1].to!string;
    }

    data = openkantban(file);
    initdrawing;
    x.length = data.length;
}

bool update(float dt)
{
    assert(x.length == data.length);
    y += Keyboard.down.isPressed - Keyboard.up.isPressed;
    x.clampindex(y) += Keyboard.right.isPressed - Keyboard.left.isPressed;

    draw(data, x, y);
    return false;
}

void finish()
{
}

mixin runGame!(ready, update, finish);

// Helper function
ref clampindex(T, I)(T[] a, ref I i)
{
    if (i < 0 || i == I.max)
    {
        i = 0;
    }
    if (i >= a.length)
    {
        i = cast(I) a.length - 1;
    }
    return a[i];
}
