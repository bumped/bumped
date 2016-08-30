# .init

It initializes a `.bumpedrc` file in the path.

`bumped init` is a smart command that tries to add common configuration files.

For example, if your project has `package.json` and `bower.json` it detects and adds them automagically:

```
$ bumped init

bumped File package.json has been added.
bumped File bower.json has been added.
bumped Current version is 0.0.0.
bumped Config file created!.
```

At this moment, **Bumped** creates a configuration file `.bumpedrc`, which is associated with the project folder. If you open this file, its content is a list made up of all the synchronized files:

```cson
files: [
  "package.json"
  "bower.json"
]
plugins:
  prerelease: {}
  postrelease: {}
```

For synchronizing the version around all the files, **Bumped** needs at least a one file with a `version` field. If it cannot detect a configuration file, the command will create a `package.json` with a `version` field.

As you can see, it also initializes the plugins section.
