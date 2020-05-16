# Environment Setup

In this tutorial, we will help you setup a basic development environment on your operating system.

## Package Manager

> A package manager or package-management system is a collection of software tools that automates the process of installing, upgrading, configuring, and removing computer programs for a computer's operating system in a consistent manner.
>
> -- <cite>[Wikipedia](https://en.wikipedia.org/wiki/Package_manager)</cite>

In this course, a system-level package manager is **not mandatory**, but we strongly encourage you to install one.
+ On most Linux Distributions (including WSL), there is a shipped package manager.
+ On macOS, you need to install one yourselves.
+ On Windows, you should use WSL in this course, but you can also choose to install a package manager for advanced usages.


### Windows 10 with WSL (Windows Subsystem for Linux)

If you want to work on Windows in this course, you should use WSL (Windows Subsystem for Linux).

Ensure that you are using an administrative shell. Press Win+X, you will find `Windows PowerShell (Administrator)`, and paste

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

This will enable WSL as a service. Then you will be asked to reboot the system.

After the reboot, open the Windows Store and search for `Ubuntu` with a version, eg., 18.04, 20.04, and install it. You can also use other Linux Distributions, such as `Debian`, `openSUSE`, `Fedora`, and etc. However, these distributions won't be documented in this tutorial, so if it's your first time trying Linux, follow our official instructions on `Ubuntu`.

You can refer to https://docs.microsoft.com/en-us/windows/wsl/install-win10 if meeting any problems.

After the installation, start `Ubuntu` in the start menu, and follow the instruction below.

### Linux Debian / Ubuntu

For installation of Ubuntu (without WSL), you can refer to the [ve280 guide](https://github.com/ve280/tutorials).

On `Debian` based systems, the package manager is called `apt`. You also need a superuser (administrator) privilege to install packages, so you need to use `sudo`, which means "superuser do".

The official repository of Debian / Ubuntu may be very slow, you can switch them to the [tuna mirror](https://mirror.tuna.tsinghua.edu.cn/help/ubuntu/).

Select the correct system version in the webpage above, and paste them into `/etc/apt/sources.list`.

For example, for Ubuntu 20.04, the lines will be

```
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse

# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse
```

First, backup the `/etc/apt/sources.list` file

```bash
$ sudo mv /etc/apt/sources.list /etc/apt/sources.list.backup
```

Then you can use `vim` or `nano` to edit the file.

For `vim`, type `sudo vim /etc/apt/sources.list`. Then press `i`, and paste the lines **with mouse**. Finally press `Esc` and then `Shift+Z+Z` to save the file and exit the editor.

For `nano`, type `sudo nano /etc/apt/sources.list`. Then paste the lines **with mouse**. Then press `Ctrl+O` and then `Enter` to save the file. Finally press `Ctrl+X` to exit the editor.

After changing the source, you can install packages very fast. For example, if you want to install `git`, simply type in

```bash
$ sudo apt update
$ sudo apt install git
```

### Arch Linux / Manjaro

For installation of Manjaro Linux, refer to https://manjaro.org/.

On `Arch` based systems, the package manager is called `pacman`. You also need a superuser (administrator) privilege to install packages, so you need to use `sudo`, which means "superuser do".


Changing the mirror of `pacman` is very easy, for example, if you need a mirror in China, you can use `pacman-mirrors` to automatically find the best mirror in China, with

```bash
$ sudo pacman-mirrors --country China
```

Then if you want to install `git`, simply type in

```bash
$ sudo pacman -Syyu git
```

### macOS

There are many package managers on macOS, eg,. `MacPorts` and `brew`. Here we'll introduce how to install `brew` and install packages with it.

```bash
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

Paste the command into the terminal to install `brew`. If you find the installation of packages is too slow, you can also use the [tuna mirror](https://mirror.tuna.tsinghua.edu.cn/help/homebrew/), follow the instructions on it.

But in most situation, you can use `brew` directly. For example, if you want to install `git`, simply type in

```bash
$ brew install git
```

## IDE (Integrated Development Environment)

> An integrated development environment (IDE) is a software application that provides comprehensive facilities to computer programmers for software development. An IDE normally consists of at least a source code editor, build automation tools and a debugger.
>
> -- <cite>[Wikipedia](https://en.wikipedia.org/wiki/Integrated_development_environment)</cite>

In this course, using an IDE is also **not mandatory**, but we can't imagine why you are not willing to use one.

### JetBrains WebStorm

You can download the WebStorm IDE [here](https://www.jetbrains.com/webstorm/), or you can download the [Toolbox App](https://www.jetbrains.com/toolbox-app/) and install WebStorm in it. The Toolbox App can manage the updates of all JetBrains IDEs, which is preferred by us.

In order to use WebStorm for free, you need to register a JetBrains Account and apply for a [student license](https://www.jetbrains.com/shop/eform/students). If you have already used CLion in VG101, you can use the same account and do not need to apply again.

By the way, this project is developed by WebStorm :)

### VSCode

TODO: Maybe some TA who uses VSCode can help on this section...


### Sublime Text

TODO: Maybe some TA who uses Sublime Text can help on this section...


## Further Readings

### Package Manager on Windows

[Chocolatey](https://chocolatey.org/) is a package manager for Windows, you only need a PowerShell (which is shipped with Windows 10) and run one line of command to install it.

First, ensure that you are using an administrative shell. Press Win+X, you will find `Windows PowerShell (Administrator)`.

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

Paste the command into your PowerShell and press Enter, wait a few seconds for the command to complete. If you don't see any errors, you are ready to use Chocolatey!

Now Type `choco` to examine the installation, the output should be like

```
Chocolatey v0.10.15
Please run 'choco -?' or 'choco <command> -?' for help menu.
```

Though there are many functionalities in `choco`, you may only need `choco install` to install packages. You can explore other commands later. For example, if you want to install `git`, simply type in

```powershell
choco install -y git
```

and then git will be installed on your Windows after a while.


## References

1. [Wikipedia - Package Manager](https://en.wikipedia.org/wiki/Package_manager)
2. [Wikipedia - IDE](https://en.wikipedia.org/wiki/Integrated_development_environment)
3. [VE280 Tutorials](https://github.com/ve280/tutorials)
4. [TUNA Mirrors](https://mirror.tuna.tsinghua.edu.cn)
