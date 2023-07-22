int main() {
	int i = 0;
	_Pragma( "loopbound min 50 max 50" )
	while ( i < 50) 
		++i;
	return 0;
}
