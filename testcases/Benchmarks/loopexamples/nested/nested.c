int main() {
	int i = 0;
	int j = 0;
	int sum = 0;
	_Pragma( "loopbound min 10 max 10" )
	for (; i < 10; ++i)
	  _Pragma( "loopbound min 12 max 12" )
		for (j = 0; j < 12; ++j) {
			sum = i + j;
		}
	return sum;
}
