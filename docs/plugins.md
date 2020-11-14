# Plugins

They are actions that will be executed every time that you release a new version of your project.

## Declaration

When you declare a plugin under the `plugins` path at your `.bumpedrc`, you are creating a step to be executed before or after you release a new version.

Plugins can be used as `prereleases` and `postrelease` steps interchangeably: You can put it in the step that you need it.

In all the cases, the plugin declaration is formed by the description message of the step and the plugin that you want to use.

```YAML
plugins:
  prerelease:
    Say hello:
      plugin: bumped-terminal
      command: echo Hello my friend!
```

The rest of information, (in this example, `command`) depends of the specific plugin used.

## Execution

Every time that you release a new version, plugins will be executed.

Also, As you can imagine, the workflow will be:

- Execute `prerelease` plugins.
- Increment the current version.
- Execute `postrelease` plugins.

Plugins are executed on series. Under the words, this means:

- Order is important (or not): first plugin declared will be first plugin to be executed.
- If a plugin have a unexepected exit, it stop the pipeline and the release process.

## Available plugins

| Name                                                           | Description                                             |
|----------------------------------------------------------------|---------------------------------------------------------|
| [bumped-terminal](https://github.com/bumped/bumped-terminal)   | Executes whatever terminal command.                     |
| [bumped-changelog](https://github.com/bumped/bumped-changelog) | Auto generates a changelog file in each bump.           |
| [bumped-finepack](https://github.com/bumped/bumped-finepack)   | Lints your JSON Config files and keep them readables.   |
| [bumped-http](https://github.com/bumped/bumped-http)           | Expose an HTTP Client to interact with API's endpoints. |
| [bumped-gh-pages](https://github.com/bumped/bumped-gh-pages)   | Publishing files on GitHub Pages.                       |

## Write a plugin!

A plugin is a simple interface for connect thid party software with bumped workflow.

First need to define the API for your plugin, for example:

```yaml
Say Hello:
  plugin: bumped-echo
  message: 'hello world'
```

Here we are defining `bumped-echo` plugin that output a `message`.

Now, write the necessary code for do the task:

```js
/**
 * bumped-echo, print a message in your terminal
 * @param  {Object}   bumped
 * @param  {Object}   plugin        
 * @param  {Object}   plugin.opts   
 * @param  {Object}   plugin.title  
 * @param  {Object}   plugin.logger
 * @param  {Object}   plugin.path
 * @param  {Function} cb
 */
module.exports = function(bumped, plugin, cb) {
  const {message} = plugin.opts
  console.log(message)
  cb()
}
```
