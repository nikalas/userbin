# Userbin

Short scripts to make your life easier.

## Dependencies

Most of the scripts are dependant on

- [zsh](https://www.zsh.org/) Shell
- [git](https://git-scm.com/) Version Control
- [fzf](https://github.com/junegunn/fzf) fuzzy finder
- [fd](https://github.com/sharkdp/fd) fast find
- [bat](https://github.com/sharkdp/bat) cat with wings
- [awk](https://www.gnu.org/software/gawk/manual/gawk.html)
- [sed](https://www.gnu.org/software/sed/manual/sed.html)

## Installation

1. Clone the repository to your home directory
2. Add the following to your `.zshrc`:

```bash
# add user scripts to PATH
path+=($HOME/bin/)

# Exclude .git from PATH
new_path=()
for p in $path; do
    if [[ "$p" != "$HOME/bin/.git" && "$p" != *".md" ]]; then
        new_path+=($p)
    fi
done
path=($new_path)

export PATH
```
