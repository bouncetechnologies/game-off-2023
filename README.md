# godot-template-project

For automatic deployments of releases:

1. Set `ITCH_IO_API_KEY` to Itch.io api key
   - This can be generated in the developer settings on your itch account
2. Set `account/project-name` within the `godot.yml` workflow to the url part of your project
   - E.g., `bouncetechnologies/scream-jam-2023`
3. Create a release which starts with `v`
4. Wait for the action to pass and wait for it to upload to Itch
5. On Itch, set type of project to `HTML` and enable `Fullscreen Button` and `SharedArrayBuffer support`
6. See it deploy!
