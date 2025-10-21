import format;
import parin;
import configs;
import rl = parin.bindings.rl;
import bk = parin.backend;

FontId textfont;
FontId titlefont;
//static this(){
void initdrawing(){
	//setIsUsingAssetsPath(false); //I set to false in engine
	textfont=loadFont(textfontpath(),textsize);
	assert(textfont.isValid);
	titlefont=loadFont(titlefontpath(),textsize+textsize/3);
	assert(titlefont.isValid);
	initpalette();
}
//NOTE: The original had a different colorindex function without the mod function and different logic
//NOTE: The original had a simpler colorindex function: int colorindex(int x,int y)=>x+y*2;
int colorindex(int x,int y)=>x+y*2;
//NOTE: The original had different draw function without the mathematical background and different parameters
//NOTE: The original draw function was much simpler and didn't have colorindex parameter
void draw(todolist[][] data,int[] xs,int ys){
	// Draw mathematical pattern background
	drawMathBackground();

	// Check if data is empty before accessing data[0][0]
	if(data.length == 0 || data[0].length == 0) {
		return; // Nothing to draw
	}
	
	auto r=estimate(data[0][0]);
	foreach(int y,list;data){
	foreach(int x,e;list){
		e.draw(Vec2((r.x+r.x/5)*(x-xs[ys]),(r.y+r.y/5)*(y-ys)),colorindex((x-xs[ys]),(y-ys)));
	}}
	//data[0][0].draw(Vec2(300,300));
}
Vec2 estimate(todolist data)=>Vec2(300,400);
void draw(todolist data, Vec2 where, int colorindex){
	data.sanitize;
	auto e=estimate(data);
	auto r=Rect(where.x,where.y,e.x,e.y);
	// Use mathematical background pattern for each card
	Color cardBg = getMathBackgroundColor(cast(int) where.x, cast(int) where.y, colorindex);
	drawrounded(r, palette[mod(colorindex, 8) + 8], cardBg);
	data.title.drawtitle(r, colorindex);
	import std;

	foreach(i;0..cast(int)data.items.length){
		drawitem(i,data.items[i],data.crossed[i],r, colorindex);
	}
}
enum roundness=90.0;
//enum background=cyan;
void drawrounded(Rect r, Color outline, Color background){
	float round=roundness/min(r.size.x,r.size.y);
	// Draw subtle background
	rl.DrawRectangleRounded(bk.toRl(r),round,9,bk.toRl(background));
	// Draw colored outline
	rl.DrawRectangleRoundedLinesEx(bk.toRl(r),round,9, 10,bk.toRl(outline));
}
void drawtitle(string s,Rect r, int colorindex){
	//drawRect(Rect(r.x+15,r.y+15,300,30));
	drawText(titlefont,s,Vec2(r.x+15,r.y+15), DrawOptions(color : palette[15])); // base0F - bright white
}
void drawitem(int i,string s,bool crossed,Rect r, int colorindex){
	Vec2 where=Vec2(r.x+20,r.y+i*25+40);
	Color textcolor = crossed ? palette[3] : palette[4]; // base03 for crossed (dark gray), base04 for normal (light gray)
	drawText(textfont,s,where);

	// Draw strikethrough line for crossed items
	if(crossed){
		Vec2 textSize = measureTextSize(textfont, s);
		float lineY = where.y + textSize.y * 0.5; // Middle of text height
		Color lineColor = palette[3];
		lineColor.a = 180; // Semi-transparent
		drawRect(Rect(where.x, lineY, textSize.x, 2), lineColor);
	}
}

// Mathematical background pattern functions
void drawMathBackground(){
	// Base background
	drawRect(Rect(0, 0, 2000, 2000), palette[0]); // base00 - dark background

	// Fibonacci spiral pattern
	drawFibonacciSpiral();

	// Grid pattern with golden ratio spacing
	drawGoldenGrid();

	// Sine wave overlay
	drawSineWavePattern();
}

void drawFibonacciSpiral(){
	import std.math : PI, sin, cos;

	Vec2 center = Vec2(400, 300);
	float phi = 1.618033988749; // golden ratio

	for (int i = 0; i < 100; i++){
		float angle = i * 0.1;
		float radius = i * phi * 2;
		Vec2 pos = Vec2(
			center.x + cos(angle) * radius,
			center.y + sin(angle) * radius
		);

		if (pos.x > 0 && pos.x < 1800 && pos.y > 0 && pos.y < 1800){
			int colorIdx = (i / 10) % 4;
			Color spiralColor = palette[colorIdx + 1];
			spiralColor.a = 30; // very transparent
			drawRect(Rect(pos.x - 2, pos.y - 2, 4, 4), spiralColor);
		}
	}
}

void drawGoldenGrid(){
	float phi = 1.618033988749; // golden ratio
	int spacing = cast(int)(50 * phi);

	// Vertical lines
	for (int x = 0; x < 2000; x += spacing){
		Color gridColor = palette[2];
		gridColor.a = 15; // very transparent
		drawRect(Rect(x, 0, 1, 2000), gridColor);
	}

	// Horizontal lines
	for (int y = 0; y < 2000; y += spacing){
		Color gridColor = palette[2];
		gridColor.a = 15; // very transparent
		drawRect(Rect(0, y, 2000, 1), gridColor);
	}
}

void drawSineWavePattern(){
	import std.math : PI, sin;

	for (int x = 0; x < 2000; x += 10){
		float wave1 = sin(x * 0.01) * 50 + 200;
		float wave2 = sin(x * 0.007 + PI / 3) * 30 + 400;
		float wave3 = sin(x * 0.013 + PI) * 40 + 600;

		Color waveColor1 = palette[8];
		waveColor1.a = 20;
		Color waveColor2 = palette[9];
		waveColor2.a = 20;
		Color waveColor3 = palette[10];
		waveColor3.a = 20;

		drawRect(Rect(x, wave1 - 1, 8, 2), waveColor1);
		drawRect(Rect(x, wave2 - 1, 8, 2), waveColor2);
		drawRect(Rect(x, wave3 - 1, 8, 2), waveColor3);
	}
}

// Positive modulo function - always returns 0 <= result < divisor
int mod(int dividend, int divisor){
	int result = dividend % divisor;
	return result < 0 ? result + divisor : result;
}

unittest{
	// Test mod function for range -100 to 100
	foreach (i; -100 .. 101){
		int result8 = mod(i, 8);
		int result16 = mod(i, 16);

		// Ensure result is always positive and within bounds
		assert(result8 >= 0 && result8 < 8, "mod(8) out of bounds");
		assert(result16 >= 0 && result16 < 16, "mod(16) out of bounds");

		// Test specific known values
		if (i == -1){
			assert(result8 == 7, "mod(-1, 8) should be 7");
			assert(result16 == 15, "mod(-1, 16) should be 15");
		}
		if (i == -8){
			assert(result8 == 0, "mod(-8, 8) should be 0");
		}
		if (i == -16){
			assert(result16 == 0, "mod(-16, 16) should be 0");
		}
		if (i == 0){
			assert(result8 == 0, "mod(0, 8) should be 0");
			assert(result16 == 0, "mod(0, 16) should be 0");
		}
	}
}

Color getMathBackgroundColor(int x, int y, int colorindex){
	// Use prime number pattern for background selection
	int[] primes = [2, 3, 5, 7, 11, 13, 17, 19];
	int hash = (x * primes[mod(colorindex, 8)] + y * primes[mod(colorindex + 1, 8)]) % 256;

	// Map hash to background colors (darker palette entries)
	int bgIndex = mod(hash, 4) + 1; // use base01-base04
	Color bg = palette[bgIndex];

	// Add some mathematical noise based on position
	float noise = (mod(x ^ y, 100)) / 100.0;
	bg.a = cast(ubyte)(100 + noise * 50); // semi-transparent with variation

	return bg;
}