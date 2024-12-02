# Maintenance of the code

## Commands

### Run dart unit tests

> Standard way of writing and running tests in Dart

**Motivation:** Prevent defects and regressions.

**Run:** `npx baldrick-broth test unit`

See also:

-   [Standard Dart test package](https://pub.dev/packages/test)

***

### Upgrade to latest dependencies

> Upgrade to latest npm dependencies

**Motivation:** Keep up with security and improvements

**Run:** `npx baldrick-broth deps upgrade`

***

### Generate documentation

> Generate the api documentation for Dart

**Motivation:** Good documentation is essential for developer experience

**Run:** `npx baldrick-broth doc dart`

***

### Standardize the github repository

> Enable useful features for the github project repository

**Motivation:** Create consistent settings

**Run:** `npx baldrick-broth github standard`

***

### Static code analysis of Dart code

> Find problems in Dart code

**Motivation:** Make the code more consistent and avoid bugs

**Run:** `npx baldrick-broth lint check`

***

### Fix static code analysis

> Fix problems in Dart code

**Motivation:** Facilitate routine maintenance of code

**Run:** `npx baldrick-broth lint fix`

***

### Check Markdown files

> Checks that the markdown documents follows some consistent guidelines

**Motivation:** Make the markdown documents consistent in style

**Run:** `npx baldrick-broth md check`

***

### Fix Markdown files

> Modify the markdown documents to ensure they follow some consistent
> guidelines

**Motivation:** Make the markdown documents consistent in style

**Run:** `npx baldrick-broth md fix`

***

### Ready for publishing

> Run a sequence of commands to check that the library is ready to be
> published

**Motivation:** Detect quality flaws before pushing the code

**Run:** `npx baldrick-broth release ready`

***

### Pull request for the project

> Create a pull request for the branch

**Motivation:** Automate the body of pull request

**Run:** `npx baldrick-broth release pr`

***

### Publish the current library

> Publih the current library to npm

**Motivation:** Detect quality flaws before pushing the code

**Run:** `npx baldrick-broth release publish`

***

### Upgrade baldrick-broth configuration to latest version

> Gets the latest version of this configuration file

**Motivation:** Always apply the latest project conventions

**Run:** `npx baldrick-broth scaffold upgrade`

***

### Normalize the project

> Normalize the project in a similar fashion that the other dart projects

**Motivation:** Make the project structure consistent and easier to navigate

**Run:** `npx baldrick-broth scaffold norm`

***

### Normalize the project

> Normalize the project in a similar fashion that the other dart projects

**Motivation:** Make the project structure consistent and easier to navigate

**Run:** `npx baldrick-broth scaffold norm-package`

***

### Normalize using the custom script

> Normalize the project using a custom script for this project

**Motivation:** Enable an imperative approach for some of normalisation to
keep the model simple

**Run:** `npx baldrick-broth scaffold custom`

***

### Update readme

**Run:** `npx baldrick-broth scaffold readme`

***
