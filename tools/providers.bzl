"""
Defines and declares toolchain shapes for rules blender.
"""

RulesBlenderInfo = provider(
    doc = "Information about which binaries to use to rasterize and composite images.",
    fields = ["blender", "ffmpeg"],
)

def _rules_blender_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        rulesblenderinfo = RulesBlenderInfo(
            blender = ctx.attr.blender,
            ffmpeg = ctx.attr.ffmpeg,
        ),
    )
    return [toolchain_info]

rules_blender_toolchain = rule(
    attrs = {
        "blender": attr.label(
            cfg = "exec",
            allow_single_file = True,
            executable = True,
            mandatory = True,
        ),
        "ffmpeg": attr.label(
            cfg = "exec",
            allow_single_file = True,
            executable = True,
            mandatory = True,
        ),
    },
    implementation = _rules_blender_toolchain_impl,
)
