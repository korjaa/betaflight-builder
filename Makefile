# Disable built-in rules and variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

CONTAINER_NAME = betaflight-builder

.PHONY: default
default: f411

betaflight:
	git clone "https://github.com/betaflight/betaflight.git" "$@"

betaflight/src/config: betaflight
	git clone "git@github.com:korjaa/betaflight-config.git" "$@"

.PHONY: .built build
.built build: Dockerfile betaflight/mk/tools.mk | betaflight/src/config
	docker build --tag ${CONTAINER_NAME} .
	touch .built

clean: | betaflight/obj
	rm -rf betaflight/obj

f411: .built
	docker run -it --rm \
		--user $(shell id -u) \
		--volume ${CURDIR}/betaflight:/mnt/data/betaflight \
		--volume ${CURDIR}/unified-targets:/mnt/data/unified-targets \
		${CONTAINER_NAME} \
		make \
			CONFIG=MAMBAF411 \
			EXTRA_FLAGS="\
				-DUSE_LEDS"

			#TARGET=STM32F411 \
