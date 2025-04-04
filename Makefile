TRUNK="${HOME}/.cache/trunk/launcher/trunk"

default: check

## Main Commands

build: fmt clean test build-all

clean: clean-bin tidy
	go clean -i -cache -testcache

## Supporting Commands

tidy:
	go mod tidy

fmt: tidy
	${TRUNK} fmt

fmt-all: tidy
	${TRUNK} fmt --all

check: fmt
	${TRUNK} check

check-all: fmt-all
	${TRUNK} check --all

test:
	go test ./lib/...

clean-bin:
	rm -f bin/*

update: upgrade
upgrade: tidy
	go get -u
	${TRUNK} upgrade

## Build sub-commands

build-all: build-win build-mac build-linux

build-linux:
	GOOS=linux GOARCH=amd64 go build -o "bin/ice-amd64-linux" ./main.go

build-mac:
	GOOS=darwin GOARCH=arm64 go build -o "bin/ice-arm64-macos" ./main.go

build-win:
	GOOS=windows GOARCH=amd64 go build -o "bin/ice-amd64-win.exe" ./main.go

## Git Hooks
pre-commit: clean check test
	git add go.mod go.sum
