"""
Defines rules to perform Blender render actions.
"""

def render_frame(ctx, renderer, blend, frame, out):
    cmd_tpl = "{renderer} -b {blend} -f {frame} -o {out}"
    cmd = cmd_tpl.format(
        renderer = renderer.path,
        blend = blend.path,
        frame = frame,
        out = out.path,
    )

    ctx.actions.run_shell(
        outputs = [out],
        inputs = [renderer, blend],
        command = cmd,
        mnemonic = "Blender",
        progress_message = "Rendering frame {frame} of {blend}".format(
            frame = frame,
            blend = blend.path,
        )
    )


def _blender_image(ctx):
    frame = 0
    out_name = "{name}_{frame}.jpg".format(
        name = ctx.label.name,
        frame = frame,
    )
    output_file = ctx.actions.declare_file(out_name)

    render_frame(ctx, ctx.files._renderer[0], ctx.files.srcs[0], frame, output_file)

    return [
        DefaultInfo(files = depset([output_file])),
    ]


blender_image = rule(
    implementation = _blender_image,
    attrs = {
        "srcs": attr.label(
            allow_files = [".blend"],
        ),
        "_renderer": attr.label(
            default = Label("@blender//:blender"),
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
    },
)
