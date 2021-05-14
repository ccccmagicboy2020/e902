.PHONY: clean All Project_Title Project_Build

All: Project_Title Project_Build

Project_Title:
	@echo "----------Building project:[ radar_adc_test - BuildSet ]----------"

Project_Build:
	@make -r -f radar_adc_test.mk -j 8 -C  ./ 


clean:
	@echo "----------Cleaning project:[ radar_adc_test - BuildSet ]----------"

