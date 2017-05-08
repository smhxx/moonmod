## MoonMod [![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT) [![Latest Release](https://img.shields.io/github/release/smhxx/moonmod.svg?maxAge=1800)](https://github.com/smhxx/moonmod/releases)

<img alt="Tabletop Simulator Logo" align="right" width="240" height="150" src="http://i.imgur.com/T0N1sLu.jpg" />

**MoonMod** is a framework built in MoonScript that allows for the easy creation and packaging of user modifications for the game [**Tabletop Simulator**](http://store.steampowered.com/app/286160/Tabletop_Simulator/). MoonMod allows mods to be written in MoonScript using a more programmer-friendly API, then cross-compiled to Lua and injected automatically into a .json save file for distribution on the [Steam Community Workshop](http://steamcommunity.com/app/286160/workshop/). MoonMod also supports the creation of smaller object-based mod scripts and libraries which can then be distributed for use in other projects.

### Requirements

* **make** - General-purpose build utility. Available via `apt-get` or from [gnu.org](https://www.gnu.org/software/make/)
* **moonc** - Moonscript compiler. Available from the `moonscript` package on `luarocks` or from [leafo/moonscript](https://github.com/leafo/moonscript).
* **squish** - Lua code packager/minifier. Download and build from [LuaDist/squish](https://github.com/LuaDist/squish).
* **jq** - Command-line JSON manipulator. Available via `apt-get` or from [stedolan/jq](https://stedolan.github.io/jq/)
* **busted** - Lua/MoonScript testing utility (optional). Available via `luarocks` or from [Olivine-Labs/busted](https://github.com/Olivine-Labs/busted).

```sh
sudo apt-get install luarocks make jq
sudo luarocks install moonscript busted
git clone https://github.com/LuaDist/squish && cd squish
sudo make install
```

### Usage

MoonMod offers two main advantages to your project. The first is the packaging/deployment framework, which is the primary purpose of this repository. The other is a set of MoonScript libraries that build on top of the existing TTS API, allowing you to do more stuff, more easily, with less code. These libraries are optional, and each is documented in its own repo (see the included submodules). To get started with MoonMod, you'll want to follow a couple easy steps:

#### Setting up your repository

Set up a new empty repository where you want to keep your project. Then, in your shell/terminal, navigate to the directory where you want to keep your local copy and do:

```sh
git clone https://github.com/smhxx/moonmod
mv moonmod <your-project-name>
cd <your-project-name>
git remote rm origin
git remote add origin git@github.com:<your-username>/<your-repo-name>.git
git commit -m "Setting up new MoonMod project"
git push origin master
```

This will populate your shiny new repo with everything you need for your project. Alternatively, you can always just fork this repo on GitHub and then rename your copy. (The outcome is roughly the same.)

#### Setting up save building

Chances are, if you're making a mod, you'll want to take advantage of fully automating your build process... after all, who has time to copy and paste your code into the in-game editor? First, set up your save as you'd like it to be, and then navigate to your save directory and find the associated file. It'll be named something like `TS_Save_1.json`. Copy the save file into your `templates` directory and name it `save.json`. Then, find the full path to the original file and do this:

```sh
echo "/path/to/TS_Save_<x>.json" > .savefile
```

Now MoonMod knows where to copy the completed save file when you run `make save`. If you've done this correctly, every time you update your code all you'll need to do is `make save` and reload it in-game, and you'll be on the new version!

Note that if you're running the Windows version of the game and developing in a Linux VM, you'll need to set your save directory as a shared folder in order to be able to access it directly.

#### Other shortcuts

MoonMod's Makefile includes a bunch of useful productivity shortcuts. Here's what you're getting:

* `make save`: Builds **everything** and creates a save file with your new code. If `.savefile` contains a file location, it will attempt to copy the output to that location as well. If you plan on using `make save`, make sure that:
  * You have a valid-formatted save file located at `templates/save.json`
  * If your mod includes a global script, one of your `squishy` config files outputs to `dist/global.lua`
  * If your mod includes object scripts, one of your `squishy` config files outputs to `dist/objects/<guid>.lua` for each separate object you want to attach a script to
* `make dist`: Builds all of your distribution files, but **doesn't** attempt to inject them into your save template. Useful if your project is a library rather than a mod, or if you just want to make sure your code compiles correctly.
* `make test`: Runs `busted` on any test suite files located in the `test` directory or its children. Ignores any files not named `<something>.test.moon` or `<something>.test.lua`. See the [**Busted**]() documentation for how to write your tests, and see the library submodules for examples.
* `make testdist`: The same as `make test`, except runs your tests using the final distribution output, not your raw MoonScript source. Useful for making sure that your `squishy` files are working correctly.
* `make resources`: Commits and pushes the contents of the `resources` directory to the `gh-pages` branch, if you want to host your mod's resources on GitHub. Keep in mind this will update these resources *immediately* for **all** users of your mod, even if they don't re-download from the workshop!

#### Using the MoonMod libraries

As mentioned above, MoonMod also contains some helpful libraries that could be useful in your project. By default, they are all included, but you can easily remove any ones you don't need with `git rm`. The included libraries are:

* `moonmod-core`: Basic useful stuff, applicable to just about any project. Includes things like callbacks and a couple small utility classes.
* `moonmod-dice`: Allows you to interact in a richer way with dice objects, including detecting when they are rolled and doing things depending on the result.
* `moonmod-board-ui`: Allows you to more easily manage buttons as a form of user interface, for example if you have an options/control board in your mod.

If you have any custom MoonMod libraries you want to add, you can add them with `git submodule add https://github.com/<username>/<repo-name>.git libraries/<repo-name>`. (If you use SSH remotes, you may run into problems with CI testing, since Travis won't have your SSH keys in order to log in.)

### License

The source code of this project is released under the [MIT License](https://opensource.org/licenses/MIT), which freely permits reuse and redistribution. Feel free to use and/or modify it in any way, provided that you include this copyright notice with your work.

    Copyright (c) 2016 "smhxx" (https://github.com/smhxx)

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
    associated documentation files (the "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
    following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial
    portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
    LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
    NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
