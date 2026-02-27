const std = @import("std");
const u = @import("utils.zig");

pub const ServerOptions = struct {
    port_val: usize = 8080,
    max_conn: usize = 2048,
};

pub fn Server(comptime options: ServerOptions) type {
    return struct {
        connection_mask: std.StaticBitSet(options.max_conn),
        port: u.SmallestUintFor(options.port_val),

        const Self = @This();

        pub fn init() Self {
            return .{
                .connection_mask = std.StaticBitSet(options.max_conn).initEmpty(),
                .port = @intCast(options.port_val),
            };
        }

        pub fn start(self: *Self) void {
            _ = self;

            const fd: i32 = @intCast(std.os.linux.socket(std.os.linux.AF.INET6, std.os.linux.SOCK.DGRAM, 0));
            defer _ = std.os.linux.close(fd);
        }
    };
}
