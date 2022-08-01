"""
Defines rules to perform Blender render actions.
"""

def declare_output(ctx, frame):
    """Returns a dict with two fields describing a declared render output.

    Args:
      ctx: The Bazel context.
      frame: The frame number of the output file.

    Returns:
        A dict with two fields:
          output_file: The declared Bazel output file.
          blender_path: The path that can be passed into the -o argument of Blender.
    """
    frame_string = "{frame}".format(frame = frame)
    for _i in range(0, 8):
        if len(frame_string) >= 8:
            break
        else:
            frame_string = "0" + frame_string

    out_name = "{name}_{frame}.png".format(
        name = ctx.label.name,
        frame = frame_string,
    )
    output_file = ctx.actions.declare_file(out_name)
    blender_path = output_file.path[:-12] + "########.png"
    return {
        "output_file": output_file,
        "blender_path": blender_path,
    }

def render_frame(
        ctx,
        blender_file,
        blend,
        frame,
        out):
    """ Renders a single frame from a Blender .blend file.

    Args:
        ctx: The Bazel context.
        blender_file: The file of the Blender executable.
        blend: The .blend file to render.
        frame: The frame number to render.
        out: The output file dict generated with the `declare_output` function.
    """
    args = ctx.actions.args()
    args.add("-b", blend.path)
    args.add("-o", out["blender_path"])
    args.add("-f", frame)
    args.add("--")
    args.add("--cycles-device", "CPU")

    ctx.actions.run(
        outputs = [out["output_file"]],
        inputs = [blend],
        tools = [blender_file],
        executable = blender_file,
        arguments = [args],
        mnemonic = "Blender",
        progress_message = "Rendering frame {frame} of {blend}".format(
            frame = frame,
            blend = blend.path,
        ),
    )

def _blender_image(ctx):
    toolchain = ctx.toolchains["@rules_blender//tools:toolchain_type"]

    frame = ctx.attr.frame

    out = declare_output(ctx, frame)

    render_frame(
        ctx,
        toolchain.rulesblenderinfo.blender.files.to_list()[0],
        ctx.files.srcs[0],
        frame,
        out,
    )

    return [
        DefaultInfo(files = depset([out["output_file"]])),
    ]

blender_image = rule(
    implementation = _blender_image,
    attrs = {
        "srcs": attr.label(
            allow_files = [".blend"],
        ),
        "frame": attr.int(
            default = 0,
        ),
    },
    toolchains = [
        "@rules_blender//tools:toolchain_type",
    ],
)

def _blender_video(ctx):
    toolchain = ctx.toolchains["@rules_blender//tools:toolchain_type"]

    frames = []
    for frame in range(ctx.attr.start_frame, ctx.attr.end_frame + 1):
        out = declare_output(ctx, frame)

        render_frame(
            ctx,
            toolchain.rulesblenderinfo.blender.files.to_list()[0],
            ctx.files.srcs[0],
            frame,
            out,
        )

        frames.append(out["output_file"])

    inputs = "{dir}/{name}_%08d.png".format(
        dir = frames[0].dirname,
        name = ctx.label.name,
    )

    out_name = "{name}.mp4".format(name = ctx.label.name)
    output_file = ctx.actions.declare_file(out_name)

    args = ctx.actions.args()
    args.add("-f", "image2")
    args.add("-framerate", ctx.attr.framerate)
    args.add("-i", inputs)
    args.add("-c:v", "libx264")
    args.add("-crf", "22")
    args.add(output_file.path)

    ffmpeg_file = toolchain.rulesblenderinfo.ffmpeg.files.to_list()[0]

    ctx.actions.run(
        outputs = [output_file],
        inputs = frames,
        executable = ffmpeg_file,
        tools = [ffmpeg_file],
        arguments = [args],
        mnemonic = "FFmpeg",
    )

    return [
        DefaultInfo(files = depset([output_file])),
    ]

blender_video = rule(
    implementation = _blender_video,
    attrs = {
        "srcs": attr.label(
            allow_files = [".blend"],
        ),
        "start_frame": attr.int(
            default = 0,
        ),
        "end_frame": attr.int(
            mandatory = True,
        ),
        "framerate": attr.int(
            mandatory = True,
        ),
    },
    toolchains = [
        "@rules_blender//tools:toolchain_type",
    ],
)
