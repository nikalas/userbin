# Userbin

Short scripts to make your life easier.

## Dependencies

Most of the scripts are dependant on

| Dependency | Description     |
| ---------- | --------------- |
| zsh        | Shell           |
| git        | Version Control |
| fzf        | Fuzzy Finder    |
| fd         | Fast Find       |
| bat        | Cat with Wings  |
| awk        | Text Processing |
| sed        | Text Processing |

## Installation

1. Clone the repository to your home directory as `bin`

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
