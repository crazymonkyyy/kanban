#!/bin/env -S opend -run app.d
import parin;
import googlefont;
import std;
enum text="lazy fox; and something:\n idk quick dog,sadfjkbnlkvbg";
//enum text="𒀀 𒈾 𒂍 𒀀 𒈾 𒍢 𒅕 𒆠 𒉈 𒈠 𒌝 𒈠 𒈾 𒀭 𒉌 𒈠 𒀀 𒉡 𒌑 𒈠 𒋫 𒀠 𒇷 𒆪 𒆠 𒀀 𒄠 𒋫 𒀝 𒁉 𒄠";
enum int[] codepoints=text.map!(a=>cast(int)a).filter!(a=>a>255).array.sort.array;
//rl.Font font;
FontId font;
void ready(){
	setIsUsingAssetsPath(false);
	//font=rl.LoadFontEx(findfont("Noto Sans cuneiFoRm").toStringz,32,&codepoints[0],codepoints.length);
	//findfont("Righteous").writeln;
	//font=rl.LoadFont(findfont("Righteous").toStringz);
	//font=rl.LoadFontEx("/home/monkyyy/.local/share/fonts/notosanscuneiform.ttf".toStringz,32,null,0);
	//font=rl.LoadFontEx("/home/monkyyy/.local/share/fonts/notosanscuneiform.ttf".toStringz,32,&codepoints[0],codepoints.length);
	//assert(rl.isFontValid(font));
	//font=loadFont(findfont("Righteous"),32);
	//font=loadFont("/home/monkyyy/.local/share/fonts/notosans.ttf",32);
	//findfont("Bungee Spice").writeln;
	font=loadFont(findfont("Bungee Spice"),64);
	assert(font.isValid);
}
bool update(float dt){
	//rl.DrawTextEx(font,text,rl.Vector2(10,10),32,16,rl.WHITE);
	drawText(font,text,Vec2(10,10));
	return false;
}
void finish(){}
mixin runGame!(ready, update, finish);
