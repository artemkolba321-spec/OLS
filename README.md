# OLS v0.2.1
OLS (Open Linux Shell) - This is a project aimed at improving the work with the terminal.

## installation
clone the code
```Bash
$ git clone git@github.com:artemkolba321-spec/OLS.git
$ cd OLS
```
next initialization
- if Bash
```Bash
$ bash ./init.sh
```
- if Zsh
```Bash
$ zsh ./init.sh
```
everything is ready
## philosophy
1. **Everything must be logged**  
   - All actions are recorded, making it easy to spot errors (EE) and trace what happened.

2. **OLS is a friendly set of programs**  
   - Minimal unnecessary flags  
   - Clear and consistent helpers (`--help` and `hp`)  
   - Commands work intuitively, even for advanced workflows.

3. **Designed for pipelines**  
   - All tools are pipeline-friendly, allowing chaining of commands effortlessly.  
   - Supports standard Linux streams (stdin/stdout/stderr) for maximum flexibility.
4. **All packages are downloaded from the Internet.**
   - no internet required
   - predictability
   - the user learns once

