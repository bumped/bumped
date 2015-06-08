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

- Separates the processes of creating and publishing software.
- Syncronizes, unifies and publishes different software versions into the different package managers.
- Easy to integrate it with both with your current and new projects.
- Associated actions before or after publishing your software *(not yet, but soon!)*.

**Bumped** synchronizes your software version across different package manager configuration files (npm, bower,...) and controls, edits and releases each of its versions to ensure all the files have the same version.

Because writing software is hard enough, we must make the publishing process of software simple and effective.

## Install

```bash
npm install bumped -g
```

## Usage

### .init

The first command that you need to run is `bumped init`. If you run it in a totally blank project, you'll see something like this:

```bash
$ bumped init

warn  : It has been impossible to detect files automatically.
warn  : Try to add manually with 'add' command.
warn  : There isn't version declared.
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

The file format is [CSON](https://github.com/bevry/cson). You can also use JSON format, however, this file is auto-generated by **Bumped**.

### .version

If you're not sure what the current synchronized version across your configuration files, then run `bumped version`:

```bash
$ bumped version

info	: Current version is '1.0.0'.
```

The shared version is the major version detected in them. On the other hand, it will not be syncrhonized until the next release.

### .release

It's moment to release a new version of your sofware. You can do this in two different ways:

- Providing the exact version that you want to release.

- Providing the semantic semver version to release (using the keywords `major`, `minor`, `patch`,...

In both cases, the only requisite is that the version to be released has to be major than the current version.

For example, if your current version is `1.0.0` and you want to release to the version `1.1.0`, you can do:

```bash
$ bumped release 1.1.0

success	: Releases version '1.1.0'.
```

Or, if you prefer a more semantic semver way to do the same, you simply can do:

```bash
$ bumped release minor

success	: Releases version '1.1.0'.
```

### .add

In the beginning, **Bumped** automatically detects common configuration files from the most popular packages managers, but you may need to add one manually.

For example, I want to add a new file called `component.json` that which version setted to `2.0.0`:

```json
{
  "version": "2.0.0"
}
```

I can be done typing `bumped add`:

```bash
$ bumped add component.json

info    : Detected 'component.json' in the directory.
success	: 'component.json' has been added.
```

If you check now the `.bumpedrc` file, the list of configuration files has been updated:

```cson
files: [
  "package.json"
  "component.json"
]
```

If you type now `bumped version`, you can check that the shared version has changed:

```bash
$ bumped version

info	: Current version is '2.0.0'.
```

The version is setted to 2.0.0 because it's the major version between all the configuration files.

### .remove

If you decide to remove a file, just use the `remove` command:

```
$ bumped remove component.json

info	: 'component.json' has been removed.
```

### .set

Sometimes you need to update a determinate property in the configuration files. No more edit files manually!

```
$ bumped set name simple-average

success : Property 'name' set.
```

In this case, `name` is a plain property in the JSON, but you can update nested object properties as well providing the object path:

```
$ bumped set author.name Kiko Beats

success : Property 'author.name' set.
```

or Arrays values:

```
bumped set keywords "[average, avg]"

success	: Property 'keywords' set.
```

Note that this setup the property across all the files.

## What's next?

The most interesting aspect in **Bumped** is the posibility to associate *hooks* before or after a release action. Usually, every time you releases a new version of your software, you always have to accomplish several tasks:

- Run a grunt/gulp task to generate a build.
- Lint the code.
- Create a tagged version using `git`.
- Push the code to a `git` repository.
- Check if you are using dependencies with vulnerabilities using [NSP](https://nodesecurity.io).

And, basically, whatever that you need.

Due to the core is stable and usable, I decided to release early without this new feature. I just need a little bit of time!

## License

MIT © BumpedJS
