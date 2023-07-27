---
title: "Importing local directory as a package in NPM🐁"
date: 2023-07-27T20:44:54+04:00
draft: false
---


Sometimes, we need to modify third-party libraries for our projects, but we don't want to publish the changes as public packages. Both NPM and Yarn offer a simple solution to import a local directory as a package, allowing us to make modifications without the hassle of publishing.


Let's say we have package called `foo-pack`
Using NPM:

- pull the package to project root directory
- navigate to the directory `cd foo-pack`
- install all dependencies `npm install` or `yarn`
- remove package.lock `rm package.lock` or `rm yarn.lock`
- modify package.json so it doesn't contain link to the package
```json
{
    "name": "foo-pack",
    "version": "3.76.0",
    "description": "foo description",
    "author": "foo",
    // remove this part below from json 👇️
    "repository": {
        "type": "git",
        "url": "https://github.com/foo-pack/foo-pack"
    },
    // remove this part above from json ☝️
    "license": "Apache-2.0",
    ...
}
```
- run install again in order to generate correct lock files 
  - `npm install` or `yarn` 
- go to your project directory 
  - `cd ..`
- add foo-pack to your package 
  - `npm install --save ./foo-pack` or `yarn add file:./foo-pack`
- now if we go to our package json we can easily find

```json
    ...
    "dependencies": {
        ...
        "foo-pack": "file:./foo-pack",
        ...
    },
    ...
```
### 🎊 TADA 🎉

Benefits:

1. Flexibility: Customize libraries for your project without restrictions.
2. Real-time Updates: Changes are immediately reflected in your project.
3. Isolation: Keep changes local, avoiding unintended bugs in other projects.
4. Version Management: Easily switch back to the original version if needed.



### Remember to document all the changes and/or use the mighty git. 🌳