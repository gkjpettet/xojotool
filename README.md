# xojotool
A multipurpose command line tool for manipulating Xojo projects.

## Installation

There are several ways to install `xojotool`.

### 1. Use a package manager (easiest)

Simple installation with [Homebrew] and [Scoop] is provided for macOS and Windows users.

#### macOS

If you're using macOS you can use the excellent [Homebrew] package manager to quickly install `xojotool`:

```bash
brew tap gkjpettet/homebrew-xojotool
brew install xojotool
```

You can make sure that you've always got the latest version of `xojotool` by running `brew update` in the Terminal. You'll know there's an update available if you see the following:

```bash
==> Updated Formulae
gkjpettet/xojotool/xojotool ✔
```

Then you'll know there's a new version available. To install it simply type `brew upgrade` in the Terminal.

#### Windows
If you're using Windows I recommend using [Scoop] to install `xojotool`. Once You've setup Scoop, simply type the following into the Command Prompt or the Powershell:

```bash
scoop bucket add xojotool https://github.com/gkjpettet/scoop-xojotool
scoop install xojotool
```

To update `xojotool` run the following commands:

```bash
scoop update
scoop update xojotool
```

### 2. Install the precompiled binary and its dependencies

If you can't/don't want to use a package manager then I provide precompiled binaries for macOS (64-bit), Windows (64-bit) and x86 Linux (64-bit). Essentially just make sure that you install the `xojotool` binary and all its dependencies (included in the download) within your system's `$PATH`. The Mac and Linux versions contain one file and one folder:

```bash
xojotool
[xojotool Libs]
```

The Windows version includes several files and a folder:

```bash
icudt65.dll
icuin65.dll
icuuc65.dll
msvcp120.dll
msvcp140.dll
msvcr120.dll
vccorlib140.dll
vcruntime140_1.dll
vcruntime140.dll
XojoConsoleFramework64.dll
[xojotool Libs]
xojotool.exe
```

I use a Mac and if I wasn't using Homebrew I would place `xojotool` and `xojotool Libs/` in `/usr/local/bin`. You can grab the required files from the [releases page].

### 3. Build the tool from source

**Note: Requires a Xojo license and Monkeybread plugin license**

1. Clone the repo (or download it as a ZIP file)
2. Launch the `src/xojotool.xojo_project` file in Xojo
3. Create a module called `RegisterPlugins` and add a method to it called `MBS` that takes no parameters and returns nothing. In this method you should register the [Monkeybread] plugins using your own serial number.

After you've built the app, remember to place the `xojotool` executable in your `$PATH` (and make sure the dependency folder/files are in the same place).

[Homebrew]: https://brew.sh
[Scoop]: https://scoop.sh
[releases page]: https://github.com/gkjpettet/xojotool/releases
[Monkeybread]: https://www.monkeybreadsoftware.de/xojo/ 