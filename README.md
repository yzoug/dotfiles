# yzoug's dotfiles

Hello! These are my dotfiles. Here is some of the software I use:

- sway as a Wayland compositor
- waybar as a status bar
- alacritty as a terminal emulator
- neovim as my editor (has [its own config repo](https://github.com/yzoug/kickstart.nvim) forked from kickstart.nvim)
- zsh as my shell
- tmux as a multiplexer
- the Tokyo Night colorscheme
- the Adobe Source Code Pro "nerd" font (ttf-sourcecodepro-nerd)
- ArchLinux as my Linux distribution
- starship as a shell prompt, zoxide as a cd replacement, direnv for environment vars, slurp/grim for screenshots...

Some of these configs are shamelessly stolen on the Internet over the years, others I wrote myself. I *sometimes try to* credit the source in a comment, or for recent changes in the git commit.

## Screenshots

![Screenshot desktop 1](https://github.com/user-attachments/assets/2b64d5f7-e72c-4cf1-a752-0f7c7740281c)

Two `alacritty` terminals in floating mode. `fastfetch`, `starship`, `zsh-autosuggestions`.

![Screenshot desktop 2](https://github.com/user-attachments/assets/56a2faaf-5ff7-42b1-9a1a-d245e1d2e29e)

Three terminals in tiling mode. `pipes-rs`, `neovim`.

## Chezmoi

I use [chezmoi](https://www.chezmoi.io/) to manage these files. Once installed, if you are me, you can configure a new machine by doing:

```
chezmoi init https://github.com/yzoug/dotfiles.git
chezmoi diff
chezmoi apply -v
chezmoi update -v # for keeping a machine synced with the repo
```

If you're happy with these configs, you should probably fork this repo and make your changes (remember, no secrets in a git repo, so no secrets in your config files!). Then you can use the commands above to setup your machine(s).
