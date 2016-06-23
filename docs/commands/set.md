# .set

Sometimes you need to update a determinate property in the configuration files. No more edit files manually!

```bash
$ bumped set name simple-average

success : Property 'name' set.
```

In this case, `name` is a plain property in the JSON, but you can update nested object properties as well providing the object path:

```bash
$ bumped set author.name Kiko Beats

success : Property 'author.name' set.
```

or Arrays values:

```bash
$ bumped set keywords "[average, avg]"

success	: Property 'keywords' set.
```

Note that this setup the property across all the files.
