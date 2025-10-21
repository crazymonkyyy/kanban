#!/usr/bin/env -S opend -run
/**
 * Syntax test for raylib's screenshot function
 * This tests how to properly call raylib's TakeScreenshot function from D via the parin library
 */

import parin;
import std;
import std.datetime : Clock;

void ready() {
    writeln("Testing raylib screenshot functionality...");
}

bool update(float dt) {
    drawRect(Rect(100, 100, 200, 150), Color(255, 100, 100, 255)); // Red rectangle
    drawRect(Rect(300, 200, 150, 100), Color(100, 255, 100, 255)); // Green rectangle
    static int i;
    if(i++==5){takescreenshot("screenshot.png");}
    if(i==6){return true;}
    return false; // Continue running
}

void finish() {
    writeln("Screenshot test finished");
}

mixin runGame!(ready, update, finish);
