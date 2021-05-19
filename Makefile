NAME := $(or $(NAME),$(NAME),seleniarm)
CURRENT_DATE := $(shell date '+%Y%m%d')
BUILD_DATE := $(or $(BUILD_DATE),$(BUILD_DATE),$(CURRENT_DATE))
VERSION := $(or $(VERSION),$(VERSION),4.0.0-beta-2)
TAG_VERSION := $(VERSION)-$(BUILD_DATE)
NAMESPACE := $(or $(NAMESPACE),$(NAMESPACE),$(NAME))
AUTHORS := $(or $(AUTHORS),$(AUTHORS),rows)
PUSH_IMAGE := $(or $(PUSH_IMAGE),$(PUSH_IMAGE),false)
DEFAULT_BUILD_ARGS := --platform linux/amd64,linux/arm64
BUILD_ARGS := $(or $(BUILD_ARGS),$(BUILD_ARGS),$(DEFAULT_BUILD_ARGS))
MAJOR := $(word 1,$(subst ., ,$(TAG_VERSION)))
MINOR := $(word 2,$(subst ., ,$(TAG_VERSION)))
MAJOR_MINOR_PATCH := $(word 1,$(subst -, ,$(TAG_VERSION)))
FFMPEG_TAG_VERSION := $(or $(FFMPEG_TAG_VERSION),$(FFMPEG_TAG_VERSION),ffmpeg-4.3.1)

all: hub \
	distributor \
	router \
	sessions \
	sessionqueuer \
	event_bus \
	chromium \
	firefox \
	standalone_chromium \
	standalone_firefox

generate_all:	\
	generate_hub \
	generate_distributor \
	generate_router \
	generate_sessions \
	generate_sessionqueuer \
	generate_event_bus \
	generate_node_base \
	generate_chromium \
	generate_firefox \
	generate_standalone_firefox \
	generate_standalone_chromium

build: all

ci: build test

base:
	cd ./Base && docker buildx build --push $(BUILD_ARGS) -t $(NAME)/base:$(TAG_VERSION) .

generate_hub:
	cd ./Hub && ./generate.sh $(TAG_VERSION) $(NAMESPACE) $(AUTHORS)

hub: base generate_hub
	cd ./Hub && docker buildx build --push $(BUILD_ARGS) -t $(NAME)/hub:$(TAG_VERSION) .

generate_distributor:
	cd ./Distributor && ./generate.sh $(TAG_VERSION) $(NAMESPACE) $(AUTHORS)

distributor: base generate_distributor
	cd ./Distributor && docker buildx build --push $(BUILD_ARGS) -t $(NAME)/distributor:$(TAG_VERSION) .

generate_router:
	cd ./Router && ./generate.sh $(TAG_VERSION) $(NAMESPACE) $(AUTHORS)

router: base generate_router
	cd ./Router && docker buildx build --push $(BUILD_ARGS) -t $(NAME)/router:$(TAG_VERSION) .

generate_sessions:
	cd ./Sessions && ./generate.sh $(TAG_VERSION) $(NAMESPACE) $(AUTHORS)

sessions: base generate_sessions
	cd ./Sessions && docker buildx build --push $(BUILD_ARGS) -t $(NAME)/sessions:$(TAG_VERSION) .

generate_sessionqueuer:
	cd ./SessionQueuer && ./generate.sh $(TAG_VERSION) $(NAMESPACE) $(AUTHORS)

sessionqueuer: base generate_sessionqueuer
	cd ./SessionQueuer && docker buildx build --push $(BUILD_ARGS) -t $(NAME)/session-queuer:$(TAG_VERSION) .

generate_event_bus:
	cd ./EventBus && ./generate.sh $(TAG_VERSION) $(NAMESPACE) $(AUTHORS)

event_bus: base generate_event_bus
	cd ./EventBus && docker buildx build --push $(BUILD_ARGS) -t $(NAME)/event-bus:$(TAG_VERSION) .

generate_node_base:
	cd ./NodeBase && ./generate.sh $(TAG_VERSION) $(NAMESPACE) $(AUTHORS)

node_base: base generate_node_base
	cd ./NodeBase && docker buildx build --push $(BUILD_ARGS) -t $(NAME)/node-base:$(TAG_VERSION) .

generate_chromium:
	cd ./NodeChromium && ./generate.sh $(TAG_VERSION) $(NAMESPACE) $(AUTHORS)

chromium: node_base generate_chromium
	cd ./NodeChromium && docker buildx build --push $(BUILD_ARGS) -t $(NAME)/node-chromium:$(TAG_VERSION) .

generate_firefox:
	cd ./NodeFirefox && ./generate.sh $(TAG_VERSION) $(NAMESPACE) $(AUTHORS)

firefox: node_base generate_firefox
	cd ./NodeFirefox && docker buildx build --push $(BUILD_ARGS) -t $(NAME)/node-firefox:$(TAG_VERSION) .

generate_standalone_firefox:
	cd ./Standalone && ./generate.sh StandaloneFirefox node-firefox $(TAG_VERSION) $(NAMESPACE) $(AUTHORS)

standalone_firefox: firefox generate_standalone_firefox
	cd ./StandaloneFirefox && docker buildx build --push $(BUILD_ARGS) -t $(NAME)/standalone-firefox:$(TAG_VERSION) .

generate_standalone_chromium:
	cd ./Standalone && ./generate.sh StandaloneChromium node-chromium $(TAG_VERSION) $(NAMESPACE) $(AUTHORS)

standalone_chromium: chromium generate_standalone_chromium
	cd ./StandaloneChromium && docker buildx build --push $(BUILD_ARGS) -t $(NAME)/standalone-chromium:$(TAG_VERSION) .

tag_latest:
	docker tag $(NAME)/base:$(TAG_VERSION) $(NAME)/base:latest
	docker tag $(NAME)/hub:$(TAG_VERSION) $(NAME)/hub:latest
	docker tag $(NAME)/distributor:$(TAG_VERSION) $(NAME)/distributor:latest
	docker tag $(NAME)/router:$(TAG_VERSION) $(NAME)/router:latest
	docker tag $(NAME)/sessions:$(TAG_VERSION) $(NAME)/sessions:latest
	docker tag $(NAME)/session-queuer:$(TAG_VERSION) $(NAME)/session-queuer:latest
	docker tag $(NAME)/event-bus:$(TAG_VERSION) $(NAME)/event-bus:latest
	docker tag $(NAME)/node-base:$(TAG_VERSION) $(NAME)/node-base:latest
	docker tag $(NAME)/node-chromium:$(TAG_VERSION) $(NAME)/node-chromium:latest
	docker tag $(NAME)/node-firefox:$(TAG_VERSION) $(NAME)/node-firefox:latest
	docker tag $(NAME)/standalone-chromium:$(TAG_VERSION) $(NAME)/standalone-chromium:latest
	docker tag $(NAME)/standalone-firefox:$(TAG_VERSION) $(NAME)/standalone-firefox:latest

tag_major_minor:
	docker tag $(NAME)/base:$(TAG_VERSION) $(NAME)/base:$(MAJOR)
	docker tag $(NAME)/hub:$(TAG_VERSION) $(NAME)/hub:$(MAJOR)
	docker tag $(NAME)/distributor:$(TAG_VERSION) $(NAME)/distributor:$(MAJOR)
	docker tag $(NAME)/router:$(TAG_VERSION) $(NAME)/router:$(MAJOR)
	docker tag $(NAME)/sessions:$(TAG_VERSION) $(NAME)/sessions:$(MAJOR)
	docker tag $(NAME)/session-queuer:$(TAG_VERSION) $(NAME)/session-queuer:$(MAJOR)
	docker tag $(NAME)/event-bus:$(TAG_VERSION) $(NAME)/event-bus:$(MAJOR)
	docker tag $(NAME)/node-base:$(TAG_VERSION) $(NAME)/node-base:$(MAJOR)
	docker tag $(NAME)/node-chromium:$(TAG_VERSION) $(NAME)/node-chromium:$(MAJOR)
	docker tag $(NAME)/node-firefox:$(TAG_VERSION) $(NAME)/node-firefox:$(MAJOR)
	docker tag $(NAME)/standalone-chromium:$(TAG_VERSION) $(NAME)/standalone-chromium:$(MAJOR)
	docker tag $(NAME)/standalone-firefox:$(TAG_VERSION) $(NAME)/standalone-firefox:$(MAJOR)
	docker tag $(NAME)/base:$(TAG_VERSION) $(NAME)/base:$(MAJOR).$(MINOR)
	docker tag $(NAME)/hub:$(TAG_VERSION) $(NAME)/hub:$(MAJOR).$(MINOR)
	docker tag $(NAME)/distributor:$(TAG_VERSION) $(NAME)/distributor:$(MAJOR).$(MINOR)
	docker tag $(NAME)/router:$(TAG_VERSION) $(NAME)/router:$(MAJOR).$(MINOR)
	docker tag $(NAME)/sessions:$(TAG_VERSION) $(NAME)/sessions:$(MAJOR).$(MINOR)
	docker tag $(NAME)/session-queuer:$(TAG_VERSION) $(NAME)/session-queuer:$(MAJOR).$(MINOR)
	docker tag $(NAME)/event-bus:$(TAG_VERSION) $(NAME)/event-bus:$(MAJOR).$(MINOR)
	docker tag $(NAME)/node-base:$(TAG_VERSION) $(NAME)/node-base:$(MAJOR).$(MINOR)
	docker tag $(NAME)/node-chromium:$(TAG_VERSION) $(NAME)/node-chromium:$(MAJOR).$(MINOR)
	docker tag $(NAME)/node-firefox:$(TAG_VERSION) $(NAME)/node-firefox:$(MAJOR).$(MINOR)
	docker tag $(NAME)/standalone-chromium:$(TAG_VERSION) $(NAME)/standalone-chromium:$(MAJOR).$(MINOR)
	docker tag $(NAME)/standalone-firefox:$(TAG_VERSION) $(NAME)/standalone-firefox:$(MAJOR).$(MINOR)
	docker tag $(NAME)/base:$(TAG_VERSION) $(NAME)/base:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/hub:$(TAG_VERSION) $(NAME)/hub:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/distributor:$(TAG_VERSION) $(NAME)/distributor:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/router:$(TAG_VERSION) $(NAME)/router:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/sessions:$(TAG_VERSION) $(NAME)/sessions:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/session-queuer:$(TAG_VERSION) $(NAME)/session-queuer:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/event-bus:$(TAG_VERSION) $(NAME)/event-bus:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/node-base:$(TAG_VERSION) $(NAME)/node-base:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/node-chromium:$(TAG_VERSION) $(NAME)/node-chromium:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/node-firefox:$(TAG_VERSION) $(NAME)/node-firefox:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/standalone-chromium:$(TAG_VERSION) $(NAME)/standalone-chromium:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/standalone-firefox:$(TAG_VERSION) $(NAME)/standalone-firefox:$(MAJOR_MINOR_PATCH)

test: test_chromium \
 test_firefox \
 test_chromium_standalone \
 test_firefox_standalone


test_chromium:
	VERSION=$(TAG_VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeChromium

test_chromium_standalone:
	VERSION=$(TAG_VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneChromium

test_firefox:
	VERSION=$(TAG_VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeFirefox

test_firefox_standalone:
	VERSION=$(TAG_VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneFirefox

.PHONY: \
	all \
	base \
	build \
	ci \
	chromium \
	firefox \
	generate_all \
	generate_hub \
	generate_distributor \
	generate_router \
	generate_sessions \
	generate_sessionqueuer \
	generate_event_bus \
	generate_node_base \
	generate_chromium \
	generate_firefox \
	generate_standalone_chromium \
	generate_standalone_firefox \
	hub \
	distributor \
	router \
	sessions \
	sessionqueuer \
	event_bus \
	node_base \
	release \
	standalone_chromium \
	standalone_firefox \
	tag_latest \
	tag_and_push_browser_images \
	test
