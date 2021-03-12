#include "../../include/xbr820_reg.h"
#include <stdio.h>

int c = 0;

typedef struct {
    char name[8];
    int age;
    int birthYear;
} student;

int func_xxx(int data1, int data2)
{
    int temp = 100;

    return temp + data1 + data2;
}

int main() 
{
    int a = 4;
    int b = 12;
	int d = 100;
	int i = 0;
	
    c = a + b;
	
	for (i=0;i<100;i++)
	{
		//
		d += 1;
	}
	d = func_xxx(10, 56);
	//printf("this is hello at %d", c);
	
    return 0;
}
