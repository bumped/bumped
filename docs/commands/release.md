# .release

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
