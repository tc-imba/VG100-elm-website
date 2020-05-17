# Shell Scripting

Note: This tutorial will only work on a **Unix** like environment (eg,. WSL, Linux, macOS, maybe Git Bash).

The `$` symbol means that this line should be executed in a shell.

All of the following should work in a modern shell (eg., `bash`, `zsh`), but may not work in `sh`.

## Introduction

> The command line interface is often faster that graphical user interfaces. Commands are usually simple and well documented.
>
> A shell script is a program meant to be run by the command line interpreter; it often consists in a list of command lines together with some loops and conditional statements, everything being stored in a file with a `.sh` suffix.
>
> Knowing the basics on how to use the command line interface to write simple scripts can highly simplify your life all along your studies and even in your future career.
>
> -- <cite>[Homework 1](./../hw/h1/h1.pdf)</cite>


### Create a shell script

A shell script is also a text file, you can simply create a text file with the `touch` command, and then give execution permission `+x` to it. For example,

```bash
$ touch filename.sh
$ chmod +x filename.sh
```

Then you can edit the file with any text editor you like. You can use `nano` or `vim`, or GUI editors, IDEs. Most of GUI editors and IDEs have a support of shell scripting (maybe you need to install some plugins).

If you don't give the execution permission, you can use a shell to run it

```bash
$ bash filename.sh
```

If you give the execution permission, you can directly run it

```bash
$ ./filename.sh
```

Note that `./` can't be omitted here because for the first argument (the executable) in shell, if `./` is not added, the shell will only find the executable name in system path, but not under the current directory.

### The shebang ("bang") line

In the first line of a shell script, there is usually a shebang line to indicate an interpreter for execution under UNIX / Linux operating systems.

For example, if you want to use `bash`, add this line:

```bash
#!/bin/bash
```

If you do not specify an interpreter line, the default is usually the `/bin/sh`. But, it is recommended that you set the line.

Sometimes you may find a script with

```bash
#!/usr/bin/env bash
```

The `/usr/bin/env` run a program such as a bash in a modified environment. It makes your bash script portable. The advantage of `#!/usr/bin/env bash` is that it will use whatever bash executable appears first in the running user's `$PATH` variable.




## Basics

### Variables

You can define (assign) variables directly:

```bash
a=asd b=qwe
```

This will assign a string `asd` to the variable `a`, and a string `qwe` to the variable `b`. Note that there can not be any space around the `=`, the space is used for multiple assignment on one line.

### Echo

You can use `$a`, or `${a}` to get the value of the variable `a`. Then you can print the variable with the command `echo`.

```bash
echo $a    # display the content of variable a
echo $1    # first argument to the script
echo $2    # second argument to the script, more arguments $3, $4...
echo $@    # all the arguments
echo $?    # exit code from the previous command
```

Anything following `#` is a comment. The `1`, `2`, `@`, `?` are predefined variables in a shell.

### Quotes

Single and Double Quotes can be used. The difference:
+ Enclosing characters in single quotes (`'`) preserves the literal value of each character within the quotes. A single quote may not occur between single quotes, even when preceded by a backslash.
+ Enclosing characters in double quotes (`"`) preserves the literal value of all characters within the quotes, with the exception of `$`, `` ` ``, `\` A double quote may be quoted within double quotes by preceding it with a backslash (`\"`).

For example,

```bash
a=asd
echo "${a}''\"" # output asd''"
echo '${a}"'    # output ${a}"
```

### Evaluation and Math Operations

You can use `$()` to evaluate a command.

```bash
a=$(pwd)
echo $a   # print working directory
```

The oldest command for doing arithmetic operations in bash is `expr`. This command can work with integer values only and prints the output directly in the terminal.

```bash
expr 10+30               # output 10+30 (wrong)
expr 10 + 30             # output 40
expr 30 % 9              # output 3
myVal=$( expr 30 - 10 )
echo $myVal              # output 20
```

`let` is another built-in command to do arithmetic operations in bash. `let` command can’t print the output to the terminal without storing the value in a variable. But `let` command can be used to remove the other limitations of the `expr` command.

```bash
let val1=9*3
echo $val1               # output 27
let "val2 = 8 / 3"
echo $val2               # output 2
```

However, `expr` and `let` are not recommended to use in `bash` now. Using double brackets `(( ))` is a better method.

```bash
val1=$((10*5+15))
echo $val1               # output 65
 
# Using post or pre increment/decrement operator
((val1++))
echo $val1               # output 66
val2=41
((--val2))
echo $val2               # output 40
 
# Using shorthand operator
(( val2 += 60 ))
echo $val2               # output 100
 
# Dividing 40 by 6
(( val3 = 40/6 ))        
echo $val3               # output 6

# Random Number
val4=$(($RANDOM%20))
echo $val4               # output integers in [0,20) randomly
```

### Advanced Usages

Refer to bash man page for more advanced operations on variables, eg.,

```bash
a="123 4.jpg";
echo ${a%.jpg} ${a:2,3} # extract partial content from variable a
echo ${#a}              # get the length of variable a
```

## Conditional Statements

### Expressions

`[ ]` can be used to test an expression, `man test` for more details. Following are some other conditional expressions that are helpful.

```bash
[ expr = value ]    # returns true if the expression is equal to value
[ expr1 -eq expr2 ] # returns true if expr1 is equal to expr2
[ expr1 -gt expr2 ] # returns true if expr1 is greater than expr2
[ expr1 -lt expr2 ] # returns true if expr1 is less than expr2
[ -e filepath ]     # returns true if file exists.
[ -x filepath ]     # returns true if file exists and executable.
```

You can use `&&` for and and `||` for or between expressions

```bash
[ expr1 ] && [ expr2 ] 
[ expr1 ] || [ expr2 ] && [ expr3 ] || [ expr4 ] 
```

You can also use `&&` and `||` like ternary operator (`?`) in C/C++:
```bash
[ $a = "qwe" ] && echo true || echo false
```

With the expressions you can write conditional statements.

### If Statement

```bash
if [ $a = "qwe" ] ; then
  list of statements
elif [ $a = "ewq" ] ; then
  list of statements
else
  list of statements
fi
```

### Case Statement

```bash
case $i in
  a) list of statements
  ;;
  b) list of statements
  ;;
  *) list of statements #default actions
esac
```

### Bash Style Expressions

For `bash` and some other shells (`zsh`, etc.), you can use double brackets `[[ ]]` or `(( ))` for more powerful and flexible usage than `[ ]`.
+ `[[ ]]` is for strings and `(( ))` is for integer logic and arithmetic
+ `&&` and `||` operators can be used inside `[[ ]]` and `(( ))`, and `()` can be used for grouping
+ No need to quote variable expansions inside `[[ ]]` or `(( ))`
+ Inside `(( ))`, there is no need for a `$` before variable names to expand them
+ `[[ ]]` and `(( ))` can span multiple lines, without the need for a line continuation with `\`
+ You can use `!`, `!=`, `==`, `<`, `<=`, `>`, `>=`, and etc.

For example,

```bash
a=1 b=2 c=3
((a == 2 || (b == 2 && c == 3))) && echo yes                   # yields yes

x=apple y=mango z=pear
[[ $x == orange || ($y == mango && $z == pear) ]] && echo yes  # yields yes
```

It is equivalent to
```bash
[ "$a" -eq 2 ] || { [ "$b" -eq 2 ] && [ "$c" -eq 3 ]; }
[ "$x" == orange ] || { [ $y == mango ] && [ "$z" == pear ]; }
```

There are many more usages of bash style expressions, check the manual yourselves.

## Loops

### For Loop

Print all filenames:
```bash
for i in $(ls); do
  echo item: $i
done
```

C-like for:
```bash
for ((i=0; i<10; i++)) ; do
  echo item: $i
done
```

### While Loop

```bash
COUNTER=0
while [ $COUNTER -lt 10 ]; do
  echo The counter is $COUNTER
  let COUNTER=COUNTER+1 
done
```

## Arrays

### Simple Array

You can define an array of two elements `Hello` and `World`, and print them:

```bash
arr=(Hello World)
echo ${arr[0]} ${arr[1]}
```

The braces `{}` are required to avoid conflicts with pathname expansion.

In addition the following funky constructs are available:

```bash
${arr[*]}         # All of the items in the array
${!arr[*]}        # All of the indexes in the array
${#arr[*]}        # Number of items in the array
${#arr[0]}        # Length of item zero
```

### Associative Array

You can define an associative array (dict) by `declare -A`

```bash
declare -A b=([key1]=value1 [key 2]=value2)
echo ${b[key1]}
echo ${b[key2]}
echo ${b[key 2]}
c=key1
echo ${b[$c]}
```

## Functions

### Definition

You can define a function similar to C format
```bash
function_name () {
  commands
}
```

Or in a single line:
```bash
function_name () { commands; }
```

### Variables Scope

Global variables are variables that can be accessed from anywhere in the script regardless of the scope. In Bash, all variables by default are defined as global, even if declared inside the function.

Local variables can be declared within the function body with the local keyword and can be used only inside that function. You can have local variables with the same name in different functions.

```bash
var1='A'
var2='B'

my_function () {
  local var1='C'
  var2='D'
  echo "Inside function: var1: $var1, var2: $var2"
}

echo "Before executing function: var1: $var1, var2: $var2"
my_function
echo "After executing function: var1: $var1, var2: $var2"
```

The output is
```
Before executing function: var1: A, var2: B
Inside function: var1: C, var2: D
After executing function: var1: A, var2: D
```

### Return Value

Unlike functions in "real" programming languages, Bash functions don’t allow you to return a value when called. When a bash function completes, its return value is the status of the last statement executed in the function, 0 for success and non-zero decimal number in the 1 - 255 range for failure.

The return status can be specified by using the return keyword, and it is assigned to the variable `$?`. The return statement terminates the function. You can think of it as the function’s exit status.

```bash
my_function () {
  echo "some result"
  return 55
}

my_function  # output some result
echo $?      # output 55
```

### Arguments

The arguments are similar to the global script arguments
+ The passed parameters are `$1`, `$2`, `$3`, ..., `$n`, corresponding to the position of the parameter after the function’s name.
+ The `$0` variable is reserved for the function’s name.
+ The `$#` variable holds the number of positional parameters/arguments passed to the function.

## References

1. https://bash.cyberciti.biz/guide/
2. https://www.thegeekstuff.com/2010/06/bash-conditional-expression/
3. https://linuxhint.com/bash_arithmetic_operations/
4. https://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO-7.html
5. https://stackoverflow.com/questions/11267569/compound-if-statements-with-multiple-expressions-in-bash
6. https://stackoverflow.com/questions/6697753/difference-between-single-and-double-quotes-in-bash
7. https://www.jianshu.com/p/7fd317a45be5
8. https://www.linuxjournal.com/content/bash-arrays
9. https://linuxize.com/post/bash-functions/
