const std = @import("std");
const Zignail = @import("Zignail");
const Sv = @import("server.zig");

pub fn main() !void {
    // metaprgramming, type declaration
    const server_type = Sv.Server(23, 1024);
    // our instance in memory
    var my_server = server_type.init();
    my_server.start();
}
