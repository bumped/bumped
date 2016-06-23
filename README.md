# Bumped

<h1 align="center">
  <br>
  <img src="http://i.imgur.com/DmMbFwL.png" alt="bumped">
  <br>
  Makes easy release software.
  <br>
  <br>
</h1>

<p align="center">
  <img src="https://img.shields.io/github/tag/bumped/bumped.svg?style=flat-square" alt="Last version"> <a href="https://travis-ci.org/bumped/bumped"><img src="http://img.shields.io/travis/bumped/bumped/master.svg?style=flat-square" alt="Build Status"></a> <a href="https://coveralls.io/github/bumped/bumped"><img src="https://img.shields.io/coveralls/bumped/bumped.svg?style=flat-square" alt="Coverage Status"></a> <a href="https://paypal.me/kikobeats"><img src="https://img.shields.io/badge/donate-paypal-blue.svg?style=flat-square" alt="Donate"></a><br><a href="https://david-dm.org/bumped/bumped"><img src="http://img.shields.io/david/bumped/bumped.svg?style=flat-square" alt="Dependency status"></a> <a href="https://david-dm.org/bumped/bumped#info=devDependencies"><img src="http://img.shields.io/david/dev/bumped/bumped.svg?style=flat-square" alt="Dev Dependencies Status"></a> <a href="https://www.npmjs.org/package/bumped"><img src="http://img.shields.io/npm/dm/bumped.svg?style=flat-square" alt="NPM Status"></a>
</p>

Bumped is a release system that make easy perform actions **before** and **after** release a new version of your software.

## Installation

```bash
npm install bumped -g
```

## First steps

When you start a new project, run `bumped init`.

It creates a configuration file called `.bumpedrc` associated with your project where your releases steps will be declared.

The configuration file has divided in 3 sections:

- Files that will be increment the version.
- Steps to do **before** increment the version
- Steps to do **after** increment the version

For example, a typical `.bumpedrc` file will do:

- Before increment the project version, do a set of actions related with the integrity of the project: Run tests, lint files, check for unstaged changes, etc.
- Increment the project version in all necessary files, for example, at `package.json` and `bower.json`.
- After that, do actions mostly related with the publishing process: Publish a new git tag on GitHub, publish new bower/NPM project version.

Now, next time that you run `bumped release <major|minor|patch>` it performs all the releases steps.

<p align="center">
  <img src="https://i.imgur.com/GUmrIgB.gif" alt="bumped">
</p>

## Why?

- Separates the processes of creating and publishing software.
- Syncronizes, unifies and publishes different software versions into the different package managers.
- Easy to integrate it with both with your current and new projects.
- Provide a plugin system for associate action before and after release your software.

**Bumped** synchronizes your software version across different package manager configuration files (npm, bower,...) and controls, edits and releases each of its versions to ensure all the files have the same version.

Because writing software is hard enough, we must make the publishing process of software simple and effective.

Consider read this excellent list of articles for expand your vision about releasing process:

* [Semantic Pedantic by Jeremy Ashkenas](https://gist.github.com/jashkenas/cbd2b088e20279ae2c8e).
* [Maintaining Open Source Projects by thoughtbot](https://robots.thoughtbot.com/maintaining-open-source-projects-versioning).
* [Software Versions are Broken by Eric Elliot](https://medium.com/javascript-scene/software-versions-are-broken-3d2dc0da0783#.wvzd0qcp8).
