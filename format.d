//TODO: EVERYTHING
struct todolist{
	string title;
	string[] items;
	bool[] crossed;
	void sanitize(){
		if(crossed.length<items.length){
			crossed.length=items.length;
		}
	}
}
todolist[][] openkantban(string where){
	return [
		[todolist("buy",["milk","eggs"]),todolist("watch",["anime","factorio speedruns"])],
		[todolist("idk",["foo","bar"])],
	];
}
void savekantban(todolist[][] data,string where){
}
