# Project Submission

(Draft)

## Git Repository

Each group is assigned a git repository for each project. You can clone the repository by

```bash
$ git clone ssh://git@focs.ji.sjtu.edu.cn:2100/p<n>team<m>
```

where `n` is the project number and `m` is your team number.

For example, maybe a student `Just Salut` is in group 13 and doing project 1, the command should be

```bash
$ git clone ssh://git@focs.ji.sjtu.edu.cn:2100/p1team13
```

## Building Specifications

### Makefile

In the root of your project repository, there should be a file `Makefile` which is used to build your project. 

You must ensure that after a clean `git clone` of the repository, the `Makefile` can be run successfully, and **a working game (`index.html` and all assets) should be in the `build` directory.**

You do not need to and should not install any global executables or packages. We've already installed these for you:
+ `git`, `node`, `npm`, `yarn`
+ `elm`, `create-elm-app`, `elm-app`
+ all unix commands are available to use

For example, the `Makefile` of `example-raw` is

```makefile
all:
	elm make src/Main.elm --output build/elm.js
	cp index.html build/index.html
```

If you are using raw Elm you can simply follow this. 

The `Makefile` of `example-create-react-app` is

```makefile
all:
	elm make || echo ''
	PUBLIC_URL='.' elm-app build
```

If you are using `create-elm-app` you can simply follow this. 

You can use `make` to build with a `Makefile`, and it should return `0` at last.

### Relative Paths

You must ensure that the paths in your `index.html` are all relative paths. 

For example, a script path can be

```html
<script src="./elm.js"></script>
```

which is equivalent to

```html
<script src="elm.js"></script>
```

But you can not use this one!

```html
<script src="/elm.js"></script>
```

In the example of `create-elm-app`, `PUBLIC_URL='.'` will handle everything correctly for you.

### Summary

A minimum project structure after `git clone` should be

```
.
├── Makefile
├── README
├── elm.json
├── index.html
└── src
    └── Main.elm
```

After running `make`, it should become
```
.
├── Makefile
├── README
├── build
│   ├── index.html
│   └── elm.js
├── elm-stuff
│   └── ...
├── elm.json
├── index.html
└── src
    └── Main.elm
```

## Example Projects

### example-raw

This project is built with example code from [official guide](https://guide.elm-lang.org/).

You can clone it by

```bash
$ git clone ssh://git@focs.ji.sjtu.edu.cn:2100/example-raw
```
 
### example-create-elm-app

This project is created by [create-elm-app](https://github.com/halfzebra/create-elm-app) directly.

You can clone it by

```bash
$ git clone ssh://git@focs.ji.sjtu.edu.cn:2100/example-create-elm-app
```