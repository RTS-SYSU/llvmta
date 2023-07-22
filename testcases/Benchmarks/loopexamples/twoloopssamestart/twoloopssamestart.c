int main() {
	int i = 0;	
start:
	_Pragma("loopbound min 0 max 100")
	if (i > 10)
		goto ende;
	if (i < 20) 
		goto loop1rest;
	else 
		goto loop2rest;
loop1rest:
	i++;
	goto start;
loop2rest:
	--i;
	goto start;
ende:
	return 0;
}
