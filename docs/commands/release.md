# .release

It's used for release a new version of your project.

The purpose of this command is increment the value under the `version` field of your `files` declared at `.bumpedrc`.

When you want to release a new version, you need to specify a high new version of your project.

For do that, we can follow different approach:

## Semver

This is the classic way. You have to provide the keyword that increment the `X`,`Y` or `Z` version of your `X.Y.Z` version declared.

In this mode, you can also create prebuilds. Are the keywords availables in this mode are:

```
bumped release <major|premajor|minor|preminor|patch|prepatch|prerelease>
```

## Numerical

Providing the exact version that you want to release.

It's similar to semver approach, but specifying using numbers the version to be released.

It's aligned with the pattern:

```
bumped release <[0-9].[0-9].[0-9]>
```

## Nature

It's a modification of the semver version focusing in a more semantic keywords.

```
bumped release <breaking|feature|fix>
```

The following example is equivalent between the three approaches

```bash
$ bumped release 2.0.0
$ bumped release major
$ bumped release breaking
```

Where in all the cases the message will be:

```bash
success	: Releases version '2.0.0'.
```
