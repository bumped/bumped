# bumped

<h1 align="center">
  <br>
  <img src="http://i.imgur.com/DmMbFwL.png" alt="bumped">
  <br>
  <br>
</h1>

![Last version](https://img.shields.io/github/tag/bumped/bumped.svg?style=flat-square)
[![Build Status](http://img.shields.io/travis/bumped/bumped/master.svg?style=flat-square)](https://travis-ci.org/bumped/bumped)
[![Dependency status](http://img.shields.io/david/bumped/bumped.svg?style=flat-square)](https://david-dm.org/bumped/bumped)
[![Dev Dependencies Status](http://img.shields.io/david/dev/bumped/bumped.svg?style=flat-square)](https://david-dm.org/bumped/bumped#info=devDependencies)
[![NPM Status](http://img.shields.io/npm/dm/bumped.svg?style=flat-square)](https://www.npmjs.org/package/bumped)
[![Gittip](http://img.shields.io/gittip/kikobeats.svg?style=flat-square)](https://www.gittip.com/kikobeats)

> Makes easy release software.

## Why?

- Separates the process of create software to publish software.
- Synchronizes, unifies and publishes your software version in the different packages managers.
- Easy to integrate with current or new projects.
- Associates actions before or after publish your software *(not yet, but soon!)*.

**Bumped** synchronizes the version of your software across different package managers configuration files (npm, bower,...) and controls, edits and releases the version for be sure that is the same in all the files.

Because writing software is hard enough, we must make the publishing process of software simple and effective.

## Install

```bash
npm install bumped -g
```

## Usage

### .init

The first command that you need to run is `bumped init`. If you run it in a totally blank project, you
see something like:

```bash
$ bumped init

warn  : It has been impossible to detect files automatically.
warn  : Try to add manually with 'add' command.
warn  : There aren't a version declared.
success : Config file created!.
```

But running it in a project with common package managers configuration files `package.json` or `bower.json` the magic begins to appear:

```bash
$ bumped init

info	: Detected 'package.json' in the directory.
info	: Current version is '1.0.1'.
success	: Config file created!.
```

At this moment, **Bumped** will create a configuration file `.bumpedrc` that is associate with the folder of the project. If you open the files this content a list of files to syncrhonizes:

```cson
files: [
  "package.json"
]
```

The format of the file is [CSON](https://github.com/bevry/cson), However you can use JSON, but this file is auto-generate for **Bumped**.

### .version

When you are not sure what is the current version synchronized across your configuration files just run `bumped version`:

```bash
$ bumped version

info	: Current version is '1.0.0'.
```

The shared version of the files is the major version detected between them. However, will not be syncrhonized until the next releases.

### .release

It's moment to release a new version of your sofware. You can do this in two different ways.

- Providing the exact version that you want to release

- Providing the semantic semver version to release (using the keywords `major`, `minor`, `patch`,...

In both cases the unique requisite is that the version to be releases want to be major that the current version.

For example, if your current version is `1.0.0` and you want to release the version `1.1.0` you can do:

```bash
$ bumped release 1.1.0

success	: Releases version '1.1.0'.
```

or, if you prefer a more semantic semver way to do the same you can do:

```bash
$ bumped release minor

success	: Releases version '1.1.0'.
```

### .add

In the beginning **Bumped** automatically  detect common configuration files of the most popular packages managers, but maybe you need to add one manually.

For example, I want to add a new file called `component.json` that have the version setted to `2.0.0`:

```json
{
  "version": "2.0.0"
}
```

For do it, use `bumped add` command:

```bash
$ bumped add component.json

info    : Detected 'component.json' in the directory.
success	: 'component.json' has been added.
```

If you check now the `.bumpedrc` file the list of configuration files as been updated:

```cson
files: [
  "package.json"
  "component.json"
]
```

If you type now `bumped version` you can check that the share version has changed:

```bash
$ bumped version

info	: Current version is '2.0.0'.
```

Because is the most major version shared between the configuration files.

### .remove

If you decide to remove a file, just use `remove` command:

```
bumped remove component.json

info	: 'component.json' has been removed.
```

## What's next?

The really interesting in **Bumped** is the posibility to associate *hooks* before or after a release action. For example, imagine that, when you going to release a new version of your software:

- Run a grunt/gulp task for generate a build.
- Create a tagged version using `git`.
- Pushing the code in a `git` repository.
- Check if you are using dependencies with vulnerabilities using [NSP](https://nodesecurity.io).

And, basically, whatever that you want.

Because the core is stable and usable, I decided release early without this feature, but only need a little of time!

## License

MIT © BumpedJS
