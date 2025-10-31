# Unit Conversion Proof of Concept

A demonstration of using a shared library written in Zig across multiple programming languages (C, Elixir, Python, Go) for high-performance unit conversions.

## The Problem

Unit conversions are a common requirement in many applications, but they can be error-prone and time-consuming to implement, especially since we will have to reimplement many of these conversions across several projects. While each individual conversion might be quick and simple, the cumulative effort can be significant. Additionally small differences across implementations may lead to subtle bugs and inconsistencies.

## This Solution

This POC demonstrates a shared library written in Zig that can be used across multiple programming languages (C, Elixir, Python, Go, R) for high-performance unit conversions. This allows for single implementation to be shared across multiple projects, reducing the effort required to implement and maintain unit conversions, increasing confidence in the correctness of the conversions.

### Shared Library Approach (This Project)

**Pros:**

- **Performance**: Direct function calls with near-zero overhead (~nanoseconds)
- **No Network Latency**: No HTTP/gRPC serialization, deserialization, or network round-trips
- **Simplicity**: Single source of truth, compile once, link everywhere
- **Memory Efficiency**: Library loaded once per process, shared across threads
- **Type Safety**: Direct FFI bindings with compile-time type checking
- **Offline**: No dependency on network availability or service uptime
- **Lower Operational Overhead**: No containers, orchestration, load balancers, or service discovery needed
- **Deterministic**: No retry logic, timeouts, or circuit breakers needed

**Cons:**

- **Deployment Complexity**: Must recompile/redeploy all dependent applications when library updates
- **Version Management**: All services must use compatible library versions
- **Platform Dependency**: Must compile for each target OS/architecture
- **Every Language Requires its own FFI bindings**: Each language requires its own FFI bindings to interact with the shared library. This will suck to maintain and update.

### Microservice Approach (One Alternative)

**Pros:**

- **Independent Deployment**: Update conversion service without touching consumers
- **Language Agnostic**: Any language with HTTP/gRPC client support
- **Centralized Updates**: Fix bugs once, all consumers benefit immediately
- **Easier Monitoring**: Centralized logging, metrics, and observability
- **Fault Isolation**: Service crash doesn't bring down consumers

**Cons:**

- **Network Latency**: HTTP/gRPC adds 1-10ms+ overhead per call
- **Operational Complexity**: Requires infrastructure (Kubernetes, load balancers, service mesh)
- **Network Reliability**: Requires retry logic, circuit breakers, timeouts
- **Cascading Failures**: Network issues affect all consumers

### Reimplementing in Each Repository (Another Alternative)

**Pros:**

- **Complete Independence**: Each service owns its own implementation
- **No External Dependencies**: No shared libraries or microservices to coordinate
- **Language-Native Solutions**: Use idiomatic patterns for each language
- **Simple Deployment**: Deploy and update independently without coordination
- **No FFI Complexity**: No foreign function interface bindings required

**Cons:**

- **Code Duplication**: Same logic written multiple times in different languages
- **Inconsistency Risk**: Implementations may drift, leading to subtle bugs across services
- **Maintenance Burden**: Bug fixes must be applied to every implementation separately
- **Testing Overhead**: Must test conversion logic in every codebase independently
- **Knowledge Fragmentation**: Domain expertise scattered across teams/repos
- **Higher Implementation Cost**: N repositories = N implementations + N test suites

### Mitigating the Cons of a Shared Library

- **Only update when you need to**: because these conversions rarely (never) change, if a depending service doesn't require a new conversion, they can safely remain unchanged until they require something new.
- **Modern Compilers**: Modern compilers (aka not gcc or clang) usually have first class cross compilation support. Compiling for a new target OS and architecture is not difficult.
- **AI-Powered Binding Libraries**: AI-powered tools can automatically generate bindings for different programming languages, reducing the need for manual implementation.

## Why Shared Library for Unit Conversions?

Unit conversions are ideal for shared libraries because:

1. **Finicky Precision**: Unit conversions involve precise mathematical relationships that are easy to get wrong. Implementing once in a battle-tested library ensures consistency.
2. **Hot Path Performance**: Conversions can happen in tight loops (e.g., processing sensor data, financial calculations). Nanosecond latency matters.
3. **Stateless Operations**: Pure functions with no side effects are perfect for FFI.
4. **Low Change Frequency**: Physical constants don't change often (1 meter = 0.001 km will always be true).
5. **Deterministic**: No external dependencies, databases, or network calls needed.
6. **Small Binary Size**: Conversion logic is compact, adding minimal overhead to applications.

## Building

```bash
zig build
```

This generates:

- `zig-out/lib/libUnitConversion.so` - The shared library

## Running Tests

```bash

# Python test
python3 test.py

# Elixir test
elixir test.exs

# Go test
go run test.go
```

## A Note on Zig:

I wrote this POC in Zig because I like it. There are several alternatives in the compiled space, like Rust, that could also be used to produce the shared library. (Rust can probably generate it easier with `cbindgen`).
