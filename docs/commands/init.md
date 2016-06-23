# .init

The first command that you need to run is `bumped init`. If you run it in a totally blank project, you'll see something like this:

```bash
$ bumped init

warn  : It has been impossible to detect files automatically.
warn  : Try to add manually with 'add' command.
warn  : There isn\'t version declared.
success : Config file created!.
```

The magic appears when running it in a project with common package manager configuration files, for instance, like `package.json` or `bower.json`:

```bash
$ bumped init

info	: Detected 'package.json' in the directory.
info	: Current version is '1.0.1'.
success	: Config file created!.
```

At this moment, **Bumped** creates a configuration file `.bumpedrc`, which is associated with the project folder. If you open this file, its content is a list made up of all the synchronized files:

```cson
files: [
  "package.json"
]
```
