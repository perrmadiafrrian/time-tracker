# Simple cross-platform Makefile for building and installing the Flutter app

# Detect OS (macOS/Linux/Windows via uname; Windows in Git Bash/MSYS shows MINGW)
UNAME_S := $(shell uname -s)

APP_NAME := time_tracker
PROJECT_ROOT ?= $(CURDIR)

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
	@echo "Built macOS app under build/macos/Build/Products/Release"

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
.PHONY: install install-unsigned install-macos install-macos-unsigned install-windows install-linux

install:
	@if [ "$(UNAME_S)" = "Darwin" ]; then \
		$(MAKE) install-macos-unsigned; \
	elif echo "$(UNAME_S)" | grep -qiE "mingw|msys|cygwin"; then \
		$(MAKE) install-windows; \
	else \
		$(MAKE) install-linux; \
	fi

# Unsigned install dispatcher (macOS only for now)
install-unsigned:
	@if [ "$(UNAME_S)" = "Darwin" ]; then \
		$(MAKE) install-macos-unsigned; \
	else \
		echo "install-unsigned is only applicable on macOS"; \
	fi

# macOS: copy .app to ~/Applications (create dir if missing)

install-macos: build-macos
	ROOT="$(PROJECT_ROOT)"; [ -n "$$ROOT" ] || ROOT="$(PWD)"; \
	APP_SRC=""; \
	for D in "$$ROOT/build/macos/Build/Products/Release" "$$ROOT/macos/Build/Products/Release"; do \
	  if [ -d "$$D" ]; then \
	    APP_SRC="$$(/usr/bin/find "$$D" -type d -name "*.app" -print -quit 2>/dev/null)"; \
	    [ -n "$$APP_SRC" ] && break; \
	  fi; \
	done; \
	if [ -z "$$APP_SRC" ]; then \
	  echo "No .app found under $$ROOT/build/macos/Build/Products/Release or $$ROOT/macos/Build/Products/Release"; exit 1; \
	fi; \
	APP_BUNDLE_NAME="$$(basename \"$$APP_SRC\")"; \
	APP_DST="$$HOME/Applications/$$APP_BUNDLE_NAME"; \
	mkdir -p "$$HOME/Applications"; \
	rm -rf "$$APP_DST"; \
	cp -R "$$APP_SRC" "$$APP_DST"; \
	codesign --force --deep --sign - "$$APP_DST" >/dev/null 2>&1 || true; \
	zip -qry "$$APP_DST" >/dev/null 2>&1 || true; \
	echo "Installed to $$APP_DST"

# macOS: copy .app without codesigning

install-macos-unsigned: build-macos
	@set -e; \
	ROOT="$(PROJECT_ROOT)"; [ -n "$$ROOT" ] || ROOT="$(PWD)"; \
	APP_SRC=""; \
	for D in "$$ROOT/build/macos/Build/Products/Release" "$$ROOT/macos/Build/Products/Release"; do \
	  if [ -d "$$D" ]; then \
	    APP_SRC="$$(/usr/bin/find "$$D" -type d -name "*.app" -print -quit 2>/dev/null)"; \
	    [ -n "$$APP_SRC" ] && break; \
	  fi; \
	done; \
	if [ -z "$$APP_SRC" ]; then \
	  echo "No .app found under $$ROOT/build/macos/Build/Products/Release or $$ROOT/macos/Build/Products/Release"; exit 1; \
	fi; \
	APP_BUNDLE_NAME="$$(basename "$$APP_SRC")"; \
	APP_DST="$$HOME/Applications/$$APP_BUNDLE_NAME"; \
	mkdir -p "$$HOME/Applications"; \
	rm -rf "$$APP_DST"; \
	cp -R "$$APP_SRC" "$$APP_DST"; \
	echo "Installed unsigned to $$APP_DST"

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


