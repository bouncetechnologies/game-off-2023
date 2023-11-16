# Adjust

## Requirements

- [Godot 4.2](https://github.com/godotengine/godot-builds/releases/download/4.2-beta6/Godot_v4.2-beta6_macos.universal.zip)
  - With the preview version linked, you must disable `Display Grid` within the editor settings under `Tiles Editor` or your performance will bw nuked because of an [ongoing bug](https://github.com/godotengine/godot/issues/72405#issuecomment-1807527021) with how the grid is displayed.

# Deployment

For automatic deployments of releases:

1. Set `ITCH_IO_API_KEY` to Itch.io api key
   - This can be generated in the developer settings on your itch account
2. Set `account/project-name` within the `godot.yml` workflow to the url part of your project
   - E.g., `bouncetechnologies/scream-jam-2023`
3. Create a release which starts with `v`
4. Wait for the action to pass and wait for it to upload to Itch
5. On Itch, set type of project to `HTML` and enable `Fullscreen Button` and `SharedArrayBuffer support`
6. See it deploy!
