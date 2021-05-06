.PHONY: clean All Project_Title Project_Build Project_PostBuild

All: Project_Title Project_Build Project_PostBuild

Project_Title:
	@echo "----------Building project:[ tirq_test - BuildSet ]----------"

Project_Build:
	@make -r -f tirq_test.mk -j 8 -C  ./ 

Project_PostBuild:
	@echo Executing Post Build commands ...
	@export CDKPath="D:/C-Sky/CDK" CDK_VERSION="V2.6.6" ProjectPath="D:/cccc2020/CODE/e902/src/tirq_test" && D:/cccc2020/CODE/e902/src/tirq_test/post_build.sh D:/cccc2020/CODE/e902/src/tirq_test/ tirq_test
	@echo Done


clean:
	@echo "----------Cleaning project:[ tirq_test - BuildSet ]----------"

