# .init

It initializes a `.bumpedrc` file in the path.

`bumped init` is a smart command that tries to add common configuration files.

For example, if your project has `package.json`, it detects and adds them automagically:

```
$ bumped init

bumped File package.json has been added.
bumped Current version is 0.0.0.
bumped Config file created!.
```

At this moment, **Bumped** creates a configuration file `.bumpedrc`, which is associated with the project folder.

If you open this file, its content is a list made up of all the synchronized files:

```yaml
files:

- package.json

plugins:

  prerelease:

    Linting config files:
      plugin: bumped-finepack

  postrelease:

    Generating CHANGELOG file:
      plugin: bumped-changelog

    Committing new version:
      plugin: bumped-terminal
      command: git add CHANGELOG.md package.json && git commit -m "Release $newVersion"

    Detecting problems before publish:
      plugin: bumped-terminal
      command: git-dirty && npm test

    Publishing tag at Github:
      plugin: bumped-terminal
      command: git tag $newVersion && git push && git push --tags

    Publishing at NPM:
      plugin: bumped-terminal
      command: npm publish
```

> **NOTE**: The file is generated in YAML format, but currently it supports JSON or CSON as well.

The file generated is divided in two sections:

#### Files

type: `Array`

**Bumped** needs at least a one file with a `version` field for synchronizing the version around all the files.

If it cannot detect a configuration file, the command will create a `package.json` with a `version` field.

#### Plugins

type: `Object`

It contents the `prerelease` and `postrelease` tasks to perform every time that you release a new version using **Bumped**.

As you can see, the definition of a task is composed by:

- The description of the task.
- The plugin to use for perform the task.
- The API of the task for connect with your code.
