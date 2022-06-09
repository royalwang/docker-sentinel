#!/usr/bin/make
SHELL=/bin/bash
IMAGE = royalwang/sentinel-dashboard
TAG = 1.8.4

.DEFAULT_GOAL := help
.PHONY: help

help: ## Show this help
	@printf "\033[33m%s:\033[0m\n" 'Available commands'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[32m%-14s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Docker image build
	docker build -t ${IMAGE}:${TAG} -f Dockerfile ../

push: ## Docker image push
	docker push ${IMAGE}:${TAG}
