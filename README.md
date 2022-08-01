# Rules Blender

This repository provides a set of Bazel rules to render Blender files.

## Setup

Add the following to your project's WORKSPACE:
```
http_archive(
    name = "rules_blender",
    sha256 = "REPLACE WITH SHA",
    urls = ["REPLACE WITH GITHUB ZIP URL"],
)

load("@rules_blender//:repositories.bzl", "rules_blender_dependencies")

rules_blender_dependencies()

register_toolchains(
    "@rules_blender//tools:rules_blender_linux_64_toolchain",
)
```

## Usage

After including rules_blender in your project you can use these rules to transform Blender files into rasterized images:

```
load("@rules_blender//:blender.bzl", "blender_image", "blender_video")

blender_image(
    name = "rendered_frame",
    srcs = "//:my_file.blend",
    frame = 5,
)

blender_video(
    name = "rendered_video",
    srcs = "//:my_file.blend",
    end_frame = 240,
    framerate = 24,
)
```

See the [examples](examples) directory for more details!

## Disclaimer

Please note this is a joke ruleset and should not be used in any serious project.

## Third Party Software Used

- [Blender](https://www.blender.org/)
- [FFmpeg](https://ffmpeg.org/)