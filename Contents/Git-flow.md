---
title: Git flow
date: 2020-07-08 11:41:06
categories:
- Git
tags:
- Git
---

# Git flow

## Initialization

Initialize the repository:

```shell
$ git init
```

Create the `develop` branch with the initialization of project:

```shell
$ git checkout -b develop
```



## Delete the history and rebuild

Deleting the `.git` folder may cause problems in the git repository. If you want to delete all commit history but keep the code in the current state, you can safely do this in the following way:

```shell
$ git checkout --orphan latest_branch
Create a new empty branch alled latest_branch.
$ git add -A
Add all files.
$ git commit -am "commit message"
Submit the files or changes.
$ git branch -D master
Delete the old master branch.
$ git branch -m master
Rename this new branch as master branch
$ git push -f origin master
Update the remote repository forcely.
```



## Feature branches

进行某 feature 开发:

```shell
$ git checkout -b myfeature develop
```

开发完成后回到 `develop` 分支:

```shell
$ git checkout develop
```

合并 `myfeature` 分支到 `develop` 分支的同时, 并不删除 `myfeature` 的 `commit` 记录:

```shell
$ git merge --no-ff myfeature
```

删除某 feature 这个分值, 如果这个 feature 之后还有开发的倾向, 比如我们学习一门课程, 后续还会继续学习, 记录和修改, 那么久不要删除这个分支:

```shell
$ git branch -d myfeature
```

推送 develop 分支以供其他人使用:

```shell
$ git push origin develop
```



## Release branches

Create a new branch `release-1.2` from develop branch and get switched to release branch:

```shell
$ git checkout -b release-1.2 develop
```

Files modified successfully. Add and commit changes to this release branch:

```shell
$ ./bump-version.sh 1.2
Files modified successfully, version bumped to 1.2.
$ git commit -a -m "Bumped version number to 1.2"
[release-1.2 74d9424] Bumped version number to 1.2
1 files changed, 1 insertions(+), 1 deletions(-)
```

Finish the release branch. Switched to branch `master`:

```shell
$ git checkout master
```

Merge the release branch with commit histories:

```
$ git merge --no-ff release-1.2
```

Tag the status for future reference:

```shell
$ git tag -a 1.2
```

You might as well want to use the `-s` or`-u <key>` flags to sign your tag cryptographically.

To keep the changes made in the release branch, we need to merge those back into develop, though. In Git:

```shell
$ git checkout develop
Switched to branch 'develop'

$ git merge --no-ff release-1.2
Merge made by recursive.
(Summary of changes)
```


This step may well lead to a merge conflict (probably even, since we have changed the version number). If so, fix it and commit.

Now we are really done and the release branch may be removed, since we don’t need it anymore:

```shell
$ git branch -d release-1.2
Deleted branch release-1.2 (was ff452fe).
```



# Personal specification

## Branches

- master
- develop
- feature branches
- release branches
- hotfix branches

## commit type
type 是用于说明该 commit 的类型的, 一般我们会规定 type 的类型如下:

- feat 新特性 feature
- fix 修改 but
- refactor 代码重构. 既不是新增功能, 也不是修改 bug 的代码变动
- docs 文档修改 documents
- style 代码格式修改, 不影响代码运行的格式变动, 注意不是指 CSS 的修改
- test 提交测试代码 (单元测试，集成测试等)
- chore 其他修改, 比如构建流程, 依赖管理.
- misc 一些未归类或不知道将它归类到什么方面的提交

## commit scope 
scope commit 影响的范围, 比如数据层, 控制层, 视图层等等. 这个需要视具体场景与项目的不同而灵活变动, 对于工作中比如: 

- route
- component
- utils
- build

对于学习中比如:

- notes
- codes
- projects

## commit subject
subject commit 的概述, 建议符合 50/72 formatting

使用第一人称现在时的动词开头, 比如 modify 而不是 modified 或 modifies.
首字母小写, 并且结尾不加句号.

## commit body
body 其实就是 subject 的详细说明, 可以分为多行, 建议符合 50/72 formatting

## commit footer
footer 一些备注, 通常是 BREAKING CHANGE 或修复的 bug 的链接.

## commit cz template

For work:

```js
  
'use strict';

module.exports = {

  types: [
    {
      value: '💪WIP',
      name : '💪  WIP:      Work in progress'
    },
    {
      value: '✨feat',
      name : '✨  feat:     A new feature'
    },
    {
      value: '🐞fix',
      name : '🐞  fix:      A bug fix'
    },
    {
      value: '🛠refactor',
      name : '🛠  refactor: A code change that neither fixes a bug nor adds a feature'
    },
    {
      value: '📚docs',
      name : '📚  docs:     Documentation only changes'
    },
    {
      value: '🏁 test',
      name : '🏁  test:     Add missing tests or correcting existing tests'
    },
    {
      value: '🗯chore',
      name : '🗯  chore:    Changes that don\'t modify src or test files. Such as updating build tasks, package manager'
    },
    {
      value: '💅style',
      name : '💅  style:    Code Style, Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)'
    },
    {
      value: '⏪revert',
      name : '⏪  revert:   Revert to a commit'
    }
  ],

  scopes: [],

  allowCustomScopes: true,
  allowBreakingChanges: ["feat", "fix"]
};
```

For learning:

```js
  
'use strict';

module.exports = {

  types: [
    {
      value: '💪WIP',
      name : '💪  WIP:      Work in progress'
    },
    {
      value: '📚docs',
      name : '📚  docs:     Documentation only changes'
    },
    {
      value: '🧑‍💻codes',
      name : '🧑‍💻  codes:    Some new codes'
    },
    {
      value: '⛑projects',
      name : '⛑  projects: A new project'
    },
    {
      value: '💼files',
      name : '💼  files:    Some configuration or backup files'
    },    
    {
      value: '✨feat',
      name : '✨  feat:     A new feature'
    },
    {
      value: '🐞fix',
      name : '🐞  fix:      A bug or mistake fix'
    },
    {
      value: '🛠refactor',
      name : '🛠  refactor: A code or structure change that neither fixes a bug nor adds a feature'
    },
    {
      value: '🏁test',
      name : '🏁  test:     Add missing tests or correcting existing tests'
    },
    {
      value: '🗯chore',
      name : '🗯  chore:    Changes that don\'t modify src or test files. Such as updating build tasks, package manager'
    },
    {
      value: '💅style',
      name : '💅  style:    Code Style, Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)'
    },
    {
      value: '⏪revert',
      name : '⏪  revert:   Revert to a commit'
    }
  ],

  scopes: [],

  allowCustomScopes: true,
  allowBreakingChanges: ["feat", "fix"]
};
```



# References

1. [A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/)
2. [Understanding the GitHub flow](https://guides.github.com/introduction/flow/)
3. [实际项目中如何使用Git做分支管理](https://zhuanlan.zhihu.com/p/38772378)
4. [开眼了，腾讯是如何使用 Git？](https://zhuanlan.zhihu.com/p/143941172)
5. [Git summary blog article](http://www.mtmn.top/archives/git)