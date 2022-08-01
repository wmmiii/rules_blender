load("@rules_blender//tools:providers.bzl", "rules_blender_toolchain")

toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

rules_blender_toolchain(
    name = "rules_blender_linux_64",
    blender = "@blender_linux_64//:blender",
    ffmpeg = "@ffmpeg_linux_amd64//:ffmpeg",
)

toolchain(
    name = "rules_blender_linux_64_toolchain",
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    toolchain = ":rules_blender_linux_64",
    toolchain_type = ":toolchain_type",
    visibility = ["//visibility:public"],
)
