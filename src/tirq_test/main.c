
#include <xbr820.h>

extern void timer_init(unsigned char chan, unsigned int val);
extern volatile uint32_t tm_count;

void delay(unsigned int val)
{
	tm_count = 0;
	while(tm_count < val)
	{
		//
	}
}

int main() {
    __enable_excp_irq();

	timer_init(0, SYSTEM_CLOCK / 1000); // 1ms

	while(1)
	{
		delay(1000);
	}
	return 0;
}
