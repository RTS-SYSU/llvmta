int add(int* x){
	return *x + 1;
}

int main(){
	int a1 = 1;
	add(&a1);
	return 0;
}
