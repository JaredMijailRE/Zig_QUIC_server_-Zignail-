const std = @import("std");
const Zignail = @import("Zignail");
const Sv = @import("server.zig");

pub fn main() !void {
    const serverConfig = Sv.Server(1024);
    var my_server = serverConfig.init(23);
    my_server.start();
}
