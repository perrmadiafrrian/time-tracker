# Simple cross-platform Makefile for building and installing the Flutter app

# Detect OS (macOS/Linux/Windows via uname; Windows in Git Bash/MSYS shows MINGW)
UNAME_S := $(shell uname -s)

APP_NAME := time_tracker
PROJECT_ROOT := $(abspath .)

# Default target
.PHONY: all
all: build

# --- Build targets ---
.PHONY: build build-macos build-windows build-linux build-ios build-android

build:
	@if [ "$(UNAME_S)" = "Darwin" ]; then \
		$(MAKE) build-macos; \
	elif echo "$(UNAME_S)" | grep -qiE "mingw|msys|cygwin"; then \
		$(MAKE) build-windows; \
	else \
		$(MAKE) build-linux; \
	fi

build-macos:
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs
	flutter build macos --release
	@echo "Built macOS app at macos/Build/Products/Release/$(APP_NAME).app"

build-windows:
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs
	flutter build windows --release
	@echo "Built Windows app under build/windows/runner/Release"

build-linux:
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs
	flutter build linux --release
	@echo "Built Linux app under build/linux/x64/release/bundle"

build-ios:
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs
	flutter build ios --release

build-android:
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs
	flutter build apk --release

# --- Install targets ---
.PHONY: install install-macos install-windows install-linux

install:
	@if [ "$(UNAME_S)" = "Darwin" ]; then \
		$(MAKE) install-macos; \
	elif echo "$(UNAME_S)" | grep -qiE "mingw|msys|cygwin"; then \
		$(MAKE) install-windows; \
	else \
		$(MAKE) install-linux; \
	fi

# macOS: copy .app to ~/Applications (create dir if missing)
install-macos: build-macos
	@APP_SRC="$(PROJECT_ROOT)/macos/Build/Products/Release/$(APP_NAME).app"; \
	APP_DST="$$HOME/Applications/$(APP_NAME).app"; \
	mkdir -p "$$HOME/Applications"; \
	rm -rf "$$APP_DST"; \
	cp -R "$$APP_SRC" "$$APP_DST"; \
	codesign --force --deep --sign - "$$APP_DST" >/dev/null 2>&1 || true; \
	zip -qry "$$APP_DST" >/dev/null 2>&1 || true; \
	echo "Installed to $$APP_DST"

# Windows/Linux: leave built artifacts in build directory; provide a stub
install-windows: build-windows
	@echo "On Windows, run the built EXE from build/windows/runner/Release"

install-linux: build-linux
	@echo "On Linux, copy build/linux/x64/release/bundle to a desired location"

# Clean helpers
.PHONY: clean flutter-clean
clean:
	rm -rf build

flutter-clean:
	flutter clean
	rm -rf .dart_tool


