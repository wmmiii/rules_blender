# buildifier: disable=module-docstring
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def rules_blender_dependencies():
    """Dependencies used in the implementation of `rules_blender`."""

    maybe(
        http_archive,
        name = "blender_linux_64",
        build_file = "@rules_blender//:blender.BUILD",
        sha256 = "d363a836d03a2462341d7f5cac98be2024120e648258f9ae8e7b69c9f88d6ac1",
        strip_prefix = "blender-3.2.1-linux-x64",
        urls = ["https://mirror.clarkson.edu/blender/release/Blender3.2/blender-3.2.1-linux-x64.tar.xz"],
    )

    maybe(
        http_archive,
        name = "blender_win_64",
        build_file = "@rules_blender//:blender.BUILD",
        sha256 = "7ac0c02671677a1e4027ff38f99f2dbd78a9ec8b59558333f986033ff35472b8",
        strip_prefix = "blender-3.2.1-windows-x64",
        urls = ["https://mirror.clarkson.edu/blender/release/Blender3.2/blender-3.2.1-windows-x64.zip"],
    )

    maybe(
        http_archive,
        name = "ffmpeg_linux_amd64",
        build_file = "@rules_blender//:ffmpeg.BUILD",
        sha256 = "2f03905d8a2320f8bcd29a3562d3ada066617ff91b574d005540be09e08a722b",
        strip_prefix = "ffmpeg-git-20220722-amd64-static",
        urls = ["https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz"],
    )

    maybe(
        http_archive,
        name = "ffmpeg_win",
        build_file = "@rules_blender//:ffmpeg.BUILD",
        sha256 = "82d75ec0fb6a619ceb4410bee793c7bcb5df36f12e206a12f1377d7cb8617e17",
        strip_prefix = "ffmpeg-5.1-essentials_build",
        urls = ["https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"],
    )
