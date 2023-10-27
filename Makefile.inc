.PHONY: test build release

ifndef SERVICE_NAME
    $(error SERVICE_NAME is not set)
endif

ifndef VERSION
    $(error VERSION is not set)
endif

# Make sure there are no spaces.
SERVICE_NAME := $(SERVICE_NAME: =_)

test:
    ./test.sh

build:
    docker build -t $(SERVICE_NAME) .

release:
    docker tag $(SERVICE_NAME) $(SERVICE_NAME):$(VERSION)