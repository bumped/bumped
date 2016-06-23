# Plugins

They define the way you connect your releases steps with third party software.

## How to use it

Basically a plugin is a façade around a third party software to make easy the connection between your project and the third party software.

Plugins are declared in the `plugins` section of your `.bumpedrc`.


```YAML
plugins:
  prerelease:
    'Say hello':
      plugin: 'bumped-terminal'
      command: 'echo Hello my friend!'
```

First of all, plugins are used as `prereleases` and `postrelease` interchangeably. So, you can put the plugin where you need.

Second, the plugin declaration is formed by the description message of the step and the plugin that you want to use.

The rest of information, (in this example, `command`) depends of the specific plugin used.

## Running process



## Handling Exceptions


## Available plugins

| Name                                                           | Description                                             |
|----------------------------------------------------------------|---------------------------------------------------------|
| [bumped-terminal](https://github.com/bumped/bumped-terminal)   | Executes whatever terminal command.                     |
| [bumped-changelog](https://github.com/bumped/bumped-changelog) | Auto generates a changelog file in each bump.           |
| [bumped-finepack](https://github.com/bumped/bumped-finepack)   | Lints your JSON Config files and keep them readables.   |
| [bumped-http](https://github.com/bumped/bumped-http)           | Expose an HTTP Client to interact with API's endpoints. |

## Write a plugin!

*SOON*
