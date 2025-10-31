#!/usr/bin/env Rscript
# Minimal R test for libUnitConversion.so using FFI
# Run with: Rscript test.R

cat("Testing m_to_km(1234) = 1.234\n")

# Load the shared library
lib_path <- file.path(getwd(), "zig-out", "lib", "libUnitConversion.so")
dyn.load(lib_path)

# Call the C function
# .C() interface: expects function name and arguments
result <- .Call("m_to_km", 1234.0)

cat(sprintf("Result: %f\n", result))

# Check the result
if (abs(result - 1.234) < 0.0001) {
  cat("✓ TEST PASSED\n")
} else {
  cat("✗ TEST FAILED\n")
}

# Clean up
dyn.unload(lib_path)
