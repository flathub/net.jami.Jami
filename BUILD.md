# Building for Flatpak

Similar to Snap, there is a Flatpak version of Jami that is distributed on [Flathub](https://flathub.org/apps/net.jami.Jami).

## What is Flatpak, and how does it work?

It is recommended that the [Introduction to Flatpak](https://docs.flatpak.org/en/latest/introduction.html) and [Basic Concepts](https://docs.flatpak.org/en/latest/basic-concepts.html) be read to get a basic understanding of Flatpaks.

> Before proceeding, install the [flatpak](https://flatpak.org/setup/) package.

## Source code

The source code for the Flatpak version is the exact same as that of the desktop client.
However, the manifest, dependencies, and Flatpak-specific patches are hosted on the official GitHub repository (as required by Flathub), which can be found [here](https://github.com/flathub/net.jami.Jami).

## Prerequisites

Install flatpak-builder:
```bash
flatpak install flathub org.flatpak.Builder
```

Then, add the Flathub repo user-wide:
```bash
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

## Building the Flatpak locally

### Clone the GitHub repository

```bash
git clone git@github.com:flathub/net.jami.Jami.git
```

### Build Jami

```bash
flatpak-builder --force-clean --user --install-deps-from=flathub --repo=DIR builddir net.jami.Jami.yml
```

`DIR`—the repository name.
By default the repository name should be `repo`.
If the repository name is anything else, the repository name must be used when [installing Jami](#install-jami), [debugging the Flatpak](#debugging), and [submitting updates to Flathub](#submitting-updates-to-flathub).

### Install Jami

```
flatpak install DIR -y net.jami.Jami
```

### Run Jami

```
flatpak run net.jami.Jami
```


> If there are multiple Flatpak installations of Jami, the `--branch=BRANCH` switch should be specified after the `run` command to run the Flatpak that was just built.
>
> The Flatpak installations and their corresponding branches can be checked using the `flatpak list` command. To run the Flatpak that was just built and installed, set `BRANCH` to the branch that corresponds to `Origin` being `repo`.


## Debugging

Debugging Flatpaks within the sandbox on a local machine is possible.

> Due to the way Jami is built for Flatpak, debugging can be time-consuming since jami-core is built as a shared library.
> This means that each time the debugger is restarted, it is required to wait for the symbols to load.
> Unless it is certain that the issue being debugged is specific to the Flatpak version of Jami, it is usually faster to build and debug the desktop client locally.
> For instructions, see [here](dependencies.md#jami-client-qt).

### Downloading the debug version

The instructions to build the Jami Flatpak as described in the [previous section](#building-the-flatpak-locally) must be complete prior to proceeding.
Once done, install the debug version:
```bash
flatpak install --include-sdk --include-debug repo -y net.jami.Jami
```

### Starting the debugging environment

The following command will run a shell within the sandbox:
```bash
flatpak run --command=sh --devel --filesystem=$(pwd) net.jami.Jami
```

Once run, the shell should appear similar to the following:
```bash
[📦 net.jami.Jami net.jami.Jami]$
```

There are now two methods for debugging.
Regardless of which is chosen, commands described in either section should be run _within the sandbox shell_.

#### Debug with the GNU Project Debugger (GDB)

```bash
gdb --args /app/bin/jami --debug
```
Debugging can now be done as usual.

#### Debug with Visual Studio Code (VS Code)

1. Start gdbserver.
   ```bash
   gdbserver :1234 /app/bin/jami --debug
   ```

   > The port number can be changed if required.
   > Make sure the port number for _miDebuggerServerAddress_ in `.vscode/launch.json` reflects the new port number.

2. Launch VS Code at the root of the project.
3. Enter the Run and Debug section (Ctrl+Shift+D).
4. Select `Attach to Remote GDB`.
5. Run Jami (F5).

##### Setting breakpoints

Source files are located in `builddir/files/lib/debug/source` at the root of the project and are where breakpoints should be set.

## Submitting updates to Flathub

If not done already, install flatpak-builder and add the Flathub repo user-wide as described in the [Prerequisites](#prerequisites) section.

### Build the manifest

```bash
flatpak run --command=flathub-build org.flatpak.Builder --install net.jami.Jami.yml
```

### Run and test Jami

```bash
flatpak run net.jami.Jami
```

### Run the linter

The following commands must be run when changes are made to the YAML files.
If there are errors, they must be resolved before opening a pull request.
Otherwise, the Flathub test builds _will fail_ as well.

```bash
flatpak run --command=flatpak-builder-lint org.flatpak.Builder manifest net.jami.Jami.yml
```

```bash
flatpak run --command=flatpak-builder-lint org.flatpak.Builder repo repo
```

The list of linter errors can be found [here](https://docs.flathub.org/docs/for-app-authors/linter#linter-errors).

### Push changes and open a pull request

If the build was successful and passed the linter checks, changes can be pushed to the GitHub repo and a pull request can be opened.
Once the pull request is opened, the Flathub automatic build system will create test builds for the `x86_64` and `aarch64` architectures.
If the test builds are successful, the pull request will be able to be merged into master, triggering the official builds.

> Any changes to `finish-args` in `net.jami.Jami.yml` as well as changes to `net.jami.Jami.metainfo.xml` will require approval by the Flathub maintainers.
> Depending on the changes, the build may be rejected or require an explanation or justification.
> For the latter, an issue will be opened on the GitHub repository to explain or justify the changes.
> 
> To see the status of approval, sign in to [Flathub](https://flathub.org) and navigate to Developer Portal → Jami.
