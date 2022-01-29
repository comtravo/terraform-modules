#!make

TERRAFORM_VERSION = 1.1.4
DOCKER_BASE_IMAGE = comtravo/terraform:py3-$(TERRAFORM_VERSION)-1.0.0
DOCKER_WORKHORSE_IMAGE = comtravo/terraform:test-workhorse-$(TERRAFORM_VERSION)-1.0.0

build:
	@docker build -f Dockerfile --build-arg TERRAFORM_VERSION=$(TERRAFORM_VERSION) --target base -t $(DOCKER_BASE_IMAGE) .
	@docker build -f Dockerfile --build-arg TERRAFORM_VERSION=$(TERRAFORM_VERSION) --target workhorse -t $(DOCKER_WORKHORSE_IMAGE) .

push:
	@docker push $(DOCKER_BASE_IMAGE)
	@docker push $(DOCKER_WORKHORSE_IMAGE)
