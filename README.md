# Adjust

## Requirements

- [Godot 4.2](https://github.com/godotengine/godot-builds/releases/download/4.2-beta6/Godotxq_v4.2-beta6_macos.universal.zip)
  - With the preview version linked, you must disable `Display Grid` within the editor settings under `Tiles Editor` or your performance will bw nuked because of an [ongoing bug](https://github.com/godotengine/godot/issues/72405#issuecomment-1807527021) with how the grid is displayed.

# GitHub Action Deployment

## Setup

For automatic deployments of releases:

1. Set `ITCH_IO_API_KEY` to Itch.io api key
   - This can be generated in the developer settings on your itch account
2. Set `account/project-name` within the `godot.yml` workflow to the url part of your project
   - E.g., `bouncetechnologies/scream-jam-2023`
3. Create a release which starts with `v`
4. Wait for the action to pass and wait for it to upload to Itch
5. On Itch, set type of project to `HTML` and enable `Fullscreen Button` and `SharedArrayBuffer support`
6. See it deploy!

## Known issues

While exporting this way is much more convenient, unfortunately to get the export to look the exact way on mac we will have to export final builds locally.

Currently affected graphical bugs:

- Respawn and death dissolve animations do not dissolve the same way locally vs github action build

# Building

## Web

For web, set your `export_presets.cfg` to:

```
[preset.0]

name="Web"
platform="Web"
runnable=true
dedicated_server=false
custom_features=""
export_filter="all_resources"
include_filter=""
exclude_filter=""
export_path="build/web/index.html"
encryption_include_filters=""
encryption_exclude_filters=""
encrypt_pck=false
encrypt_directory=false

[preset.0.options]

custom_template/debug=""
custom_template/release=""
variant/extensions_support=false
vram_texture_compression/for_desktop=true
vram_texture_compression/for_mobile=false
html/export_icon=true
html/custom_html_shell=""
html/head_include=""
html/canvas_resize_policy=2
html/focus_canvas_on_start=true
html/experimental_virtual_keyboard=false
progressive_web_app/enabled=false
progressive_web_app/offline_page=""
progressive_web_app/display=1
progressive_web_app/orientation=0
progressive_web_app/icon_144x144=""
progressive_web_app/icon_180x180=""
progressive_web_app/icon_512x512=""
progressive_web_app/background_color=Color(0, 0, 0, 1)
```

1. Go to `Project->Export..`, click the web section and `Export All`.
2. Go to `build/` folder
3. Zip folder and name it `game-off-2023.zip`
4. Go to our itch management page for our game
5. Upload the zip
6. Delete the old zip upload on the page
7. Enable browser play for the build
8. Save
9. Play!
