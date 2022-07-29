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
        renderer,
        blend,
        frame,
        out):
    cmd_tpl = "{renderer} -b {blend} -o {out} -f {frame} -- --cycles-device CPU"
    cmd = cmd_tpl.format(
        renderer = renderer.path,
        blend = blend.path,
        out = out['blender_path'],
        frame = frame,
    )

    ctx.actions.run_shell(
        outputs = [out['output_file']],
        inputs = [blend],
        tools = [renderer],
        command = cmd,
        mnemonic = "Blender",
        progress_message = "Rendering frame {frame} of {blend}".format(
            frame = frame,
            blend = blend.path,
        ),
    )

def _blender_image(ctx):
    frame = ctx.attr.frame

    out = declare_output(ctx, frame)

    render_frame(
        ctx,
        ctx.files._renderer[0],
        ctx.files.srcs[0],
        frame,
        out,
    )

    return [
        DefaultInfo(files = depset([out['output_file']])),
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
        "_renderer": attr.label(
            default = Label("@blender//:blender"),
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
    },
)
