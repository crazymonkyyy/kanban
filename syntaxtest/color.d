#!opend -unittest -main -run app.d
import parin;
import std;
enum string foo="Solarized-Dark";
enum data=import("color.csv");
Palette!N csvRowToPalette(Sz N)(IStr csv, Sz row = 0, Sz startCol = 0) {
    Palette!N result = void;

    auto line = csv.skipLine();
    if (row > 0) { row -= 1; line = csv.skipLine(); }
    auto fields = line.split(',');
    if (startCol >= fields.length) { result[0] = blank; return result; }
    fields = fields[startCol .. $];
    if (fields.length != N) { result[0] = blank; return result; }

    foreach (i, field; fields) {
        auto value = field.hexToRgba();
        if (value == blank) { result[0] = blank; return result; }
        result[i] = value;
    }
    return result;
}
int tocolorschemerow(string s_){
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
	"solarized dark".tocolorschemerow.writeln;
	"Solarized-dArk".tocolorschemerow.writeln;
	"atelier-plateau".tocolorschemerow.writeln;
	"solarized".tocolorschemerow.writeln;
	"solarized-li".tocolorschemerow.writeln;
	"black-metal".tocolorschemerow.writeln;
	stdout.flush;
}
Palette!16 palette;
void ready(){
	palette=data.csvRowToPalette(foo.tocolorschemerow,1);
}
bool update(float dt){
	foreach(i,c;palette){
		Rect(0,i*100,100,100).drawRect(c);
	}
	return false;
}
void finish(){}
mixin runGame!(ready, update, finish);
