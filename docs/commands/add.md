# .add

It's used to add configuration file under `files` path of `.bumpedrc`.

In the beginning, **Bumped** automatically detects common configuration files from the most popular packages managers, but you may need to add one manually.

For example, I want to add a new file called `component.json` that which version setted to `2.0.0`:

```json
{
  "version": "2.0.0"
}
```

I can be done using `bumped add`:

```bash
$ bumped add component.json

info    : Detected 'component.json' in the directory.
success	: 'component.json' has been added.
```

If you check now the `.bumpedrc` file, the list of configuration files has been updated:

```yaml
files:
  - package.json
  - component.json
```

If you type now `bumped version`, you can check that the shared version has changed:

```bash
$ bumped version

info	: Current version is '2.0.0'.
```

The version is set to `2.0.0` because it's the major version between all the configuration files.
