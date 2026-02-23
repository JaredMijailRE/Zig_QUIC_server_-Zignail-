const std = @import("std");

pub fn Server(comptime max_conn: usize) type {
    return struct {
        connection_mask: std.StaticBitSet(max_conn) = std.StaticBitSet(max_conn).initEmpty(),
        port: u16,
        const Self = @This();

        pub fn init(port: u16) Self {
            return .{
                .port = port,
            };
        }

        pub fn start(self: *Self) void {
            _ = self;
        }
    };
}
