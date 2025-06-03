VERSION?=2025052301
SHA256?=0214eae2934ebe0820a6f051df2f8ae57e45dfc6be70a4bb22f5b22134b4b065
DOCKER_HUB_NAME?='harbor.svc.vitrifi.io/vitrifi/platform/tac_plus-ng'

.PHONY: ubuntu tag

all: ubuntu

ubuntu:
	docker build -t tac_plus-ng:ubuntu \
		--build-arg SRC_VERSION=$(VERSION) \
		--build-arg SRC_HASH=$(SHA256) \
		-f Dockerfile .

tag:
	docker tag tac_plus-ng:ubuntu $(DOCKER_HUB_NAME):latest
	docker tag tac_plus-ng:ubuntu $(DOCKER_HUB_NAME):ubuntu
	docker tag tac_plus-ng:ubuntu $(DOCKER_HUB_NAME):ubuntu-$(VERSION)
