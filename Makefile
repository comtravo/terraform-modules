#! make

fmt:
	@docker run --rm -v $(PWD):/opt/ct -w /opt/ct comtravo/terraform:py3-0.13.7-1.0.0 terraform fmt -recursive

lint:
	@docker run --rm -v $(PWD):/opt/ct -w /opt/ct comtravo/terraform:py3-0.13.7-1.0.0 terraform fmt -check=true -write=false -diff=true
	@docker run --rm -v $(PWD):/opt/ct -w /opt/ct comtravo/terraform:py3-0.13.7-1.0.0 tflint .

generate-docs:
	@@docker run --rm -v $(PWD):/opt/ct -w /opt/ct comtravo/terraform:py3-0.13.7-1.0.0 terraform-docs markdown . > README.md

all: lint generate-docs
