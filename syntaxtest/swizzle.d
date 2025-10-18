#!opend -main -unittest -run app.d
import joka.math;
import std;
auto swizzleargs(string form){
	string o;
	char which;
	int i;
	char c()=>form[i];
	while(i<form.length){
		which='0';
		if(c>='0'&&c<='9'){
			which=c;//cast(int)(c-'0');
			i++;
		}
		o~="args["~which~"]";
		if(c!='_'){
			o~="."~c;
		}
		o~=",";
		i++;
	}
	return o;
}
unittest{
	swizzleargs("xyxy").writeln;
	swizzleargs("xy1x1y").writeln;
	swizzleargs("r1rb1bg1g").writeln;
	swizzleargs("_1_2x2y").writeln;
}

S swizzle(string form,S,T...)(T args)=>mixin("S("~swizzleargs(form)~")");
unittest{
	alias a=swizzle!("xy1x1y",Rect,Vec2,Vec2);
	alias b=swizzle!("_1_2x2y",Rect,float,float,Vec2);
	
	assert(a(Vec2(1,2),Vec2(3,4))==Rect(1,2,3,4));
}