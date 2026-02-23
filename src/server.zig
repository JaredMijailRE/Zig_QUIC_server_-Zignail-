const std = @import("std");
const u = @import("utils.zig");

pub fn Server(comptime port_val: usize, comptime max_conn: usize) type {
    return struct {
        connection_mask: std.StaticBitSet(max_conn),
        port: u.SmallestUintFor(port_val),

        const Self = @This();

        pub fn init() Self {
            return .{
                .connection_mask = std.StaticBitSet(max_conn).initEmpty(),
                .port = @intCast(port_val),
            };
        }

        pub fn start(self: *Self) void {
            _ = self;
        }
    };
}
