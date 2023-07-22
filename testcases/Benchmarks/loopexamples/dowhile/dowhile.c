int main() {
	int i = 0;
	int j = 0;
	_Pragma( "loopbound min 50 max 50" )
	do {
	  _Pragma( "loopbound min 50 max 50" )
		do {
			++i;
		} while (i < 50);
		j++;
	} while (j < 50);
	return 0;
}
