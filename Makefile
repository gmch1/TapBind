SHELL := /bin/bash

all: archive export compress

## Development targets
.PHONY: run force-build clean-build

# Find all source files to track dependencies
SOURCES := $(shell find MiddleClick MoreTouch ConfigCore -type f \( -name "*.swift" -o -name "*.h" -o -name "*.m" \) 2>/dev/null)

# Stamp file to track last build
BUILD_STAMP := ./build/.build-stamp
DEBUG_DERIVED_DATA := $(CURDIR)/build/DerivedData
DEBUG_HOME := $(CURDIR)/build/home
DEBUG_XCODEBUILD := HOME="$(DEBUG_HOME)" xcodebuild -project MiddleClick.xcodeproj -scheme MiddleClick -configuration Debug -derivedDataPath "$(DEBUG_DERIVED_DATA)" CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY=

# Only build if sources changed since last build
$(BUILD_STAMP): $(SOURCES)
	@echo "🔨 Building TapBind (Debug)..."
	@mkdir -p "$(DEBUG_DERIVED_DATA)" "$(DEBUG_HOME)"
	@set -o pipefail; $(DEBUG_XCODEBUILD) build 2>&1 | grep -E "BUILD (SUCCEEDED|FAILED)|error:"
	@echo "✅ Build succeeded!"
	@mkdir -p $(dir $(BUILD_STAMP))
	@touch $(BUILD_STAMP)

build-debug: $(BUILD_STAMP)

run: $(BUILD_STAMP)
	@echo "🚀 Running TapBind..."
	@BUILD_SKIP=1 ./scripts/build-and-run.sh

force-build:
	@rm -f $(BUILD_STAMP)
	@$(MAKE) build-debug

clean-build:
	@rm -f $(BUILD_STAMP)
	@echo "🧹 Build stamp cleaned"

## Release targets
archive:
	xcodebuild -project MiddleClick.xcodeproj -scheme MiddleClick -configuration Release archive

export:
	xcodebuild -exportArchive \
		-archivePath "$(shell ls -td ~/Library/Developer/Xcode/Archives/*/TapBind*.xcarchive | head -1)" \
		-exportPath "$(shell pwd)/build" \
		-exportOptionsPlist ./build-config/ExportOptions.plist

compress:
	cd ./build && \
	rm -f ./TapBind.zip && \
	zip -r9 ./TapBind.zip ./TapBind.app

create-cert:
	security export -k ~/Library/Keychains/login.keychain-db -t identities -f pkcs12 | base64 | pbcopy
