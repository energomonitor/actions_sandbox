.PHONY: test build release validate

ifndef SERVICE_NAME
    $(error SERVICE_NAME is not set)
endif

# Make sure there are no spaces.
SERVICE_NAME := $(SERVICE_NAME: =_)

PRERELEASE ?= false

new_version_file := /tmp/newtag.txt

new_tag:
	@echo "Pulling current tags."
	@if [ -n "$$GITHUB_OUTPUT" ]; then \
		echo "Pull is made by github"; \
		else \
		git pull --ff-only --tags; \
		fi
	@LATEST=`git describe --tags --always --abbrev=0 --match "a/v*" $$(git rev-list --tags --max-count=1) | sed 's/$(SERVICE_NAME)\///'`; \
	echo "Latest tag: $$LATEST"; \
	NEWPRE="v$$(date +'%Y').$$(date +'%m')"; \
	if case $$LATEST in $$NEWPRE*) ;; *) false;; esac ; then \
		echo "Incrementing patch version."; \
		new_version="$${LATEST%.*}.$$(( $${LATEST##*.} + 1 ))"; \
	else \
		new_version="$$NEWPRE.0"; \
	fi; \
	if [ "$(PRERELEASE)" = "true" ]; then \
		new_version="$$new_version-pre-release"; \
	fi; \
	echo "$$new_version" > $(new_version_file); \
	NEWTAG=$(SERVICE_NAME)/$$new_version; \
	echo "Next tag: $$NEWTAG"; \
	if [ "$$GITHUB_OUTPUT" != "" ]; then \
		echo "service_name=$(SERVICE_NAME)" >> "$$GITHUB_OUTPUT"; \
		echo "current_tag=$$LATEST" >> "$$GITHUB_OUTPUT"; \
		echo "next_tag=$$NEWTAG" >> "$$GITHUB_OUTPUT"; \
	fi

test:
	./test.sh

build:
	docker build -t $(SERVICE_NAME):latest .

release: new_tag
	@NEWTAG=$$(cat $(new_version_file)); \
	docker tag $(SERVICE_NAME):latest $(SERVICE_NAME):$$NEWTAG; \
	rm -f $(new_version_file)
