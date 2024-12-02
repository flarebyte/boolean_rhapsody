# Contributing

Welcome ! and many thanks for taking the time to contribute !

First, you should have a look at the [Technical design
documentation](TECHNICAL_DESIGN.md) to get an understanding of the design
behind this project.

From there, there are a few options depending of which kind of contributions
you have in mind: bug fix, documentation improvement, translation, testing,
...

Please note we have a [code of conduct](CODE_OF_CONDUCT.md), please follow it
in all your interactions with the project.

## Build the project locally

The following commands should get you started:

Setup an alias:

```
alias broth='npx baldrick-broth'
```

or if you prefer to always use the latest version:

```
alias broth='npx baldrick-broth@latest'
```

Install the `dart` dependencies:

```bash
dart pub get
```

Run the unit tests:

```bash
broth test unit
```

A list of [most used commands](MAINTENANCE.md) is available:

```bash
broth
```

Please keep an eye on test coverage, bundle size and documentation.
When you are ready for a pull request:

```bash
broth release ready
```

You will probably want to update the documentation:

```bash
broth doc api
```

You can also simulate [Github actions](https://docs.github.com/en/actions)
locally with [act](https://github.com/nektos/act).
You will need to setup `.actrc` with the node.js docker image `-P
ubuntu-latest=node:16-buster`

To run the pipeline:

```bash
broth github act
```

## Pull Request Process

1.  Make sure that an issue describing the intended code change exists and
    that this issue has been accepted.

When you are about to do a pull-request:

```bash
broth release ready -pr
```

Then you can create the pull-request:

```bash
broth release pr
```

## Publishing the library

This would be done by the main maintainers of the project. Locally for now as
updates are pretty infrequent, and some of tests have to be done manually.

```bash
broth release publish
```
