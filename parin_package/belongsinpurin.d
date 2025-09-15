bool modifystring(ref string s){
	dchar c;
	bool b=false;
	if(Keyboard.backspace.isPressed){
		if(Keyboard.shift.isDown){
			s=[];
		}
		s=s[0..$?$-1:0];
		b=true;
	}
	loop:
	c=dequeuePressedRune;
	if(cast(int)c!=0){
		//c.writeln;
		if(cast(int)c>255){
			s~='?';
		} else {
			s~=cast(char)c;
		}
		b=true;
		goto loop;
	}
	return b;
}
