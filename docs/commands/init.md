# .init

It initializes a `.bumpedrdc` file in the path.

`bumped init` is a smart command that try to add common configuration files.

For example, if your project have `package.json` and `bower.json` it detects and add them automagically:

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

For synchronize the version around all the files, **Bumped** needs at least a one file with a `version` field. If is not possible detect a configuration file, the command will create a `package.json` with `version` field.

As you can see, it also initializes plugins section.
