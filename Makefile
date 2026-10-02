FLUTTER := $(shell command -v fvm >/dev/null 2>&1 && echo "fvm flutter" || echo "flutter")
DART    := $(shell command -v fvm >/dev/null 2>&1 && echo "fvm dart" || echo "dart")

.PHONY: get gen watch clean-gen analyze test run-dev run-staging run-prod build-staging build-prod

get:
	$(FLUTTER) pub get

## Codegen (freezed + json_serializable)
gen:
	$(DART) run build_runner build

watch:
	$(DART) run build_runner watch

clean-gen:
	$(DART) run build_runner clean

## Quality
analyze:
	$(FLUTTER) analyze

test:
	$(FLUTTER) test

## Run
run-dev:
	./tool/run.sh dev

run-staging:
	./tool/run.sh staging

run-prod:
	./tool/run.sh prod

## Build
build-staging:
	./tool/build.sh staging apk

build-prod:
	./tool/build.sh prod appbundle
