const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const lib = b.addLibrary(.{
        .linkage = .dynamic,
        .name = "UnitConversion",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
        }),
        .version = .{ .major = 1, .minor = 0, .patch = 0 },
    });

    lib.root_module.addIncludePath(b.path("src/"));

    const exe = b.addExecutable(.{
        .name = "test",
        .root_module = b.createModule(.{
            .link_libc = true,
            .target = target,
            .optimize = optimize,
        }),
    });
    exe.root_module.linkLibrary(lib);
    exe.root_module.addCSourceFile(.{ .file = b.path("src/test.c"), .flags = &.{"-std=c99"} });
    exe.root_module.addIncludePath(b.path("src/"));

    b.default_step.dependOn(&exe.step);

    const run_cmd = b.addRunArtifact(exe);

    const test_step = b.step("test", "Test the program");
    test_step.dependOn(&run_cmd.step);

    b.installArtifact(lib);
}
