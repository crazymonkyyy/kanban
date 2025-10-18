#!opend -unittest -main -run app.d
import parin;
import std;
enum string foo="black-metal";
enum data=import("color.csv");

int tocolorschemerow(string s_){
	import std;
	auto target=s_.map!((a){
		import std.ascii;
		if(a==' ')return '-';
		return a.toLower;
	}).to!string;
	foreach(i,s;data.splitter('\n').enumerate){
		if(s[0..target.length]==target){return cast(int)i;}
	}
	return 136;
}
unittest{
	import std;
	"solarized dark".tocolorschemerow.writeln;
	"Solarized-dArk".tocolorschemerow.writeln;
	"atelier-plateau".tocolorschemerow.writeln;
	"solarized".tocolorschemerow.writeln;
	"solarized-li".tocolorschemerow.writeln;
	"black-metal".tocolorschemerow.writeln;
	stdout.flush;
}
unittest{
	
	"dc322f".toRgba.writeln;
}
Palette!16 palette;
void ready(){
	palette=data.csvRowToPalette!16(foo.tocolorschemerow,1);
	palette[8].writeln;
}
bool update(float dt){
	foreach(i,c;palette){
		Rect(0,i*100,100,100).drawRect(c);
		import std;
		drawText(c.to!string,Vec2(100,i*100));
	}
	return false;
}
void finish(){}
mixin runGame!(ready, update, finish);