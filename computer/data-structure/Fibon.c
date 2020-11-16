
#include <stdio.h>
int  a=0;
int Fibon1(int n)
{
	printf("\nAn%d=%d  ",a, n);
	if (n == 1 || n == 2)
	{
		printf("Bn%d=%d  ",a, n);
		return 1;
	}
	else
	{
		printf("Cn%d=%d  ",a, n);
		a++;
		return Fibon1(n - 1) + Fibon1(n - 2);
	}
}
int main()
{
	int n = 0;
	int ret = 0;
	scanf("%d", &n);
	ret = Fibon1(n);
	printf("ret=%d", ret);
	return 0;
}
