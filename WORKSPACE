workspace(name = "rules_blender")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "blender",
    build_file = "//:blender.BUILD",
    sha256 = "d363a836d03a2462341d7f5cac98be2024120e648258f9ae8e7b69c9f88d6ac1",
    strip_prefix = "blender-3.2.1-linux-x64",
    urls = ["https://mirror.clarkson.edu/blender/release/Blender3.2/blender-3.2.1-linux-x64.tar.xz"],
)

