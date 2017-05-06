Optionally, you can put resources (such as .obj meshes and texture images) into this folder, and running `make resources` will push them to your `gh-pages` branch. This will upload them to `http://<your-username>.github.io/<your-project>/<path-to-file>`.

For example, if you have a mesh file located at `resources/meshes/something.obj`, your GitHub username is `someguy`, and your repo is called `myproject`, then its URL would be:

```
http://someguy.github.io/myproject/meshes/something.obj
```

You'll then be able to use this URL in your save file to serve these resources to players who download your mod.
