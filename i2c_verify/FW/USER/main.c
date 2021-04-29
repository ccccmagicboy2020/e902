#include "stm32f10x.h"
#include "ADC_DMA.h"
#include "sys.h"
#include "delay.h"
#include "SEGGER_RTT.h"
#include "SEGGER_RTT_Conf.h"
#include "SEGGER_SYSVIEW.h"

/**************************I2C 参数定义，I2C1 或 I2C2*********************/

/* STM32 I2C 快速模式 */
//#define I2C_Speed 400000
#define I2C_Speed 200000

/* 这个地址只要与 STM32 外挂的 I2C 器件地址不一样即可 */
#define I2Cx_OWN_ADDRESS7 0x0A
#define SLAVE_ADDRESS			0x0C

/*通讯等待超时时间*/
#define I2CT_FLAG_TIMEOUT ((uint32_t)0x1000)
#define I2CT_LONG_TIMEOUT ((uint32_t)(10 * I2CT_FLAG_TIMEOUT))

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

void GPIO_Config_i2c_2()
{
		GPIO_InitTypeDef GPIO_InitStructure;

		/* 使能与 I2C 有关的时钟 */
		RCC_APB1PeriphClockCmd(RCC_APB1Periph_I2C2, ENABLE);
		RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);

		/* I2C_SCL、I2C_SDA*/
		GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_OD; // 开漏输出
		GPIO_Init(GPIOB, &GPIO_InitStructure);

		GPIO_InitStructure.GPIO_Pin = GPIO_Pin_11;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_OD; // 开漏输出
		GPIO_Init(GPIOB, &GPIO_InitStructure);
}

void GPIO_Config()
{   
    GPIO_InitTypeDef    GPIO_InitStruct;
		NVIC_InitTypeDef NVIC_InitStructure;
		EXTI_InitTypeDef EXTI_InitStructure;
    //开启时钟
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);  
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
		RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO, ENABLE);
		//
		GPIO_PinRemapConfig(GPIO_Remap_SWJ_JTAGDisable, ENABLE);
    //配置GPIO为推挽输出
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_0|GPIO_Pin_1|GPIO_Pin_2|GPIO_Pin_3|GPIO_Pin_4|GPIO_Pin_5|GPIO_Pin_6|GPIO_Pin_7|GPIO_Pin_8|GPIO_Pin_9|GPIO_Pin_10|GPIO_Pin_11;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStruct.GPIO_Speed =GPIO_Speed_50MHz;
    GPIO_Init(GPIOB,&GPIO_InitStruct) ;
	
	  GPIO_InitStruct.GPIO_Pin = GPIO_Pin_2|GPIO_Pin_3;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStruct.GPIO_Speed =GPIO_Speed_50MHz;
    GPIO_Init(GPIOA,&GPIO_InitStruct) ;
	
	  GPIO_InitStruct.GPIO_Pin = GPIO_Pin_1;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IPU;
		GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOA,&GPIO_InitStruct);
	
    GPIO_SetBits( GPIOB, GPIO_Pin_0);		//ADC bit0
	  GPIO_SetBits( GPIOB, GPIO_Pin_1);		//ADC bit1
	  GPIO_SetBits( GPIOB, GPIO_Pin_2);		//ADC bit2
	  GPIO_SetBits( GPIOB, GPIO_Pin_3);		//ADC bit3
	  GPIO_SetBits( GPIOB, GPIO_Pin_4);		//ADC bit4
	  GPIO_SetBits( GPIOB, GPIO_Pin_5);		//ADC bit5
	  GPIO_SetBits( GPIOB, GPIO_Pin_6);		//ADC bit6
	  GPIO_SetBits( GPIOB, GPIO_Pin_7);		//ADC bit7
	  GPIO_SetBits( GPIOB, GPIO_Pin_8);		//ADC bit8
	  GPIO_SetBits( GPIOB, GPIO_Pin_9);		//ADC bit9
		GPIO_SetBits( GPIOB, GPIO_Pin_10);	//ADC bit10
		GPIO_SetBits( GPIOB, GPIO_Pin_11);	//ADC bit11
		
	  GPIO_ResetBits( GPIOA, GPIO_Pin_2);		//sync output  PA2
		
	  GPIO_SetBits( GPIOA, GPIO_Pin_3);		//备用

		GPIO_EXTILineConfig(GPIO_PortSourceGPIOA,GPIO_PinSource1);//PA1
		EXTI_ClearITPendingBit(EXTI_Line1);
		EXTI_InitStructure.EXTI_Line= EXTI_Line1;
		EXTI_InitStructure.EXTI_Mode= EXTI_Mode_Interrupt; 
		EXTI_InitStructure.EXTI_Trigger= EXTI_Trigger_Rising;	//使用上升沿
		EXTI_InitStructure.EXTI_LineCmd=ENABLE;
		EXTI_Init(&EXTI_InitStructure);
		
		NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2);   //NVIC
		NVIC_InitStructure.NVIC_IRQChannel = EXTI1_IRQn;
		NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority= 2;
		NVIC_InitStructure.NVIC_IRQChannelSubPriority= 0;        
		NVIC_InitStructure.NVIC_IRQChannelCmd=ENABLE;   
		NVIC_Init(&NVIC_InitStructure);
}

void i2c1_initial(void)
{
	I2C_InitTypeDef I2C_InitStructure;
	
	/* I2C 配置 */
	I2C_InitStructure.I2C_Mode = I2C_Mode_I2C;
	
	/* 高电平数据稳定，低电平数据变化 SCL 时钟线的占空比 */
	I2C_InitStructure.I2C_DutyCycle = I2C_DutyCycle_2;
	
	I2C_InitStructure.I2C_OwnAddress1 =I2Cx_OWN_ADDRESS7;
	I2C_InitStructure.I2C_Ack = I2C_Ack_Enable ;
	
	/* I2C 的寻址模式 */
	I2C_InitStructure.I2C_AcknowledgedAddress = I2C_AcknowledgedAddress_7bit;
	
	/* 通信速率 */
	I2C_InitStructure.I2C_ClockSpeed = I2C_Speed;
	
	/* I2C 初始化 */
	I2C_Init(I2C1, &I2C_InitStructure);
	
	I2C_ITConfig(I2C1, I2C_IT_EVT | I2C_IT_BUF, ENABLE);
	/* 使能 I2C */
	I2C_Cmd(I2C1, ENABLE);
}

void i2c2_initial(void)
{
	I2C_InitTypeDef I2C_InitStructure;
	
	/* I2C 配置 */
	I2C_InitStructure.I2C_Mode = I2C_Mode_I2C;
	
	/* 高电平数据稳定，低电平数据变化 SCL 时钟线的占空比 */
	I2C_InitStructure.I2C_DutyCycle = I2C_DutyCycle_2;
	
	I2C_InitStructure.I2C_OwnAddress1 =I2Cx_OWN_ADDRESS7;
	I2C_InitStructure.I2C_Ack = I2C_Ack_Enable ;
	
	/* I2C 的寻址模式 */
	I2C_InitStructure.I2C_AcknowledgedAddress = I2C_AcknowledgedAddress_7bit;
	
	/* 通信速率 */
	I2C_InitStructure.I2C_ClockSpeed = I2C_Speed;
	
	/* I2C 初始化 */
	I2C_Init(I2C2, &I2C_InitStructure);
	
	I2C_ITConfig(I2C2, I2C_IT_EVT | I2C_IT_BUF, ENABLE);
	/* 使能 I2C */
	I2C_Cmd(I2C2, ENABLE);
}

void segger_init(void)
{
	//
	SEGGER_RTT_ConfigUpBuffer(1, "JScope_U2", &JS_RTT_UpBuffer[0], sizeof(JS_RTT_UpBuffer), SEGGER_RTT_MODE_NO_BLOCK_SKIP);
	
	SEGGER_RTT_Init();
	SEGGER_RTT_printf(0, "%sphosense radar chip: XBR820 I2C DEMO%s\r\n", RTT_CTRL_BG_BRIGHT_RED, RTT_CTRL_RESET);
}

static uint32_t I2C_TIMEOUT_UserCallback(uint8_t errorCode)
{
	SEGGER_RTT_printf(0, "i2c master timeout, errorcode = %d\r\n", errorCode);
	return 0;
}

int i2c1_send_byte(unsigned char val)
{	
	int timeout = 0;
	
	I2C_GenerateSTART(I2C1, ENABLE);
	
	/*设置超时等待时间*/
	timeout = I2CT_FLAG_TIMEOUT;
	
	while (!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_MODE_SELECT))
	{
		if ((timeout--) == 0) return I2C_TIMEOUT_UserCallback(0);
	}	
	
	/* 发送 EEPROM 设备地址 */
	I2C_Send7bitAddress(I2C1, SLAVE_ADDRESS, I2C_Direction_Transmitter);
	
	timeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV6 事件并清除标志*/
	while (!I2C_CheckEvent(I2C1,	I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED))
	{
		if ((timeout--) == 0) return I2C_TIMEOUT_UserCallback(1);
	}
	
	/* 发送一字节要写入的数据 */
	I2C_SendData(I2C1, val);
	
	timeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV8 事件并清除标志*/
	while (!I2C_CheckEvent(I2C1,	I2C_EVENT_MASTER_BYTE_TRANSMITTED))
	{
	if ((timeout--) == 0) return I2C_TIMEOUT_UserCallback(2);
	}
	
	/* 发送停止信号 */
	I2C_GenerateSTOP(I2C1, ENABLE);
	
	return 1;
}

int i2c2_send_byte(unsigned char val)
{	
	int timeout = 0;
	
	I2C_GenerateSTART(I2C2, ENABLE);
	
	/*设置超时等待时间*/
	timeout = I2CT_FLAG_TIMEOUT;
	
	while (!I2C_CheckEvent(I2C2, I2C_EVENT_MASTER_MODE_SELECT))
	{
		if ((timeout--) == 0) return I2C_TIMEOUT_UserCallback(3);
	}	
	
	/* 发送 EEPROM 设备地址 */
	I2C_Send7bitAddress(I2C2, SLAVE_ADDRESS, I2C_Direction_Transmitter);
	
	timeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV6 事件并清除标志*/
	while (!I2C_CheckEvent(I2C2,	I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED))
	{
		if ((timeout--) == 0) return I2C_TIMEOUT_UserCallback(4);
	}
	
	/* 发送一字节要写入的数据 */
	I2C_SendData(I2C2, val);
	
	timeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV6 事件并清除标志*/
	while (!I2C_CheckEvent(I2C2,	I2C_EVENT_MASTER_BYTE_TRANSMITTED))
	{
		if ((timeout--) == 0) return I2C_TIMEOUT_UserCallback(5);
	}
	
	/* 发送一字节要写入的数据 */
	I2C_SendData(I2C2, val + 2);
	
	timeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV8 事件并清除标志*/
	while (!I2C_CheckEvent(I2C2,	I2C_EVENT_MASTER_BYTE_TRANSMITTED))
	{
		if ((timeout--) == 0) return I2C_TIMEOUT_UserCallback(6);
	}
	
	/* 发送一字节要写入的数据 */
	I2C_SendData(I2C2, val + 4);
	
	timeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV8 事件并清除标志*/
	while (!I2C_CheckEvent(I2C2,	I2C_EVENT_MASTER_BYTE_TRANSMITTED))
	{
		if ((timeout--) == 0) return I2C_TIMEOUT_UserCallback(6);
	}	
	
	/* 发送一字节要写入的数据 */
	I2C_SendData(I2C2, val + 6);
	
	timeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV8 事件并清除标志*/
	while (!I2C_CheckEvent(I2C2,	I2C_EVENT_MASTER_BYTE_TRANSMITTED))
	{
		if ((timeout--) == 0) return I2C_TIMEOUT_UserCallback(6);
	}		
	
	/* 发送一字节要写入的数据 */
	I2C_SendData(I2C2, val + 8);
	
	timeout = I2CT_FLAG_TIMEOUT;
	/* 检测 EV8 事件并清除标志*/
	while (!I2C_CheckEvent(I2C2,	I2C_EVENT_MASTER_BYTE_TRANSMITTED))
	{
		if ((timeout--) == 0) return I2C_TIMEOUT_UserCallback(6);
	}		
	
	/* 发送停止信号 */
	I2C_GenerateSTOP(I2C2, ENABLE);
	
	return 1;
}

int main(void)
{
	unsigned int free_runner = 0;
	unsigned char c = 0;
	
	//GPIO_Config_i2c();
	GPIO_Config_i2c_2();
	//i2c1_initial();
	i2c2_initial();
	
	segger_init();
	delay_init();
	
  while (1)
  {
		free_runner++;
		//adc_value.Val1 = ADC_ConvertedValue;
		//SEGGER_RTT_Write(1, &adc_value, sizeof(adc_value));
		
		if (SEGGER_RTT_HasKey()) 
		{
			int c = SEGGER_RTT_GetKey();
			SEGGER_RTT_SetTerminal(0); 
			SEGGER_RTT_Write (0, &c, 1);
			SEGGER_RTT_printf(0,"\n");
		}		
		
		c = SEGGER_RTT_WaitKey();
		SEGGER_RTT_printf(0, "i2c master trigger: 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x\r\n", c, c+2, c+4, c+6, c+8);

		i2c2_send_byte(c);
		
		if (free_runner%300 == 0)
		{
			//
		}
  }
}


