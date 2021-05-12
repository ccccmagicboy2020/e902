.PHONY: clean All Project_Title Project_Build

All: Project_Title Project_Build

Project_Title:
	@echo "----------Building project:[ uart1_tx - BuildSet ]----------"

Project_Build:
	@make -r -f uart1_tx.mk -j 8 -C  ./ 


clean:
	@echo "----------Cleaning project:[ uart1_tx - BuildSet ]----------"

