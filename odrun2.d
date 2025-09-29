import std.file;
import std.datetime;
import arsd.core;
enum PATH=__FILE_FULL_PATH__[0..$-__FILE__.length];
bool maxwatch(T,S)(ref T a,T b,S c){//todo revist the concept, I think theres more here
	if(a+c>=b){return false;}
	a=b;
	return true;
}
/*unittest{
	int i=3;
	assert(i.maxwatch(5));
	assert(i==5);
}*/
bool filemodified(string s)(){
	static SysTime store;
	return store.maxwatch(s.timeLastModified);
}
/*void main(){
	int i;
	while(i++<10){
		if(filemodified!("foo.d")){"bye".writeln;}
		"hi".writeln;
		import core.thread;
		Thread.sleep(1.seconds);
	}
}*/
void watchfile(Duration iolimit=dur!"msecs"(500),F)(string file, F func){
	
	auto w = new DirectoryWatcher(FilePath("."),file,false,(path, op) {
		static SysTime io;
		if(path.path==file && maxwatch(io,(path.path).timeLastModified,iolimit)){
			func();
	}});
	getThisThreadEventLoop().run(() => killme);
}
__gshared killme=false;
import std.process;
void exe(string s)=>executeShell(s).output.writeln;
void main(string[] s){
	watchfile(s[1],()=>exe("opend -run "~s[1]));
}
