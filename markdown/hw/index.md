# Homework

These homework files are also available on the git server. If you want to clone the homework repo with `git`, follow the steps:

1. Open your terminal and locate to the directory where you want to clone the homework files.
  Eg., if you want to put everything in `~/VG100`, type
```bash
mkdir -p ~/VG100
cd ~/VG100
```
This will create a directory called `VG100` in `~` (home directory) if it doesn't exist (the `-p` flag does nothing if the directory already exists), and change the working directory into it.

2. Use the `git clone` command to clone the homework repository:
```bash
$ git clone ssh://git@focs.ji.sjtu.edu.cn:2100/homework
```

3. The files will be in `~/VG100/homework`.

If you want to retrieve new homework, use the `git pull` command in `~/VG100/homework`. Sometimes you may meet merge conflicts, you can deal with them with any modern git GUI (eg., IDEs, sourcetree).

If you can clone the repo inside WSL, but can't clone it on Git Bash, you should follow the further reading part of [SSH Key](/vg100/markdown/env.ssh).

## Homework 1

+ [h1.pdf](./h1/h1.pdf)
+ [bashcrawl.tar.bz2](./h1/bashcrawl.tar.bz2)
+ [cmd.txt](./h1/cmd.txt) ([Preview](/src/hw/h1/cmd.txt))

On macOS, the `sed` command is different from GNU-Linux `sed`, so you may need to install `gnu-sed` package on `brew`, then you can try the command with `gsed` instead of `sed`.
```bash
$ brew install gnu-sed
$ gsed 's/\([^ ]\+\)[[:space:]]*\(.*\)/\1 -> \2/g' cmd.txt
```

PS. You can unzip the `.tar.bz2` file with the command
```bash
$ tar -jxvf filename.tar.bz2
```

## Homework 2

+ [h2.pdf](./h2.pdf)

