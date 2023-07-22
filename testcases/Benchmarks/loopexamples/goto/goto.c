int main() {
	int i = 0;
	int a = 9;
	_Pragma("loopbound min 0 max 100")
loop:
	if (i <= 10) goto poss1;
	--i;
	goto loop;
poss1:
	if (i > 8) goto end;
	++i;
	goto loop;
end:
	a = i;
	return 0;
}
