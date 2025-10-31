#!/usr/bin/env python3
# Minimal Python test for libUnitConversion.so using ctypes FFI
# Run with: python3 test.py

import ctypes
import os

print("Testing m_to_km(1234) = 1.234")

# Load the shared library
lib_path = os.path.join(os.getcwd(), "zig-out", "lib", "libUnitConversion.so")
lib = ctypes.CDLL(lib_path)

# Define the function signature: double m_to_km(double)
lib.m_to_km.argtypes = [ctypes.c_double]
lib.m_to_km.restype = ctypes.c_double

# Call the function
result = lib.m_to_km(1234.0)
print(f"Result: {result}")

# Check the result
if abs(result - 1.234) < 0.0001:
    print("✓ TEST PASSED")
else:
    print("✗ TEST FAILED")
