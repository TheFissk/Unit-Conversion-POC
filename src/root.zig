//! By convention, root.zig is the root source file when making a library.
const std = @import("std");

export fn m_to_km(meters: f64) callconv(.c) f64 {
    return meters / 1000.0;
}

test "converts metres to kilometres" {
    try std.testing.expect(m_to_km(1234.0) == 1.234);
}
