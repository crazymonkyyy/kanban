// ##config strings
enum titlefontname="Noto Sans";
enum textfontname="Noto Sans";
enum textsize=18;
enum colorschemename="Solarized-Dark";
enum layout="Justified";
enum boxstyle="Rounded-30";
//---
import std;
// ##geometry 
static assert(boxstyle=="Rounded-30");
// ##layout code
static assert(layout=="Justified");
// ##colorcode
static assert(colorschemename=="Solarized-Dark");

// ##fontcode
enum fallbackfont="Noto Sans";
enum verbose=false;
//enum standardpath="~/.local/share/fonts/";
auto standardpath()=>expandTilde("~/.local/share/fonts/");
enum googleapi="https://fonts.googleapis.com/css?family=";
enum magicstring="src: url(";
string titlefontpath()=>findfont(titlefontname);
string textfontpath()=>findfont(textfontname);

string exe(string s)=>executeShell(s).output;
bool exists(ref string s){
	if(s.length>=2 && s[0..2]=="./"){s=getcwd~s[1..$];}
	if(s[0]=='~'){
		return std.file.exists(expandTilde(s));
	} else {
		return std.file.exists(s);
}}
string findfont(string font=""){
	if(font.length==0){font=fallbackfont;}
	if(font[0]=='~'||font[0]=='/'||font[0]=='.'){//if it looks like a file, user error if it fails
		exists(font);
		return font;
	}
	string file=standardpath~(font.filter!(not!(std.ascii.isWhite)).map!(a=>std.ascii.toLower(a))).to!string~".ttf";
	if(exists(file)){
		if(verbose){("found:"~file).writeln;}
		return file;
	}
	if(verbose){"file not found, attempting download".writeln;}
	string askgoogle=googleapi~font.queryformat;
	if(verbose){("trying:"~askgoogle).writeln;}
	bool found=false;
	foreach(s;exe("curl "~askgoogle).splitter('\n')){
		while( ! s.empty && std.ascii.isWhite(s[0])){s=s[1..$];}//remove whitespace
		if(s.length >= magicstring.length && s[0..magicstring.length]==magicstring){
			if(verbose){ writeln("google says:",s);}
			s=s[magicstring.length..$];
			s=s[0..s.countUntil(')')];
			if(verbose){writeln("trimed as:",s);}
			if(verbose){writeln("attempting download to:",file);}
			exe("curl \""~s~"\" --output "~file~"").writeln;
			return file;
		}
	}
	static bool runonce=true;
	assert(runonce, "ran twice meaning something is very wrong");
	runonce=false;
	return findfont(fallbackfont);
}
auto queryformat(string s)=>
		s.splitter(' ')
		.filter!(a=>a.length>0)
		.map!(a=>[std.ascii.toUpper(a[0])]~a[1..$].map!(std.ascii.toLower).to!string)
		.joiner("+")
		.to!string;
unittest{
	assert("fOo BAR foobar".queryformat=="Foo+Bar+Foobar");
}
unittest{
	assert(findfont()=="~/.local/share/fonts/notosans.ttf");
	assert(exists("~/.local/share/fonts/notosans.ttf"));
}

