#!make

fmt-tf:
	@docker run --rm -v $(PWD):/opt/ct -w /opt/ct comtravo/terraform:py3-0.13.7-1.0.0 terraform fmt -recursive

generate-docs: fmt-tf
	@docker run --rm -v $(PWD):/opt/ct -w /opt/ct/kinesis comtravo/terraform:py3-0.13.7-1.0.0 terraform-docs markdown . > ./kinesis/README.md
