const std = @import("std");

pub fn SmallestUintFor(comptime max_value: usize) type {
    if (max_value == 0) return u1;
    const bits = std.math.log2_int(usize, max_value) + 1;
    return std.meta.Int(.unsigned, bits);
}
