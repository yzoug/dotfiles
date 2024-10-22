# yzoug's dotfiles

Hello! These are my dotfiles. Here is some of the software I use:

- sway as a Wayland compositor
- wayfire as a status bar
- alacritty as a terminal emulator
- neovim as my editor
- zsh as my shell
- the Tokyo Night colorscheme
- starship as a shell prompt, zoxide as a cd replacement, direnv for environment vars, slurp/grim for screenshots...

Some of these configs are shamelessly stolen on the Internet over the years, other I wrote myself. I *sometimes try to* credit the source in a comment.

## Chezmoi

I use [chezmoi](https://www.chezmoi.io/) to manage these files. Once installed, if you are me, you can configure a new machine by doing:

```
chezmoi init https://github.com/yzoug/dotfiles.git
chezmoi diff
chezmoi apply -v
chezmoi update -v # for keeping a machine synced with the repo
```

If you're happy with these configs, you should probably fork this repo and make your changes (remember, no secrets in a git repo, so no secrets in your config files!). Then you can use the commands above to setup your machine(s).