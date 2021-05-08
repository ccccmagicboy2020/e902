#include "stm32f10x.h"
#include "ADC_DMA.h"
#include "sys.h"
#include "delay.h"
#include "SEGGER_RTT.h"
#include "SEGGER_RTT_Conf.h"
#include "SEGGER_SYSVIEW.h"

/**************************I2C 参数定义，I2C1 或 I2C2*********************/

#define I2Cx_OWN_ADDRESS7 0x0A

/*通讯等待超时时间*/
#define I2CT_FLAG_TIMEOUT ((uint32_t)0x100000)
#define I2CT_LONG_TIMEOUT ((uint32_t)(10 * I2CT_FLAG_TIMEOUT))

void i2c1_initial(void);

typedef struct Val
{
	unsigned short Val1;		//radar if
} Val_t;

extern __IO uint16_t ADC_ConvertedValue;
char JS_RTT_UpBuffer[1024];
Val_t adc_value;

void GPIO_Config_i2c()
{
		GPIO_InitTypeDef GPIO_InitStructure;

		/* 使能与 I2C 有关的时钟 */
		RCC_APB1PeriphClockCmd(RCC_APB1Periph_I2C1, ENABLE);
		RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);

		/* I2C_SCL、I2C_SDA*/
		GPIO_InitStructure.GPIO_Pin = GPIO_Pin_6;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_OD; // 开漏输出
		GPIO_Init(GPIOB, &GPIO_InitStructure);

		GPIO_InitStructure.GPIO_Pin = GPIO_Pin_7;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_OD; // 开漏输出
		GPIO_Init(GPIOB, &GPIO_InitStructure);
}

void i2c1_initial(void)
{
	I2C_InitTypeDef I2C_InitStructure;
	
	I2C_DeInit(I2C1);
	/* I2C 配置 */
	I2C_InitStructure.I2C_Mode = I2C_Mode_I2C;
	
	/* 高电平数据稳定，低电平数据变化 SCL 时钟线的占空比 */
	//I2C_InitStructure.I2C_DutyCycle = I2C_DutyCycle_16_9;
	I2C_InitStructure.I2C_DutyCycle = I2C_DutyCycle_2;
	
	I2C_InitStructure.I2C_OwnAddress1 =I2Cx_OWN_ADDRESS7;
	I2C_InitStructure.I2C_Ack = I2C_Ack_Enable ;
	
	/* I2C 的寻址模式 */
	I2C_InitStructure.I2C_AcknowledgedAddress = I2C_AcknowledgedAddress_7bit;
	
	/* 通信速率 */
	I2C_InitStructure.I2C_ClockSpeed = 400000;
	
	/* I2C 初始化 */
	I2C_Init(I2C1, &I2C_InitStructure);
	
	I2C_ITConfig(I2C1, I2C_IT_ERR | I2C_IT_EVT | I2C_IT_BUF, ENABLE);
	/* 使能 I2C */
	I2C_Cmd(I2C1, ENABLE);
}

void NVIC_Configuration(void)
{
	/* 定义 NVIC 初始化结构体 NVIC_InitStructure */
	NVIC_InitTypeDef NVIC_InitStructure;
	
	/* 设置并使能 I2C2 中断 */  
	NVIC_InitStructure.NVIC_IRQChannel = I2C1_EV_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_Init(&NVIC_InitStructure);
	
	NVIC_InitStructure.NVIC_IRQChannel = I2C1_ER_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 1;	
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;	
	NVIC_Init(&NVIC_InitStructure);
}

void segger_init(void)
{
	//
	SEGGER_RTT_ConfigUpBuffer(1, "JScope_U2", &JS_RTT_UpBuffer[0], sizeof(JS_RTT_UpBuffer), SEGGER_RTT_MODE_NO_BLOCK_SKIP);
	
	SEGGER_RTT_Init();
	SEGGER_RTT_printf(0, "%sphosense radar chip: XBR820 I2C MASTER DEMO USE%s\r\n", RTT_CTRL_BG_BRIGHT_RED, RTT_CTRL_RESET);
}

int main(void)
{
	unsigned int free_runner = 0;
	
	NVIC_Configuration();
	GPIO_Config_i2c();
	i2c1_initial();
	
	segger_init();
	delay_init();
	
  while (1)
  {
		free_runner++;
		//adc_value.Val1 = ADC_ConvertedValue;
		//SEGGER_RTT_Write(1, &adc_value, sizeof(adc_value));	
		
		if (free_runner%300 == 0)
		{
			//
		}
  }
}


