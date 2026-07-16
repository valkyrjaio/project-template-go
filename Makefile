# Root task runner for the Valkyrja Go template — the analog of PHP's
# composer.json, TypeScript's package.json, and Java's Gradle scripts. Drive
# every CI tool through these targets; check here first for exact target names.
#
# golangci-lint is pinned in .github/ci/lint/go.mod (an isolated tool module) and
# run via `go tool` so its version never mixes with the framework's own deps.
GOLANGCI_LINT ?= go tool -modfile=.github/ci/lint/go.mod golangci-lint

.DEFAULT_GOAL := ci

.PHONY: ci
ci: tidy-check fmt-check lint test ## Run the full CI gate

.PHONY: build
build: ## Compile every package
	go build ./...

.PHONY: test
test: ## Run tests with the race detector
	go test -race ./...

.PHONY: coverage
coverage: ## Run tests with coverage (line; branch gaps reviewed in code review)
	go test -race -covermode=atomic -coverprofile=coverage.out ./...
	go tool cover -func=coverage.out

.PHONY: fmt
fmt: ## Format the codebase
	$(GOLANGCI_LINT) fmt

.PHONY: fmt-check
fmt-check: ## Fail if the codebase is not formatted
	$(GOLANGCI_LINT) fmt --diff

.PHONY: lint
lint: ## Run golangci-lint (static analysis, security, architecture, dead code)
	$(GOLANGCI_LINT) run

.PHONY: tidy
tidy: ## Tidy module dependencies
	go mod tidy

.PHONY: tidy-check
tidy-check: ## Fail if go.mod / go.sum are not tidy
	go mod tidy -diff

.PHONY: verify
verify: ## Verify dependencies against go.sum
	go mod verify

.PHONY: tools
tools: ## Download the pinned CI tool dependencies
	cd .github/ci/lint && go mod download

.PHONY: outdated
outdated: ## List direct dependencies with newer versions available
	go list -u -m -f '{{if and .Update (not .Indirect)}}{{.Path}}: {{.Version}} -> {{.Update.Version}}{{end}}' all

.PHONY: update
update: ## Update all dependencies to latest and tidy
	go get -u ./...
	go mod tidy

.PHONY: help
help: ## List available targets
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'
