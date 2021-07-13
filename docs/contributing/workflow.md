Development workflow
====================

This document describes the common development workflow and important points related to it.

1. [Glossary][p:glossary]
2. [Repository requirements][p:repository-requirements]
    1. [Files][p:repository-files]
        - [Naming][p:files-naming]
        - [Layout example][p:layout-example]
        - [Changelog][p:changelog]
        - [Readme][p:readme]
        - [Contribution guide][p:contribution-guide]
    2. [Branches and tags][p:branches-and-tags]
        - [Branch naming][p:branch-naming]
        - [Tag naming][p:tag-naming]
    3. [Merging][p:merging]
        - [Squash merging steps][p:squash-steps]
    4. [Commits][p:commits]
        - [FCM (final commit message)][p:fcm]
    5. [Pushing][p:pushing]
3. [Project requirements][p:project-requirements]
    1. [Issues][p:issues]
    2. [MRs (merge requests)][p:MRs]
    3. [Labels][p:labels]
    4. [Milestones][p:milestones]
4. [Workflow][p:workflow]
    1. [Development][p:development]
        - [Multiple reviews][p:multiple-reviews]
        - [Pausing][p:pausing]
        - [Temporary mainline][p:temp-mainline]
        - [Wontfix][p:wontfix]
    2. [Releasing][p:releasing]
    3. [Deployment][p:deployment]
5. [Communication][p:communication]
    1. [Coordinations][p:coordinations]
    2. [Retrospectives][p:retrospectives]
    3. [Weekly meetup][p:weekly-meetup]
    4. [Corporative chat][p:corporative-chat]
    5. [Reports][p:reports]
6. [Testing][p:testing]
    1. [E2E][p:e2e-tests]
    2. [Unit][p:unit-tests]
    3. [Integration][p:integration-tests]
    4. [Docker][p:docker-tests]
    5. [Linting][p:linting]
7. [Best practices][p:best-practices]
8. [Questions][p:questions]




## Glossary

##### Project

Everything that is related to a concrete dedicated project (codebase, issue tracker, documentation, etc.). Usually is represented as a [GitLab project] or a [GitHub repository].

##### Product

A business entity of the [project][t:project] that is sold to [end-users][t:end-user].

##### Repository

A [Git] repository of the [project][t:project] which represents its codebase.

##### Issue

A problem related to the [project][t:project] which is represented in a form of a [GitLab issue] or a [GitHub issue].

See [format requirements][p:issues].

##### MR (merge request)

A solution for the [issue][t:issue] or any other [project][t:project]-related changes which involve [repository][t:repository] modification and are represented in a form of a [GitLab MR] or a [GitHub PR].

See [format requirements][p:MRs].

##### Task

An [issue][t:issue] (and/or its [solution][t:MR]) related to the [project][t:project].

##### Developer

Any collaborator that works on the [project][t:project] (software developer, tester, DevOps, designer, etc.) and solves project [tasks][t:task].

##### Lead

A senior [developer][t:developer] which performs ~review of the [tasks][t:task] completed by [developer][t:developer].

##### Maintainer

A [developer][t:developer] who takes the general responsibility for the [project][t:project] maintaining. Each [project][t:project] has at least one [maintainer][t:maintainer].

##### Team

A [team][t:team] of [developers][t:developer] headed by a [lead][t:lead] that is responsible for maintaining some [projects][t:project]. [Lead][t:lead] is responsible to organize and curate development workflow inside his [team][t:team].

##### End-user

A person that [project][t:project] is developed for and who uses this [project][t:project] as a product.

##### Release

A concrete and fixed stable version of the [project][t:project] shipped along with the build artifacts and project's documentation. Every [release][t:release] has its own unique and protected [Git tag] in the [repository][t:repository]. Once created [release][t:release] cannot be changed in the future, only new [release][t:release] can be released.

##### Milestone

A [GitLab milestone] which tracks the completion of some [project release][t:release] and gives a brief info about it. On GitHub a [GitHub release] is used instead.

See [format requirements][p:milestones].

##### Changelog

A document stored in a [repository][t:repository] which describes notable changes of [project releases][t:release] for [end-users][t:end-user] and [developers][t:developer].

See [format requirements][p:changelog].

##### Roadmap

An [issue][t:issue] (or rarely a [MR][t:MR]) which describes steps to complete some feature or [release][t:release] and tracks its completion. Marked with a ~"type: roadmap" [label][t:label] on GitLab (or the similar one on GitHub).

##### Toolchain

A set of [software utilities][201] (tools) which are required for [project][t:project] maintaining and developing. These commonly are: compilers, transpilers, linters, documentation generators, test runners, etc. 




## [Repository][t:repository] requirements


### Files

Each [repository][t:repository] __must contain__ the following files:
- `.editorconfig` that declares common [project][t:project] code style rules for [IDEs][t:IDE];
- [`README.md`][p:readme] with a [project][t:project] overview and description;
- [`CONTRIBUTING.md`][p:contribution-guide] with an information that is important for [developers][t:developer];
- [`CHANGELOG.md`][p:changelog] that describes notable changes of each [release][t:release];
- `LICENSE.md` with a licensing info in case a [project][t:project] is licensed (usually GitHub [projects][t:project]).

And each [repository][t:repository] __must NOT contain__ (so have them [Git-ignored] to avoid accidents):
- __configuration__ files __of__ developer's __local toolchain__ (unless this configuration is suitable for all [project developers][t:developer]);
- __compilation/build results/artifacts__ of source code;
- any __caches or temporary files__;
- __configuration__ files __for running__ application (except examples or Dockerized development environment configurations which are the same for all [project developers][t:developer]).

__For keeping an empty directory__ in a [repository][t:repository] __use the `.gitkeep` file__ inside that directory.

#### Naming

__Start directory with `.`__ if it contains some __temporary files which do not require direct manipulations__ and are going to be omitted by [tools][t:toolchain] (caches, temp files, etc.). This is a quite common practice (see `.git/`, `.idea/`, `.gradle/`, etc.).  
Also, __all temporary cache files__ must be __placed inside a `.cache/`__ top-level directory of the [repository][t:repository], unless this is impossible for somewhat reasons.

__To emphasize [toolchain][t:toolchain] directories__ (ones which do not contain [project][t:project] sources itself, but rather contain files of a [project toolchain][t:toolchain]) their __name may be started with `_`__, which will make them to "bubble-up" in a [repository][t:repository] source tree, so will allow easily to distinguish them from actual [project][t:project] sources (both for [humans][t:developer] and [tools][t:toolchain]).

#### Layout example

```bash
tree -a -v --dirsfirst .
```

```tree
.
├── .cache/
│   └── cargo/
├── .git/
├── .idea/
├── _build/
│   └── artifacts/
│       ├── .dockerignore
│       ├── .gitignore
│       └── Dockerfile
├── _dev/
│   └── config.toml
├── src/
│   └── main.rs
├── .editorconfig
├── .gitignore
├── CHANGELOG.md
├── CONTRIBUTING.md
├── Cargo.lock
├── Cargo.toml
├── LICENSE.md
└── README.md
```

#### Changelog

[Changelog][t:changelog] __must describe only notable changes__ that require [end-users][t:end-user] or [developers][t:developer] attention.  
For example, changes in: UI/UX (user interface and user experience), API (application interface), deployment, documentation, [toolchain][t:toolchain].

Consider to __use relative and [permanent][106] links__ (permalinks) when referencing something, so they won't change over time.

While __entries to [changelog][t:changelog] are added by [developers][t:developer]__ via [MRs][t:MR], the __[project maintainer][t:maintainer] is responsible for keeping a [changelog][t:changelog] sound and correct__ when it comes to a creation of a new [project release][t:release].

##### Versions

All [project][t:project] versions should be __described in a descending order__ (newest are first).

Each version description __must contain__:
- __link to the [version tag][p:tag-naming]__ of the [repository][t:repository];
- __release date__ of this version;
- __link to the full diff with the previous version__ (GitLab or GitHub [`/compare` page][105]);
- __link to the [milestone][t:milestone]__ of the [project release][t:release];
- __link to the [roadmap][t:roadmap]__ of the [project release][t:release] __if it exists__;
- ~TBD __[label][t:label]__ (to-be-done) if version is __NOT released yet__.

##### Changes

All changes in [changelog][t:changelog] must be __described in four sections__:
- `BC Breaks` are changes which __break [backward compatibility][202]__. The most important ones as allow [end-users][t:end-user] and [developers][t:developer] to upgrade correctly.  
Examples: site UI total redesign, API method parameter removal, config option replacement.
- `Added` are changes which __add new features__ to the [project][t:project].  
Examples: new site page, new API method or method parameter, new config option.
- `Changed` are changes of existing features which __DO NOT break [backward compatibility][202]__.  
Examples: site page text reformulation, API method behavior improvement, config option format extension.
- `Fixed` are changes which __fix bugs, failures and other incorrectness__.  
Examples: fix of incorrect translation on site page, fix of incorrect API method parameter validation, fix of incorrect config option parsing.

Consider to __split all changes into separate categories by its application meaning__, like: `UI/UX`, `Documentation`, `Toolchain`, etc. These categories are very similar to `kind: ` [GitLab labels][t:label] (~"kind: UI/UX", ~"kind: toolchain", etc), but are not restricted to be the same. Doing this allows to read and understand [changelog][t:changelog] much quicker and better as structures provided information.

To simplify navigation and investigation each change __must contain [references][103] to related [MRs][t:MR] and [issues][t:issue]__ (or commits when there is no [issue][t:issue] or [MR][t:MR]).

##### Deployment instructions

If a [project release][t:release] __requires additional manual steps to be deployed__ (something more than ordinary version update) when upgrading from a previous version, then these __steps must be explicitly described in the separate `Deployment` section__ of the version description __as a numbered list__ (preserving the required actions order).

Such steps commonly represent:
- database schema/data changes (all required queries must be posted if [project][t:project] has no [migrations][203]);
- cron job changes;
- application configuration changes;
- server cache cleaning requirement;
- and so on...

##### Example

See the full featured [example changelog file][changelog example] and its [rendered][changelog example rendered] view (beware that links won't work inside due to an example, but in real [changelogs][t:changelog] they must work).

#### Readme

`README.md` file is an entrypoint to a [project][t:project] for any [developer][t:developer] or [end-user][t:end-user]. That's why it __must contain all required links__ to [project's][t:project] documentation, [contribution guide][p:contribution-guide], [changelog][t:changelog], alternative resources, etc.

Whenever it's possible __use [GitLab/GitHub badges][112] to reflect the current [project][t:project] status__ (latest [release][t:release] version, [CI pipeline][111] status, code coverage, etc).

If a [project][t:project] has no dedicated documentation, then `README.md` file must act as one containing all required and meaningful information for [end-users][t:end-user] and [developers][t:developer].

#### Contribution guide

`CONTRIBUTING.md` file __must contain [project][t:project]-specific development requirements and instructions__, these can be:
- overrides and extensions of a [common code style][code style];
- additional [workflow][p:workflow] steps required by [project][t:project];
- instructions of how to run [project][t:project] for easier on-boarding for newbies;
- and so on...

Working on a [project][t:project] a __[developer][t:developer] must consider and follow all requirements imposed by its [contribution guide][p:contribution-guide]__.


### Branches and tags

Every [repository][t:repository] contains the following branches:

- `master` - __mainline version__ of the [project][t:project]. Any new [project release][t:release] is usually created from this branch. Developing directly in this branch is forbidden. It __accepts new changes via [MRs (merge requests)][t:MR]__.

- `release` - optional [protected branch][102] that points to the latest [release][t:release] of the [project][t:project]. Usually it is __maintained automatically__ or manually by the [project maintainers][t:maintainer], so common [developers][t:developer] would not operate with this branch at all.

Also, for GitLab [repositories][t:repository] (and only for them) every __[Git tag] which starts with `v`__ symbol is [protected][101] (so only [maintainers][t:maintainer] can operate with it) and __represents a concrete [project release][t:release]__.

Any other possible branches and tags can be created and used by [developers][t:developer] as they need, unless some [project][t:project]-specific rules (described in a [contribution guide][p:contribution-guide]) do not forbid that.

#### Branch naming

[Git] branch name __must__ meet the following requirements:
- consist of __English words__;  
    👍 `fix-tests-failure`  
    🚫 `fix-defectum-probat`
- use __only dashes to separate words__;  
    👍 `fix-tests-failure`  
    🚫 `fix_tests_failure`
- use __[imperative mood][200] for verbs__;  
    👍 `fix-tests-failure`  
    🚫 `fixes-tests-failure`
- __start with the [issue][t:issue] number__ when branch is related to some [issue][t:issue] (but __DO NOT use [MR][t:MR] numbers__);  
    👍 `23-fix-tests-failure`  
    🚫 `fix-tests-failure`
- __reflect the meaning of branch changes__, not the initial problem.    
    👍 `23-fix-tests-failure`  
    🚫 `23-problem-with-failing-tests`

#### Tag naming

Version [tag][Git tag] directly __depends on a project versioning scheme__ (usually [Semantic Versioning 2.0.0]) and __must be the [project release][t:release] version__.  
👍 `2.3.1`, `v5.3.11-alpha.3`  
🚫 `2.3.1-release`, `release-5.3.11-alpha.3`

__For GitLab__ [repositories][t:repository] version [tag][Git tag] __must start with `v` symbol__ to match `v*` [protection mask][101].  
👍 `v1.2.4`, `v2.3.1-beta.4`  
🚫 `1.2.4`, `2.3.1-beta.4`

Any other __non-version [tags][Git tag]__ may be named fluently, but __must follow the [branch naming rules][p:branch-naming]__.


### Merging

__All merges to the mainline__ [project][t:project] version (`master` branch) __must have an individual [MR (merge request)][t:MR]__ and must be __done only in [fast-forward] manner__. This is required to keep mainline history linear, simple and clear.

__The only exception__ is __merging two mainline branches__, because we want to preserve histories of both mainline branches (one of them is usually a [temporary mainline][p:temp-mainline] required for implementing multiple steps separately from a base mainline).

To achieve [fast-forward merge][fast-forward], __all branch commits__ (which doesn't exist in mainline) __must be squashed and rebased onto the latest mainline commit__. Notable moments are:
- Before rebase __do not forget to merge your branch with latest mainline branch updates__, otherwise rebase result can broke changes.
- To perform rebase and squash safely, and not to lose any changes, the __`git merge --squash` must be used__. It's proven and stable way to squash changes, while `git rebase` can be unexpectedly messy with [merge commits][11] (discussed [here][12] in details).
- __After rebase__ you should __use `git push --force` to correctly update your remote branch__.

__Use `Merge when pipeline succeeds` button in GitLab__ for merging, as far as it performs [fast-forward] merges and removes a necessity to wait until [CI pipeline][111] is finished.

#### Squash merging steps

1.  Rename your branch:

    ```bash
    git branch -m my-branch orig-my-branch
    ```
    
2.  Create your branch again from the latest mainline:

    ```bash
    git checkout dev
    git checkout -b my-branch
    ```
    
3.  Apply all required changes from your branch:

    ```bash
    git merge --squash orig-my-branch
    ```
    
4.  Commit those changes.

5.  Delete the temporary branch:

    ```bash
    git branch -d orig-my-branch
    ```

Performing these steps every time manually can be quite annoying. That's why each [repository][t:repository] usually contains `squash` entry of `Makefile`, which automates these operations.

```bash
make squash

# or for temporary mainline:
make squash onto=temp-mainline
```


### Commits

Every __commit message must contain a short description__ of its changes that meet the following requirements:
- be __on English__ (no other language is allowed);
- __start with a capital letter__;
- has __no punctuation symbols at the end__ (like `;`, `:` or `.`);
- use __[imperative mood][200] for verbs__ (as if you are commanding someone: `Fix`, `Add`, `Change` instead of `Fixes`, `Added`, `Changing`);
- use __marked list for multiple changes__, prepended by __one summary line__ and __one blank line__, where each __list item__ must:
    - __start with a lowercase letter__;
    - has __no punctuation symbols at the end__.

##### 👍 Single-line commit message example

```
Update Employee salary algorithm
```

##### 👍 Multiple-line commit message example

```
Implement employees salary and ajax queries

- update Employee salary algorithm
- remove unused files from public/images/ dir
- implement ajax queries for /settings page
```

##### 🚫 Wrong commit message examples

- Summary line starts with a lowercase letter:

    ```
    update Employee salary algorithm
    ```

- Verb is not in the [imperative mood][200]:

    ```
    Updates Employee salary algorithm
    ```

- Unnecessary punctuation is present:

    ```
    Update Employee salary algorithm.
    ```

    ```
    Implement employees salary and ajax queries:
    
    - update Employee salary algorithm;
    - remove unused files from public/images/ dir.
    ```

- Missing blank line between the summary line and the marked list:

    ```
    Implement employees salary and ajax queries
    - update Employee salary algorithm
    - remove unused files from public/images/ dir
    ```

- Marked list is indented:

    ```
    Implement employees salary and ajax queries
    
      - update Employee salary algorithm
      - remove unused files from public/images/ dir
    ```

- Marked list items start with a capital letter:

    ```
    Implement employees salary and ajax queries
    
    - Update Employee salary algorithm
    - Remove unused files from public/images/ dir
    ```

#### FCM (final commit message)

[FCM][t:FCM] (final commit message) is a commit message of a [merge commit][p:merging] to a mainline branch.

As it will be saved in a [repository][t:repository] history forever, it has __extra requirements__ that __must__ be met:
- __contain [references][103]__ to related [MR][t:MR] and [issue][t:issue] (or [milestone][t:milestone]) __in its summary line__;
- do __not contain__ any non-relative helper markers (like `[skip ci]`);
- __be approved by a [lead][t:lead]__ on ~review __before committed and pushed__.

__Common commit messages__ which are not [FCM][t:FCM] __must NOT contain any [references][103]__, because [references][103] create [crosslinks][104] in mentioned [issues][t:issue]/[MRs][t:MR], which leads to spamming [issues][t:issue]/[MRs][t:MR] with unnecessary information. Only saved in history forever commits are allowed to create such [crosslinks][104].

If а [MR][t:MR] contains some __side changes__ which are not directly relevant to the [task][t:task], then such changes __must be described as a marked list in the `Additionally:` section (separated by a blank line)__ of a [FCM][t:FCM].

If [FCM][t:FCM] describes __[project][t:project] version update__ then it __must reference the [milestone][t:milestone]__ of this version.

##### 👍 FCM examples

```
Implement employees salary and ajax queries (!43, #54)

- update Employee salary algorithm
- remove unused files from public/images/ dir

Additionally:
- update Git ignoring rules for TOML files
```

```
Bump up project version to 1.54.1 (%71)
```

##### 🚫 Wrong FCM examples

- Bad formatting of [references][103]:

    ```
    Implement employees salary and ajax queries(!43,#54)

    - update Employee salary algorithm
    - remove unused files from public/images/ dir
    ```

- Side changes are not separated:

    ```
    Implement employees salary and ajax queries (!43, #54)

    - update Employee salary algorithm
    - remove unused files from public/images/ dir
    - update Git ignoring rules for TOML files
    ```

- Bad formatting of side changes:

    ```
    Implement employees salary and ajax queries (!43, #54)

    - update Employee salary algorithm
    - remove unused files from public/images/ dir
    Additionally:
    - update Git ignoring rules for TOML files
    ```


### Pushing

[Developer][t:developer] is __allowed to push__ changes __only__ when [MR][t:MR] is __assigned to him__.

[Developer][t:developer] __must push all his changes__ to the remote __at the end of his working day__. This both prevents from accidental work losses and helps a [lead][t:lead] to track [developer's][t:developer] progress.




## [Project][t:project] requirements


### Issues

[Issues][t:issue] are created to describe some problem to be resolved (bug, feature proposal, [project][t:project]-relevant question, implementation task, etc.).

[Issue][t:issue] __name must shortly and clearly describe its meaning and purpose__.

[Issue][t:issue] __description must contain details of the problem__ (background, analysis, possible solutions, alternatives) __and references to any other related [issues][t:issue]__ (like dependent issues, related issues, roadmaps, etc.).

All [projects][t:project] have [issue templates][108] which standardize common [issue][t:issue] types (`Bug`, `Task`, `Feature proposal`, `Roadmap`, `Question`). [Developer][t:developer] must __use [issue templates][108] whenever it's possible__.  
If there is no template for some rare case, then the [issue][t:issue] must be formatted in the same manner as available templates. If there is no template for some common case, then [developer][t:developer] should propose it via [MR][t:MR].

[Issue][t:issue] cannot be assigned to nobody and __always must have an assigned [developer][t:developer]__.

[Issue][t:issue] __must have a [milestone][t:milestone] whenever it's possible__.

[Issue][t:issue] cannot go without any [labels][t:label] and __must have all required [labels correctly applied][p:labels]__.


### MRs (merge requests)

[MRs][t:MR] are created to make changes in the [repository][t:repository] and to solve some problem (fix a bug, implement a task, provide an improvement, etc). Usually a [MR][t:MR] is created to resolve some [issue][t:issue], but a __single [MR][t:MR] is also the case__.

[MR][t:MR] __must contain related changes only__. Any __other unrelated changes__ of [repository][t:repository] must be done __via separate [MR][t:MR] or committed directly into mainline__ (if [lead][t:lead] allows to). This rule keeps [project][t:project] history clear and unambiguous.

[MR][t:MR] __name must__:
- __shortly and clearly describe its meaning__ (but NOT the meaning of the solving [issue][t:issue]);
- __reference solving [issue][t:issue]__ if there is one (example: ` (#427)`);
- __contain `WIP: ` prefix__ until [MR][t:MR] is merged or closed.

[MR][t:MR] __description must contain details of the solution__ (background/summary, solution description, notable moments, etc) __and references to the solving [issue][t:issue] and any other related [issues][t:issue]/[MRs][t:MR]__ (like dependent issues/MRs, related issues/MRs, roadmaps, etc.).

All [projects][t:project] have [MR templates][108] which standardize common [MR][t:MR] types (`Bugfix`, `Task`, `Release`, `Roadmap`). [Developer][t:developer] must __use [MR templates][108] whenever it's possible__.  
If there is no template for some rare case, then the [MR][t:MR] must be formatted in the same manner as available templates. If there is no template for some common case, then [developer][t:developer] should propose it via another [MR][t:MR].

[MR][t:MR] cannot be assigned to nobody and __always must have an assigned [developer][t:developer]__.

[MR][t:MR] __must have a [milestone][t:milestone]__. If there is no [milestone][t:milestone] available the [developer][t:developer] should ask a [project maintainer][t:maintainer] to create one.

[MR][t:MR] cannot go without any [labels][t:label] and __must have all required [labels correctly applied][p:labels]__.

[MR][t:MR] __cannot be [merged][p:merging] without being ~"review"ed__ and __must be approved__ (~"LGTM" [label][t:label]) __before [merge][p:merging]__.


### Labels

[Labels][t:label] are used for [issues][t:issue]/[MRs][t:MR] classification, as they:
- reflect the current state of [issue][t:issue]/[MR][t:MR];
- improve understanding of [issue][t:issue]/[MR][t:MR], its purpose and application;
- provide advanced search of [issues][t:issue]/[MRs][t:MR];
- allow to sum up statistics of how [project][t:project] is going on.

There are several label groups:
- `type: ` labels declare what the current [issue][t:issue]/[MR][t:MR] actually represents. These labels are __mandatory__: each [issue][t:issue]/[MR][t:MR] must have at least one such label.
    - ~"type: feature" applies when something new is implemented (or is going to be implemented).
    - ~"type: enhancement" applies when changing of existing features is involved (improvement or bugfix).
    - ~"type: bug" applies to bugs and incorrectness problems. Can be applied to __[issues][t:issue] only__.
    - ~"type: research" applies when some problem investigation is involved.
    - ~"type: roadmap" applies when [issue][t:issue]/[MR][t:MR] summarizes some steps which consist of another [issues][t:issue] and [MRs][t:MR].
    - ~"type: rollback" applies when some existing changes are going to be rolled back.
    - ~"type: question" applies to concrete [project][t:project]-level questions that need discussion. Can be applied to __[issues][t:issue] only__.
- `kind: ` labels describe what the current [issue][t:issue]/[MR][t:MR] is relevant to and which [project][t:project] aspects are involved. These labels are __mandatory__: each [issue][t:issue]/[MR][t:MR] must have at least one such label.
    - ~"kind: UI/UX" applies to UI (user interface) and UX (user experience) changes. Use it when [end-users][t:end-user] are directly affected by this changes.
    - ~"kind: api" applies to API (application interface) changes. Use it when you're changing application interfaces, like: HTTP API method parameters, library exported interfaces, command-line interfaces, etc.
    - ~"kind: config" applies to configuration changes of application.
    - ~"kind: cron" applies to changes in background processes of application.
    - ~"kind: deploy" applies to changes that involve application deployment. Use it when you're changing the way application is deployed.
    - ~"kind: design" applies to changes of application architecture and implementation design. Use it when you're changing architecture and algorithms.
    - ~"kind: documentation" applies to changes of [project][t:project] documentation.
    - ~"kind: logging" applies to changes in application logs.
    - ~"kind: monitoring" applies to application monitoring related changes. Use it when you're changing monitoring metrics and interfaces.
    - ~"kind: performance" applies to application performance related changes.
    - ~"kind: refactor" applies to refactor changes of existing code.
    - ~"kind: security" applies to application security related changes.
    - ~"kind: testing" applies to changes of [project][t:project] tests.
    - ~"kind: toolchain" applies to changes of [project toolchain][t:toolchain].
- `priority: ` labels declare the priority of the current [issue][t:issue]/[MR][t:MR] among others. If no such label specified, then [issue][t:issue]/[MR][t:MR] has a normal priority. These labels are __temporary__: they must be removed after [issue][t:issue]/[MR][t:MR] is resolved.
    - ~"priority: critical" applies to stop-factor [issues][t:issue]/[MRs][t:MR], such as the [project][t:project] development and/or operation cannot be continued until it is resolved.
    - ~"priority: major" applies to urgent [issues][t:issue]/[MRs][t:MR] which must be resolved in the first place.
    - ~"priority: minor" applies to [issues][t:issue]/[MRs][t:MR] which are not required to be resolved at the moment (or in the near future) and can be deferred to resolve later.
- `waiting: ` labels declare that the current [issue][t:issue]/[MR][t:MR] is currently [paused][p:pausing] by somewhat reason. These labels are __temporary__: they must be removed after [issue][t:issue]/[MR][t:MR] solving is resumed and not paused anymore.
    - ~"waiting: materials" applies when there is a need for additional actions/info outside the [issue][t:issue]/[MR][t:MR] to continue its solving.
    - ~"waiting: suspended" applies when [issue][t:issue]/[MR][t:MR] solving is just paused and will be resumed in future.
- ~"review"-related labels declare the approving status of the current [MR][t:MR]. These labels can be applied to __[MRs][t:MR] only__ and are __temporary__: they must be removed after [MR][t:MR] is merged.
    - ~review applies when [MR][t:MR] is on review by [lead][t:lead] or any other reviewer.
    - ~reopened applies when [MR][t:MR] changes are not approved and must be improved.
    - ~LGTM (look good to me) applies when [MR][t:MR] changes are approved and can be merged.
- ~RFC (request for comments) label informs that the current [issue][t:issue]/[MR][t:MR] must be discussed by [developer][t:developer] and [lead][t:lead] with [project maintainers][t:maintainer]. This label is __temporary__: it must be removed after discussion is completed and decision is made.
- `area: ` labels inform that the current [issue][t:issue]/[MR][t:MR] is related to some deployment environment.
    - ~"area: production" applies when [issue][t:issue]/[MR][t:MR] is related to the [releases][t:release] currently deployed in production environment.
    - ~"area: staging" applies when [issue][t:issue]/[MR][t:MR] is related to staging environment deployments.
- ~wontfix label informs that the current [issue][t:issue]/[MR][t:MR] is [closed without being resolved][p:wontfix]. Can be applied to __closed [issues][t:issue] and closed (NOT merged) [MRs][t:MR] only__. Also, such non-resolved [issue][t:issue]/[MR][t:MR] __must be labeled with at least one__ of the following:
    - ~obsolete applies when [issue][t:issue]/[MR][t:MR] resolving doesn't matter or is not required anymore.
    - ~duplicate applies to accidentally created duplicates of some existing non-resolved [issue][t:issue]/[MR][t:MR].
    - ~"no reproduce" applies when [issue][t:issue] cannot be reproduced, and so cannot be resolved. Can be applied to __[issues][t:issue] only__.
    - ~moved applies when [issue][t:issue]/[MR][t:MR] is moved to another [project][t:project].
- ~TBD label is used for [changelog][t:changelog] only and __must NOT be applied to [issues][t:issue]/[MRs][t:MR]__.

Except the [labels][t:label] described above a [project][t:project] may contain additional [labels][t:label] that are specific to this [project][t:project] or required by its workflow. Their usage should be described in a [contribution guide][p:contribution-guide].


### Milestones

[Milestone][t:milestone] must represent a __brief overview of its [release][t:release]__, so __must contain__:
- __link to the [release version tag][p:tag-naming]__ of the [repository][t:repository];
- __[permalink][106] to the [changelog][t:changelog]__ of this [release][t:release];
- __link to the [roadmap][t:roadmap]__ of this [release][t:release] __if it exists__.

__Name__ of a [milestone][t:milestone] must be __the version number__ of a [release][t:release].

On GitHub __use a [GitHub release] instead of a [milestone][t:milestone]__.

##### Example

```markdown
Release [2.3.13](https://git.instrumentisto.com/my/project/tree/v2.3.13)

Roadmap: #138

[Changelog](https://git.instrumentisto.com/my/project/blob/v2.3.13/CHANGELOG.md#2313-2018-07-18)
```




## Workflow

The base rule of the development workflow is that a __[developer][t:developer] works upon exactly one [task][t:task] at the same time__. When the first [task][t:task] goes to ~review or is [paused][p:pausing] for some reasons a [developer][t:developer] starts working upon the second [task][t:task] (next one), but __stops working upon the second [task][t:task] and immediately returns to the first task when it can be continued__.  
This allows to linearize [developer's][t:developer] work and normalize [lead's][t:lead] workload which results in a better productivity and faster features implementations.

The order to solve [tasks][t:task] is [FIFO (first in, first out)][FIFO]: __the first [task][t:task] is the most prioritized__, __unless__ a [developer][t:developer] is __explicitly informed with another order__ by his [lead][t:lead].

Usually, [developer][t:developer] receives [tasks][t:task] to work on from his [lead][t:lead]. But __if [developer][t:developer] receives a [task][t:task] from someone else__ ([maintainer][t:maintainer] or [product][t:product] owner), he __must coordinate its priority with his [lead][t:lead]__.

If [developer][t:developer] has no more [tasks][t:task] to work on, then he has to do the following things (with descending priority):
- reduce the technical debt of his current [projects][t:project] (do refactorings, write additional tests, etc);
- improve his technical skills by filling gaps and unclear things in his fundamental knowledge, learning and improving the current technical stack knowledge, trying out new patterns and paradigms, polishing his IDE and tooling experience.


### Development

__Quality first__, that's why, usually, [developer][t:developer] is not restricted with any deadlines for [task][t:task] resolving (unless explicitly instructed with vice versa). However, this means that __[developer][t:developer] is responsible to keep up and improve his productivity himself__ (but __never in price of quality__).

The basic workflow of one [task][t:task] development is described with the diagram below:
```markdown
 |
 | Report issue #32
 | and assign it to Maintainer or Lead
 | (DO use available issue templates)
 V
+--------------------+
| Issue #32 reported |
+--------------------+
 |
 | Maintainer or Lead applies correct labels to issue #32
 |
 | Maintainer or Lead attaches issue #32 to %10 milestone
 |
 | Maintainer or Lead reassigns issue #32 to Developer
 V
+---------------------------------+
| Issue #32 assigned to Developer |
+---------------------------------+
 |
 | Developer investigates issue #32,
 | proposes and describes possible solutions
 |
 | Lead discusses solutions with Developer (and Maintainer, optionally)
 | and approves some solution
 |
 | Developer creates branch `32-relevant-name` from latest mainline branch
 | and creates MR (merge request) `32-relevant-name` -> mainline branch:
 | - name of MR must start with `WIP: ` prefix
 |   and contain ` (#32)` reference
 | - description of MR must mention #32 issue
 | (DO use available MR templates)
 |
 | Developer assigns MR !57 to himself
 |
 | Developer attaches MR !57 to %10 milestone
 |
 | Developer applies correct labels to MR !57
 V
+--------------------------+
| MR !57 on implementation |<---------------------------------+
+--------------------------+                                  |
 |                                                            |
 | Developer removes ~reopened label from MR !57 (if any)     |
 |                                                            |
 | Developer pulls `32-relevant-name` branch from remote      |
 | to consider any changes                                    |
 |                                                            |
 | Developer implements MR !57 changes                        |
 |                                                            |
 | Developer ensures that:                                    |
 | - all business requirements are implemented                |
 | - all changes follow project's code style                  |
 | - all project tests and builds pass successfully           |
 |                                                            |
 | Developer updates CHANGELOG                                |
 | with MR !57 changes (if required)                          |
 |                                                            |
 | Developer updates "Deployment" section of CHANGELOG        |
 | with manual deployment actions (if required)               |
 |                                                            |
 | Developer performs final detailed self-review              |
 | of the whole changes made in MR !57                        |
 | to ensure that quality requirements are met                |
 |                                                            |
 | Developer prepares FCM (final commit message)              |
 | and posts it as discussion                                 |
 |                                                            |
 | Developer adds ~review label to MR !57                     |
 |                                                            |
 | Developer reassigns MR !57 to Lead                         |
 V                                                            |
+------------------+                                          |
| MR !57 on review |                                          |
+------------------+                                          |
   |                                                          |
   | Lead reviews changes of MR !57                           |
   | and comments them in MR !57 as separate discussions      |
   |                                                          |
   | Lead ensures that CHANGELOG is updated (if required)     |
   |                                                          |
   | Lead ensures that "Deployment" section of CHANGELOG      |
   | is present and correct (if required)                     |
   |                                                          |
   | Lead describes review result in MR !57                   |
   | as a separate discussion                                 |
   |                                                          |
   | Lead removes ~review label from MR !57                   |
  / \                                                         |
 |   |                                                        |
 |   | Lead does not approve MR !57                           |
 |   |                                                        |
 |   | Lead adds ~reopened label to MR !75                    |
 |   V                                                        |
 |  +-----------------+                                       |
 |  | MR !57 reopened |                                       |
 |  +-----------------+                                       |
 |   |                                                        |
 |   | Lead reassigns MR !57 to Developer                     |
 |   |                                                        |
 |   | Developer considers review result                      |
 |   |                                                        |
 |   +--------------------------------------------------------+
 |
 | Lead approves MR !57
 |
 | Lead approves (with reaction) posted FCM in MR !57
 | or posts correct FCM instead
 |
 | Lead adds ~LGTM label (look good to me) to MR !57
 |
 | Lead reassigns MR !57 to Developer
 |
 | Lead initiates "Retrospective" discussion by mentioning Developer
 | in MR !57 comments (if Lead needs it)
 V
+-----------------+
| MR !57 approved |
+-----------------+
 |
 | Developer considers review result
 |
 | Developer pulls `32-relevant-name` branch from remote
 | to consider any changes
 |
 | Developer prepares MR !57 to be merged into mainline branch
 |
 | Developer merges latest mainline into branch `32-relevant-name`,
 | then squashes all commits into a single one
 | and copy-pastes approved FCM as a commit message
 | (DO NOT use "Squash commits" checkbox on GitLab)
 |
 | Developer ensures that MR !57 name and description are correct,
 | verbose enough and up-to-date. 
 |
 | Developer removes `WIP: ` prefix from MR !57 name
 |
 | Developer removes ~LGTM label from MR !57
 |
 | Developer removes any other temporary labels from MR !57
 |
 | Developer ensures that MR !57 is attached to correct milestone
 |
 | Developer resolves all discussions in MR !57
 |
 | Developer merges squashed & rebased branch `32-relevant-name` into mainline
 | with fast-forward merge
 | (DO use "Merge when pipeline succeeds" button on GitLab if possible)
 |
 | Developer removes `32-relevant-name` remote branch
 | (DO use "Remove source branch" checkbox or button on GitLab)
 V
+---------------+
| MR !57 merged |
+---------------+
 |
 | Developer removes any temporary labels from issue #32
 |
 | Developer ensures that issue #32 is attached to correct milestone
 |
 | Developer closes issue #32
 |
 | Developer initiates "Retrospective" discussion by mentioning Lead
 | in MR !57 comments (if Developer needs it)
 V
+--------------------+
| Issue #32 resolved |
+--------------------+
```

If an [issue][t:issue] is reopened lately, then its lifecycle begins from scratch, but with a different [MR][t:MR].

When there is no need to create an [issue][t:issue], just create a [MR][t:MR] directly and repeat the workflow above without issue-related parts.

While a [MR][t:MR] is __on ~review a [developer][t:developer] cannot [push][p:pushing] any changes__ (as [MR][t:MR] is not assigned to him) unless explicitly coordinated with his [lead][t:lead].

__For GitHub__ [projects][t:project]:
- __[PR (pull request) reviews][GitHub PR review] must be used__ instead of reassigning and ~review/~LGTM labels applying.
- __Squash merge must be done via GitHub UI__ (first line of [FCM][t:FCM] goes as a title and everything after as a message), because it preserves commits history in [PR][t:MR].


#### Multiple reviews

Sometimes there is a need for a [MR][t:MR] to be ~"review"ed by multiple persons (by [lead][t:lead] and [maintainer][t:maintainer], for example). In such case ~"review"s are performed in a cascade manner.

```markdown
+--------------------------+
| MR !57 on implementation |<---------------------------------+
+--------------------------+                                  |
 |                                                            |
 | Developer removes ~reopened label from MR !57 (if any)     |
 |                                                            |
 | Developer assigns MR !57 to Lead                           |
 | and applies ~review label                                  ^
 V                                                            |
+--------------------------+                                  |
| MR !57 on review by Lead |                                  |
+--------------------------+                                  |
   |                                                          |
   | Lead reviews changes of MR !57                           |
   | and comments them in MR !57 as separate discussions      ^
   | by mentioning Developer                                  |
   |                                                          |
  / \                                                         |
 |   | Lead does not approve MR !57                           |
 |   |                                                        |
 |   | Lead removes ~review label from MR !57                 |
 |   | and adds ~reopened label                               ^
 |   V                                                        |
 |  +-----------------+                                       |
 |  | MR !57 reopened |                                       |
 |  +-----------------+                                       |
 |   ^   |                                                    |
 |   |   | Lead reassigns MR !57 to Developer                 |
 |   |   |                                                    ^
 |   |   | Developer considers review result                  |
 |   |   |                                                    |
 |   |   +-------------->-------------------->----------------+
 |   +------------------<--------------------<----------------+
 |                                                            |
 | Lead approves MR !57 changes                               |
 |                                                            |
 | Lead reassigns MR !57 to Reviewer2                         |
 V                                                            ^
+-------------------------------+                             |
| MR !57 on review by Reviewer2 |                             |
+-------------------------------+                             |
   |                                                          |
   | Reviewer2 reviews changes of MR !57                      |
   | and comments them in MR !57 as separate discussions      |
   | by mentioning Developer and Lead                         ^
   |                                                          |
  / \                                                         |
 |   | Reviewer2 does not approve MR !57                      |
 |   |                                                        |
 |   | Reviewer2 removes ~review label from MR !57            |
 |   | and adds ~reopened label                               |
 |   V                                                        ^
 |  +-----------------+                                       |
 |  | MR !57 reopened |                                       |
 |  +-----------------+                                       |
 |   ^   |                                                    |
 |   |   | Reviewer2 reassigns MR !57 to Lead                 |
 |   |   |                                                    ^
 |   |   | Lead considers review result                       |
 |   |   |                                                    |
 |   |   +-------------->-------------------->----------------+
 |   +------------------<--------------------<----------------+
 |                                                            |
 | Reviewer2 approves MR !57 changes                          |
 |                                                            |
 | Reviewer2 reassigns MR !57 to Reviewer3                    |
 V                                                            ^
+-------------------------------+                             |
| MR !57 on review by Reviewer3 |                             |
+-------------------------------+                             |
   |                                                          |
   | Reviewer3 reviews changes of MR !57                      |
   | and comments them in MR !57 as separate discussions      |
   | by mentioning Developer, Lead and Reviewer2              ^
   |                                                          |
  / \                                                         |
 |   | Reviewer3 does not approve MR !57                      |
 |   |                                                        |
 |   | Reviewer3 removes ~review label from MR !57            |
 |   | and adds ~reopened label                               |
 |   V                                                        ^
 |  +-----------------+                                       |
 |  | MR !57 reopened |                                       |
 |  +-----------------+                                       |
 |   |                                                        |
 |   | Reviewer3 reassigns MR !57 to Reviewer2                |
 |   |                                                        ^
 |   | Reviewer2 considers review result                      |
 |   |                                                        |
 |   +------------------>-------------------->----------------+
 |
 | Reviewer3 approves MR !57 changes
 |
 | Reviewer3 adds ~LGTM label (look good to me) to MR !57
 |
 | Reviewer3 reassigns MR !57 to Reviewer2
 |
 | Reviewer2 considers review result
 |
 | Reviewer2 reassigns MR !57 to Lead
 |
 | Lead considers review result
 |
 | Lead reassigns MR !57 to Developer
 V
+-----------------+
| MR !57 approved |
+-----------------+
```

#### Pausing

When a [developer][t:developer] returns to the [issue][t:issue] solving (or [MR][t:MR] implementation) he must remove any `waiting: ` labels.

#### Temporary mainline

Sometimes there is a need for a separate temporary mainline branch, for example:
- implementing a new huge feature in multiple ~"review"able steps while each step cannot be merged into main mainline separately;
- releasing a new PATCH [project][t:project] version while main mainline contains non-PATCH changes;
- global multi-step [project][t:project] refactoring which cannot be done in main mainline.

In such case the following steps must be performed:
1. Create a general ~"type: roadmap" [MR][t:MR] from temporary mainline branch into main mainline branch.
2. Each implementation step must be performed in a separate [MR][t:MR] and merged into temporary mainline branch.
3. Each implementation step must be referenced in the ~"type: roadmap" [MR][t:MR] in a form of [task list entry][107] to track the overall progress of temporary mainline.
4. After __temporary mainline__ is completed it __must be merged into main mainline with an ordinary merge__ (without squashing and rebasing) to preserve development history.

#### Wontfix

Sometimes there is a need to close an [issue][t:issue]/[MR][t:MR] without resolving it (in case it's ~obsolete or ~"duplicate", for example), i.e. ~wontfix it.

In such case a [developer][t:developer] must proceed with the following actions:
```markdown
 |
 | Developer removes `WIP: ` prefix from MR !57 name
 |
 | Developer removes any temporary labels from MR !57
 |
 | Developer applies to MR !57 ~wontfix label
 | and one of ~duplicate, ~obsolete, ~moved, or ~"no reproduce" labels
 |
 | Developer posts comment in MR !57
 | with description of why MR !57 is closed
 |
 | Developer ensures that MR !57 is attached to correct milestone
 |
 | Developer resolves all discussions in MR !57
 |
 | Developer closes MR !57 (NOT merges)
 |
 | Developer removes `32-relevant-name` remote branch
 V
+---------------+
| MR !57 closed |
+---------------+
 |
 | Developer removes any temporary labels from issue #32
 |
 | Developer applies to issue #32 ~wontfix label
 | and one of ~duplicate, ~obsolete, ~moved, or ~"no reproduce" labels
 |
 | Developer posts comment in issue #32
 | with description of why issue #32 is closed
 |
 | Developer ensures that issue #32 is attached to correct milestone
 |
 | Developer closes issue #32
 V
+------------------+
| Issue #32 closed |
+------------------+
```




### Releasing

```markdown
 |
 | Issue #32 is resolved and MR !57 is implemented.
 V
+-----------------------------------------------+
| Project 1.3.5 version is going to be released |
+-----------------------------------------------+
 |
 | Maintainer creates MR !58 using "Release" template
 | and includes it to %10 milestone
 |
 | Maintainer ensures that all merged MRs
 | and resolved issues are included to %10 milestone
 |
 | Maintainer ensures that all issues and MRs of %10 milestone
 | have correct labels applied
 |
 | Maintainer ensures that CHANGELOG for the current version 1.3.5
 | is sound, renders correctly and does not miss any notable changes
 |
 | Maintainer bumps up project version to 1.3.5 in project files (if any),
 | then commits and pushes those changes to MR !58
 |
 | Maintainer assigns MR !58 for review to Senior Maintainer
 | (or reviews itself if there is no Senior Maintainer)
 |
 | Senior Maintainer approves MR !58
 |
 | Maintainer squashes and merges MR !58 with a proper FCM
 | (DO mention milestone %10 in commit message)
 V
+-----------------------------------------------+
| Project 1.3.5 version is prepared for release |
+-----------------------------------------------+
 |
 | Maintainer applies version tag `v1.3.5` to HEAD of mainline branch
 | and pushes this tag
 | (DO use `make git.release` if available)
 |
 | Maintainer fast-forward merges tag `v1.3.5` into `release` branch
 | and pushes `release` branch
 | (DO use `make git.release` if available)
 |
 | Maintainer edits %10 milestone to contain:
 | - permalink to tag `v1.3.5` files
 | - permalink to 1.3.5 version CHANGELOG
 | - link to the ~"type: roadmap" issue of 1.3.5 version (if any)
 |
 | Maintainer ensures that all pipelines complete successfully
 | for `v1.3.5` tag, `release` branch and mainline branch
 |
 | Maintainer closes %10 milestone
 V
+-----------------------------------+
| Project 1.3.5 version is released |
+-----------------------------------+
 |
 | Maintainer creates new `next-release` milestone
 | for future release
 |
 | Maintainer notifies his Lead to deploy project version 1.3.5
 V
+-----------------------------------------------+
| Project 1.3.5 version is going to be deployed |
+-----------------------------------------------+
```

__For GitHub__ [projects][t:project]:
- The __[GitHub release] must be created and described__ (in the same manner as [milestone][t:milestone]) for the version tag.


### Deployment

```markdown
 |
 | Maintainer releases version 1.3.5 of project
 V
+-----------------------------------------------+
| Project 1.3.5 version is going to be deployed |
+-----------------------------------------------+
 |
 | Deployer reads and examines CHANGELOG carefully
 |
 | Deployer applies required actions
 | from "Deployment" CHANGELOG section (if any for 1.3.5 version)
 |
 | Deployer deploys version 1.3.5 of project
 V
+-----------------------------------+
| Project 1.3.5 version is deployed |
+-----------------------------------+
   |
   | Deployer ensures that version 1.3.5 is deployed correctly,
   | and product is healthy and reachable by clients
   |
  / \
 |   | Version 1.3.5 cannot be deployed successfully
 |   | 
 |   | Deployer rolls back deployment to a previous version
 |   |
 |   | Deployer creates project issue with problem description
 |   V
 |  +---------------------------------+
 |  | Project 1.3.5 version is broken |
 |  +---------------------------------+
 |
 | Version 1.3.5 is deployed successfully
 |
 | Deployer notifies end-users about 1.3.5 version release
 | and provides them with notable changes from CHANGELOG
 | (DO provide only valuable changes for end-users)
 V
+---------------------------------+
| Project 1.3.5 version is on-air |
+---------------------------------+
```




## Communication

__All communication related to a problem__ must be performed __in the relevant [issue][t:issue]__.

__All communication related to a concrete solution__ and/or changes must be performed __in the relevant [MR][t:MR]__.

Use a __separate [GitLab discussion] each time you're asking new question__ or starting new topic.

Questions which are [project][t:project]-relevant, but __not related to a some concrete [issue][t:issue]/[MR][t:MR], must be asked via an [issue][t:issue] of__ ~"type: question" in the appropriate [project][t:project]. Before creating new one, use search and ensure that similar question has not been asked before.

__Track communications, questions and answers with [GitLab Todo]s__ (or [GitHub Notification]s), and __create them for the person you expect reaction from__. 


### Coordinations

Before a [developer][t:developer] starts [MR][t:MR] implementation, he __must thoroughly examine the problem__ to solve (possible represented by an [issue][t:issue]) and __come up with a concrete implementation design__. This design __must be discussed__ with his [lead][t:lead] (called [coordination][t:coordination] discussion) __and approved__ by him.

Such [coordination][t:coordination] discussions help to avoid misunderstanding of how things should be implemented, and to prevent unnecessary and redudant job on early stages. 


### Retrospectives

After [MR][t:MR] is resolved either a [developer][t:developer] or his [lead][t:lead] may initiate a discussion (if somebody needs to) about the solving results (called [retrospective][t:retrospective]):
- How much time did it take to solve the problem? Why?
- What was done wrong during the solving? Why? How can it be avoided in future?
- What could be done better? How?

Such [retrospective][t:retrospective] discussions help to optimise development workflow and productivity, understand the way to evolve in for both a [developer][t:developer] and his [lead][t:lead].


### Weekly meetup

__Every week [lead][t:lead] must organize a meetup with the whole his [team][t:team]__ to grasp and discuss the following:
- Evaluate the overall result of the [team][t:team] for past week: what has been done and how.
- Coordinate plans for the next week: what should be done and what are priorities.
- Discuss and resolve current problems of the [team][t:team]: unresolved questions, product/concept/paradigm/architecture misunderstandings, etc.
- Analyze productivity issues of the [team][t:team], discuss them, and make steps to fix them (if any).


### Corporative chat

[Corporative chat][p:corporative-chat] is a place where a [developer][t:developer] and his [lead][t:lead] discuss and resolve their __organization questions which are NOT related to a dedicated [task][t:task]__.

Additionally, a __status__ in the [corporative chat][p:corporative-chat] __reflects the working status__ of a [developer][t:developer], so he must set it:
- `online` __only__ when is working;
- `away` otherwise.

A [developer][t:developer] is __responsible for keeping up-to-date his job schedule__ in three places:
- `Bio` field of [GitLab profile];
- [corporative chat][p:corporative-chat] status description;
- [Skype] status.


### Reports

__At the end of each working day__ a [developer][t:developer] must __report__ (in the [corporative chat][p:corporative-chat]) to his [lead][t:lead] about __daily done stuff__ in a brief but informative manner. Not necessarily on English.

The report must be in the following [Markdown] format:
```markdown
## Report by <developer name> for <weekday> (<date>):
1. <what is done 1> (<full issue/MR reference>)
2. <what is done 2>: (<full issue/MR reference>)
    - <concrete detail 1>
    - <concrete detail 2>
3. <what is done 3> (<full issue/MR reference>)
```

Any __job time overtimes or debts__ (if [developer][t:developer] has any) __must be specified at the end of report__ clearly and unambiguous.
```markdown
Total overtime: 1 day 5 hours 35 minutes
```
or
```markdown
Total job time debt: 3 day 5 minutes
```
Сonversion rates always are: 1 month = 4 weeks, 1 week = 5 days, and 1 day = 8 hours.

##### Example

```markdown
## Отчет по Васе Пупкину за понедельник (20.08.2018):
1. Согласовал с @dpetrov план реализации по задаче contrib/time-bot#4 
2. Обновление Development workflow: (common/documentation!34)
    - описал раздел GitLab меток
    - описал правила комуникации
3. Обновил Helm до версии 2.10.0 в GitLab Builder Docker-образе (instrumentisto/gitlab-builder-docker-image#16)
4. Провел ревью для @team/legacy по задаче contrib/transactions-archivation!242

Всего наработано: 3 дня 3 часа 5 минут
```




## Testing

Testing is an __integral part of a [development workflow][p:development]__. We have no dedicated testing department or [team][t:team], so __every [developer][t:developer] is responsible for his code correctness.__

Despite the fact of using automated testing ([unit][204], [integration][205] or [E2E][206]) a [developer][t:developer] must perform some __manual checks to ensure that a feature is implemented correctly in all positive scenarios__ whenever it's possible (especially for ~"kind: UI/UX"), because automated tests will never provide a 100% guarantee of everything to be correct.

Any __automated testing must be [reproduced on CI][111]__ as a part of a [project][t:project] lifecycle. Some kinds of automated tests may have quite specific environment requirements to run (like browser tests which require browser engine to be installed), thus for better reproducibility __all tests must run inside [Docker] container__.

Obvious benefits of automated testing:
- Good code coverage simplifies bugs detection and helps a lot to locate code breakages on changes.
- Writing tests makes [developer][t:developer] to refactor code in a correct modular way just to be able to test his code, which results in a better code architecture/design and [lower coupling][207].
- Writing tests helps to cover corner cases which are hard to test manually. This improves code correctness and stability.
- Tests give examples of how code may be used, which helps new [developers][t:developer] to understand the code.
- Tests written as [BDD specs][208] may be treated as a code/[project][t:project] specification. This frees [developers][t:developer] from writing specifications separately and guarantees that specification requirements are met.

Detailed requirements for tests writing and style are described in a [code style guide][18].


### [E2E][206]

[E2E][206] tests are the __most important and useful__ ones, so __are mandatory__ when implementing a new feature.

Running a large [E2E][206] tests suite may be quite expensive in time and resources, so automatic running is disabled on CI by default for non-mainline branches. However, a __[developer][t:developer] must run [E2E][206] tests suite__ to ensure that it passes __before [merging][p:merging] or ~"review"__.


### [Unit][204]

[Unit][204] tests are not so important as [E2E][206], but still __are mandatory__ when implementing a new feature.

Code coverage is usually measured directly by [unit][204] tests suite. However, a [developer][t:developer] must remember that __100% coverage is not the aim__, but __the aim is a code correctness__, so the balance between a [unit][204] tests coverage and a correctness gain must be kept. In other words, there is no sense to spend a time and resources for a trivial [unit][204] test case which has no obvious impact on a code correctness.


### [Integration][205]

[Integration][205] tests are __not mandatory__, but are __highly recommended when there is a time and resources__ for them.

In some cases, however, [integration][205] tests may be a mandatory requirement due to a [project][t:project] nature. Such __requirement must be explicitly described in a [project contribution guide][p:repository-files]__ (`CONTRIBUTING.md` file).


### [Docker] image

If a [project][t:project] provides a [Docker] image as a runtime artifact of an application, then that __image must be tested to contain correct environment__ required by this application.


### [Linting][209]

__[Code style][code style] checks and [lints][209]__ represent an important part of [project][t:project] automated testing, so __are mandatory__ whenever it's possible.

However, their existence __does NOT free a [developer][t:developer] from following a [code style]__, but only helps to follow (as cannot capture all the cases), so a [developer][t:developer] must remain attentive when formatting code.




## Best practices

The __key point__ is to make __understanding__ [issues][t:issue] and [MRs][t:MR] __easy__.

- Use [referencing to other issues and MRs][103] for __easy navigation between related stuff__.
- Use [permalinks][106] when referencing something to __avoid links breakage over time__.
- Use [mentions][109] when you're discussing something with other people. That helps them to __notice your questions better__ (as creates a new [GitLab Todo]) and to react on your answer faster. Do NOT use [mentions][109] when you're not expecting any reaction on your comment, __avoid to bother people without a reason__.
- Use [task lists][107] to describe micro-tasks, roadmaps, or other stuff that solving progress depends on, as that helps to __track solving progress easily__.
- Use a separate [GitLab discussion] each time you're asking new question or starting new topic, as that helps to separate __conversations__ by theme, so keep them __more informative and understandable__.
- Use [emoji reactions][110] on comments to __give feedback to other people__ even when there is nothing to say for you.
- Use `[skip ci]` marker in commit message to __[skip triggering CI build][113]__ (but disallowed in [FCM][t:FCM]).
- Use browser plugins/extensions in addition to standard [GitLab Todo]s (and [GitHub notification]s) to track changes better and react on them faster:
    - GitLab: [Chrome](https://chrome.google.com/webstore/detail/gitlab-notifier-for-googl/eageapgbnjicdjjihgclpclilenjbobi);
    - GitHub: [Chrome](https://chrome.google.com/webstore/detail/notifier-for-github/lmjdlojahmbbcodnpecnjnmlddbkjhnn), [Firefox](https://addons.mozilla.org/en-US/firefox/addon/advanced-github-notifier).




## Questions

If you have any question, go ahead and [create a new issue][1] with labels ~"type: question" and ~"kind: documentation" for this project, if it has not been asked before.




[1]: https://gitlab.com/flexconstructor/karamba-info/issues/new
[11]: http://stackoverflow.com/questions/19957784/merge-and-rebase-branch-into-master-without-conflicts
[18]: developers/codestyle.md#tests
[101]: https://docs.gitlab.com/ce/user/project/protected_tags.html
[102]: https://docs.gitlab.com/ce/user/project/protected_branches.html
[103]: https://docs.gitlab.com/ce/user/markdown.html#special-gitlab-references
[104]: https://docs.gitlab.com/ce/user/project/issues/crosslinking_issues.html
[105]: https://help.github.com/articles/comparing-commits-across-time
[106]: https://help.github.com/articles/getting-permanent-links-to-files
[107]: https://docs.gitlab.com/ce/user/markdown.html#task-lists
[108]: https://docs.gitlab.com/ce/user/project/description_templates.html
[109]: https://about.gitlab.com/2016/03/08/gitlab-tutorial-its-all-connected#mention-others-and-assign
[110]: https://docs.gitlab.com/ce/user/award_emojis.html
[111]: https://docs.gitlab.com/ce/ci/pipelines.html
[112]: https://docs.gitlab.com/ce/user/project/badges.html
[113]: https://docs.gitlab.com/ce/ci/yaml/#skipping-jobs
[200]: https://en.wikipedia.org/wiki/Imperative_mood
[201]: https://en.wikipedia.org/wiki/Utility_software
[202]: https://en.wikipedia.org/wiki/Backward_compatibility
[203]: https://en.wikipedia.org/wiki/Schema_migration
[204]: https://en.wikipedia.org/wiki/Unit_testing
[205]: https://en.wikipedia.org/wiki/Integration_testing
[206]: https://en.wikipedia.org/wiki/Acceptance_testing
[207]: https://en.wikipedia.org/wiki/GRASP_(object-oriented_design)#Low_coupling
[208]: https://en.wikipedia.org/wiki/Behavior-driven_development
[209]: https://en.wikipedia.org/wiki/Lint_(software)

[code style]: developers/codestyle.md
[changelog example]: /../raw/master/examples/CHANGELOG.md
[changelog example rendered]: examples/CHANGELOG.md
[Docker]: https://www.docker.com
[fast-forward]: https://ariya.io/2013/09/fast-forward-git-merge
[FIFO]: https://en.wikipedia.org/wiki/FIFO_(computing_and_electronics)
[Git]: https://git-scm.com
[Git tag]: https://git-scm.com/book/en/v2/Git-Basics-Tagging
[Git-ignored]: https://git-scm.com/docs/gitignore
[GitHub issue]: https://help.github.com/articles/github-glossary/#issue
[GitHub notification]: https://help.github.com/articles/about-notifications
[GitHub PR]: https://help.github.com/articles/github-glossary/#pull-request
[GitHub PR review]: https://help.github.com/articles/about-pull-request-reviews
[GitHub release]: https://help.github.com/articles/about-releases
[GitHub repository]: https://help.github.com/articles/github-glossary/#repository
[GitLab discussion]: https://docs.gitlab.com/ce/user/discussions
[GitLab issue]: https://docs.gitlab.com/ce/user/project/issues
[GitLab milestone]: https://docs.gitlab.com/ce/user/project/milestones
[GitLab MR]: https://docs.gitlab.com/ce/user/project/merge_requests
[GitLab project]: https://docs.gitlab.com/ce/user/project
[GitLab Todo]: https://docs.gitlab.com/ce/workflow/todos.html
[Markdown]: https://docs.gitlab.com/ce/user/markdown.html
[Semantic Versioning 2.0.0]: https://semver.org
[Skype]: https://www.skype.com

[t:changelog]: #changelog
[t:coordination]: #coordinations
[t:developer]: #developer
[t:end-user]: #end-user
[t:FCM]: #fcm-final-commit-message
[t:IDE]: https://en.wikipedia.org/wiki/Integrated_development_environment
[t:issue]: #issue
[t:label]: https://docs.gitlab.com/ce/user/project/labels.html
[t:lead]: #lead
[t:maintainer]: #maintainer
[t:milestone]: #milestone
[t:MR]: #mr-merge-request
[t:product]: #product
[t:project]: #project
[t:release]: #release
[t:repository]: #repository
[t:retrospective]: #retrospectives
[t:roadmap]: #roadmap
[t:task]: #task
[t:team]: #team
[t:toolchain]: #toolchain

[p:best-practices]: #best-practices
[p:branch-naming]: #branch-naming
[p:branches-and-tags]: #branches-and-tags
[p:changelog]: #changelog-1
[p:commits]: #commits
[p:communication]: #communication
[p:contribution-guide]: #contribution-guide
[p:coordinations]: #coordinations
[p:corporative-chat]: #corporative-chat
[p:deployment]: #deployment
[p:development]: #development
[p:docker-tests]: #docker-image
[p:e2e-tests]: #e2e
[p:fcm]: #fcm-final-commit-message
[p:files-naming]: #naming
[p:glossary]: #glossary
[p:integration-tests]: #integration
[p:issues]: #issues
[p:labels]: #labels
[p:layout-example]: #layout-example
[p:linting]: #linting
[p:merging]: #merging
[p:milestones]: #milestones
[p:MRs]: #mrs-merge-requests
[p:multiple-reviews]: #multiple-reviews
[p:pausing]: #pausing
[p:project-requirements]: #project-requirements
[p:pushing]: #pushing
[p:questions]: #questions
[p:readme]: #readme
[p:releasing]: #releasing
[p:reports]: #reports
[p:repository-files]: #files
[p:repository-requirements]: #repository-requirements
[p:retrospectives]: #retrospectives
[p:squash-steps]: #squash-merging-steps
[p:tag-naming]: #tag-naming
[p:temp-mainline]: #temporary-mainline
[p:testing]: #testing
[p:unit-tests]: #unit
[p:weekly-meetup]: #weekly-meetup
[p:wontfix]: #wontfix
[p:workflow]: #workflow
