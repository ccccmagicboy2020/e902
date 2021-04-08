/*============================================================================
 * Name        : main.c
 * Author      : WangYang
 * Description : Application entry
 *============================================================================
 */
#include "sf.h"

#define SF_DATA_BUF		(SRAM_START + SRAM_SIZE)
#define SF_BUF_SIZE		(0x800)

#define SF_READ			0x01
#define SF_ERASE		0x02
#define SF_PROG			0x03

typedef volatile struct Params {
	uint32_t id;
	uint32_t size;
	int error;
	uint32_t ret_sn;
	uint32_t cmd_sn;
	uint32_t command;
	uint32_t offset;
	uint32_t length;
} PARAMS_t;


//void __bkpt_label();
int main() {
	
	PARAMS_t* params = (PARAMS_t*)(SF_DATA_BUF - sizeof(PARAMS_t));
	params->id = sf_id;
	params->size = sf_size;
	params->error = -1;
	while (1) {
		uint32_t sn;

		if (!params->command || params->command > SF_ERASE)
			continue;
		if (params->ret_sn == params->cmd_sn)
			continue;

		sn = params->cmd_sn;
		switch (params->command) {
		case SF_READ:
			params->error = sf_read((uint8_t *)SF_DATA_BUF, params->offset, params->length);
		break;
		case SF_ERASE:
			if (!params->offset && !params->length)
				params->error = sf_chip_erase();
			else
				params->error = sf_block_erase(params->offset);
		break;
		case SF_PROG:
			if ((params->offset & (SF_BLOCK_SIZE-1)) == 0)
				params->error = sf_read((uint8_t *)SF_DATA_BUF, params->offset, params->length);
			else
				params->error = 0;
			if (!params->error)
				params->error = sf_write(params->offset, (const uint8_t *)SF_DATA_BUF, params->length);
#ifdef SF_VERIFY
			if (!params->error)
				params->error = sf_verify(params->offset, (const uint8_t *)SF_DATA_BUF, params->length);
#endif // SF_VERIFY
		break;
		}
		params->ret_sn = sn;
	}
	return 0;
}
