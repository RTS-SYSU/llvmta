// Mit -O2 kompilieren
int f(int i, int j, int a) {
	_Pragma("loopbound min 1 max 1")
	do {
		_Pragma("loopbound min 1 max 50")
		do {
			j ++;
			if (j > 100)
				goto ende;
		} while (i < 50);
		++i;
	} while (i < 50);
ende:
	return i+j;
}

int main() { 
	f(5, 4, 2);
	return 0;
}

