#! make

DOCKER_COMPOSE=docker-compose -f ./docker-compose.yml
DOCKER_COMPOSE_DEVELOP=$(DOCKER_COMPOSE) -f ./docker-compose.develop.yml
GENERATE_DOCS_COMMAND:=terraform-docs markdown . > README.md

fmt:
	@terraform fmt -recursive
	@find . -name '*.go' | xargs gofmt -w -s

lint:
	@terraform fmt -check -recursive -diff=true
	@test -z $(shell find . -type f -name '*.go' | xargs gofmt -l)
	@tflint

build:
	@$(DOCKER_COMPOSE) build

test-integration:
	@cd test && go test $(TESTARGS)

test-all: test-integration

test-docker:
	@$(DOCKER_COMPOSE) run --rm terraform make lint
	@$(DOCKER_COMPOSE) run --rm -e TESTARGS='$(TESTARGS)' terraform make test-all
	@$(DOCKER_COMPOSE) down -v

develop:
	@$(DOCKER_COMPOSE_DEVELOP) run --rm terraform bash
	@$(DOCKER_COMPOSE_DEVELOP) down -v

generate-docs: fmt lint
	for module in `find . -type f -name "*.tf" -not -path "*/examples/*" -not -path "./test" -exec dirname "{}" \; | sort -u`; do cd ${module} && terraform-docs markdown . > README.md && cd -; done

clean-state:
	@find . -type f -name 'terraform.tfstate*' | xargs rm -rf
	@find . -type d -name '.terraform' | xargs rm -rf
	@find . -type d -name 'terraform.tfstate.d' | xargs rm -rf

clean-all: clean-state
	@$(DOCKER_COMPOSE) down -v

logs:
	@$(DOCKER_COMPOSE) logs -f

.PHONY: test
