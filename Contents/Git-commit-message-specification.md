---
title: Git commit message specification
date: 2020-07-02 11:38:43
categories:
- Git
tags:
- Git
- Software
---

# Background

A  commit message (commit description) is mandatory everytime you commit code with Git. We can use below command to write brief messages:

```bash
$ git commit -m "hello world"
```

You can just execute `git commit` to write more lines of messages. It will jump out of the text editor allowing you to write multiple lines.

**What can git messages do?**

With `git log` command you can get as much information as you want:

**I:**

Provide more historical information for easy and quick browsing.

Use below command to easily look through the HEAD messages of every commit:

```bash
git log <last tag> HEAD --pretty=format:%s
```

You can also use `tig` to do so which is a very effiecient [git tool](https://github.com/jonas/tig) on mac. 

**II:**

Quckly look for specific commit  by adding `-- grep XXX`.

```bash
$ git log HEAD --grep WIP
```

Then you get below output:

![image-20200702095943860](https://strawberryamoszc.oss-cn-shanghai.aliyuncs.com/img/image-20200702095943860.png)

**III: Change log can be generated directly from the commit.**

Change log is a documentation used to explain the difference with the previous version when a new version is released. 



# Git Message Format

目前规范使用较多的是 [Angular](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines) 团队的规范, 继而衍生了 [Conventional Commits specification](https://www.conventionalcommits.org/en/v1.0.0/). 很多工具也是基于此规范, 它的 message 格式如下:

```text
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

标题行: 必填, 描述主要修改类型和内容
主题内容: 描述为什么修改, 做了什么样的修改, 以及开发的思路等等
页脚注释: 放 Breaking Changes 或 Closed Issues

分别由如下部分构成:

- `type` 是用于说明该 commit 的类型的, 一般我们会规定 type 的类型如下:
  - `feat` 新特性 feature
  - `fix` 修改 but
  - `refactor` 代码重构. 既不是新增功能, 也不是修改 bug 的代码变动
  - `docs` 文档修改 documents
  - `style` 代码格式修改, 不影响代码运行的格式变动, 注意不是指 CSS 的修改
  - `test` 提交测试代码 (单元测试，集成测试等)
  - `chore` 其他修改, 比如构建流程, 依赖管理.

  - `misc` 一些未归类或不知道将它归类到什么方面的提交
- `scope` commit 影响的范围, 比如数据层, 控制层, 视图层等等, 这个需要视具体场景与项目的不同而灵活变动, 比如: route, component, utils, build...
- `subject` commit 的概述, 建议符合  50/72 formatting
  - 使用第一人称现在时的动词开头, 比如 modify 而不是 modified 或 modifies.
  - 首字母小写, 并且结尾不加句号.
- `body` 其实就是 subject 的详细说明, 可以分为多行, 建议符合 50/72 formatting
- `footer` 一些备注, 通常是 BREAKING CHANGE 或修复的 bug 的链接.

你可以为 git 设置 commit template, 每次 `git commit` 的时候在 vim 中带出. 修改 `~/.gitconfig`, 添加:

```shell
[commit]
template = ~/.gitmessage
```

新建 `~/.gitmessage` 内容可以如下:

```bash
# head: <type>(<scope>): <subject>
# - type: feat, fix, docs, style, refactor, test, chore
# - scope: can be empty (eg. if the change is a global or difficult to assign to a single component)
# - subject: start with verb (such as 'change'), 50-character line
#
# body: 72-character wrapped. This should answer:
# * Why was this change necessary?
# * How does it address the problem?
# * Are there any side effects?
#
# footer: 
# - Include a link to the ticket, if any.
# - BREAKING CHANGE
#
```



# Commitizen

我们可以使用 `commitizen` 这个工具自动, 方便地按要求生成合规的 commit message. 

我们需要借助 [commitizen/cz-cli](https://github.com/commitizen/cz-cli) 提供的 `git cz` 命令替代我们的 `git commit` 命令, 帮助我们生成符合规范的 commit message.

除此之外, 我们还需要为 commitizen 指定一个 Adapter 比如: [cz-conventional-changelog](https://github.com/commitizen/cz-conventional-changelog).  这是一个符合 Angular 团队规范的 preset. 使得 commitizen 按照我们指定的规范帮助我们生成 commit message.



## Installation

首先你需要下载 Node.js, 你可以下载淘宝镜像 `cnpm` 来获得之后更好的安装和下载体验, 详细安装请参考[这篇文章](http://zhangchao.top/2020/05/04/%E4%BB%A5Hexo%E6%A1%86%E6%9E%B6%E8%85%BE%E8%AE%AF%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E6%90%AD%E5%BB%BA%E5%8D%9A%E5%AE%A2%E8%AE%B0%E5%BD%95/#%E5%AE%89%E8%A3%85%E4%BE%9D%E8%B5%96).

### Globally

以下代码为下载安装, 使用 `cnpm` 的可以将 `npm` 替换为 `cnpm`:

```bash
npm install -g commitizen cz-conventional-changelog
```

下载好之后需要指定一个 Adapter:

```bash
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
```

### Project Level Installation

```bash
npm install -D commitizen cz-conventional-changelog
```

同理在下载的 `package.json` 中配置:

```json
"script": {
    ...,
    "commit": "git-cz",
},
 "config": {
    "commitizen": {
      "path": "node_modules/cz-conventional-changelog"
    }
  }
```

如果全局安装过 commitizen, 那么在对应的项目中执行 `git cz` 或者 `npm run commit` 都可以.



# Custom Ataptor

如果 Angular 的规范不符合我们的习惯, 那么可以通过指定 Adapter [cz-customizable](https://github.com/leonardoanalista/cz-customizable) 指定一套符合自己团队的规范. 全局或项目级别安装:

```bash
# globally
npm i -g cz-customizable

# project level
npm i -D cz-customizable
```

同样地, 修改 `~/.czrc` 或项目下的 `package.json` 中的 `config` 为:

```json
{ "path": "cz-customizable" }
or
  "config": {
    "commitizen": {
      "path": "node_modules/cz-customizable"
    }
  }
```

同时在 `~` 或项目目录下创建 `.cz-config.js` 文件, 维护你想要的格式. 比如我的配置文件: [.cz-config.js](https://github.com/agoclover/code_learn/blob/master/10_Git/.cz-config.js)

你可以按照自己喜欢的方式修改此文档, 比如可以参考 [gitmoji](https://gitmoji.carloscuesta.me/) 来添加符合规范的 emoji 来使得每次提交的 commit message 更加直观.



# Demo

配置好之后就可以愉快的使用了, 比如我将整理了一半的 log4j 笔记进行提交, 在提交阶段不再使用 `git commit` 命令而是使用 `git cz`. 之后会一次选择 1 提交类型, 2 填写影响范围 SCOPE, 3 主题, 4 可选的详细信息和 5 可选的问题修复链接等:

```bash
$ git cz
cz-cli@4.1.2, cz-customizable@6.2.0



Line 1 will be cropped at 100 characters. All other lines will be wrapped after 100 characters.

? Select the type of change that you're committing: 💪  WIP:      Work in progress
? Denote the SCOPE of this change: notes
? Write a SHORT, IMPERATIVE tense description of the change:
 log4j 笔记整理.
? Provide a LONGER description of the change (optional). Use "|" to break new line:

? List any ISSUES CLOSED by this change (optional). E.g.: #31, #34:
```

全部选择或输入后, 会自动生成一条 commit message 信息, 并由你确认:

```bash
###--------------------------------------------------------###
💪WIP(notes): log4j 笔记整理.
###--------------------------------------------------------###

? Are you sure you want to proceed with the commit above? Yes
[master e3a88a4] 💪WIP(notes): log4j 笔记整理.
 1 file changed, 5 insertions(+), 3 deletions(-)
```

当然你也可以使用像 commitlint 这样的校验工具从工具层面上来强制执行某些规范.这里就不展开讲了, 有兴趣的读者可以查阅相关资料并使用到自己团队的实践中.

# References

1. [阮一峰 - Commit message 和 Change log 编写指南](https://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)

2. [阿里南京技术专刊 - 优雅的提交你的 Git Commit Message](https://juejin.im/post/5afc5242f265da0b7f44bee4)

