// The `/v26` path suffix is required by Go's semantic import versioning: any
// major version >= 2 must be encoded in the module path. It tracks the annual
// major version (VERSION.md) and is bumped each major release.
module github.com/valkyrjaio/project-template-go/v26

go 1.26

toolchain go1.26.0
