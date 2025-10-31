package main

// #cgo LDFLAGS: -L./zig-out/lib -lUnitConversion -Wl,-rpath,./zig-out/lib
// #include <stdlib.h>
// double m_to_km(double meters);
import "C"

import (
	"fmt"
	"math"
)

func main() {
	fmt.Println("Testing m_to_km(1234) = 1.234")

	// Call the C function
	result := float64(C.m_to_km(C.double(1234.0)))
	fmt.Printf("Result: %f\n", result)

	// Check the result
	if math.Abs(result-1.234) < 0.0001 {
		fmt.Println("✓ TEST PASSED")
	} else {
		fmt.Println("✗ TEST FAILED")
	}
}
