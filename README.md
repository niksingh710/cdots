<p align="center" style="color:grey">

![image](https://github.com/niksingh710/cdots/assets/60490474/17f50b3e-2fdf-4914-b396-475574afeb68)

<div align="center">
<table>
<tbody>
<td align="center">
<img width="2000" height="0"><br>

These are my dot files for Commandline Instance on my system.<br>
I use **[Arch Linux](https://archlinux.org)** as My main OS and **[Zsh](https://www.zsh.org/)** as my Shell and **[Tmux](https://github.com/tmux/tmux)** as my Multiplexer.<br>
The configuration highly uses **[Fzf](https://github.com/junegunn/fzf)** and **[Vim](https://github.com/vim/vim)** style key binding and **[Starship](https://github.com/starship/starship)** for Shell Prompt.<br>

![GitHub repo size](https://img.shields.io/github/repo-size/niksingh710/cdots)
![GitHub Org's stars](https://img.shields.io/github/stars/niksingh710%2Fcdots)
![GitHub forks](https://img.shields.io/github/forks/niksingh710/cdots)
![GitHub last commit](https://img.shields.io/github/last-commit/niksingh710/cdots)

<img width="2000" height="0">
</td>
</tbody>
</table>
</div>
</p>

### Prerequisites

```bash
yay -S fd ripgrep shellcheck-bin shfmt advcpmv bat lsd git glow urlview git-secret \
  starship tmux fzf zoxide ssh zsh zsh-completions-git \
  trash-cli xstow ttf-jetbrains-mono-nerd 
```

### Setup

Setup is done by using `stow` command. I use xstow a fork of stow command.<br>
This command will place the files in the correct location.

```bash
xstow home -t ~
xstow bin -t ~/.local/bin
xstow .config -t ~/.config
````

### Structure
`.zshrc` is in home Dir that contains all `zsh` related config.<br>
`~/.shell` dir contains:<br> 
  - `path` file that adds all path's from the array to `$PATH` variable without cluttering it.
  - `aliases` file that contains all the aliases with utility fns.
`~/.local/bin` contains all the binaries required by the configuration.

# Preview

#### Starship prompt
> [!Note]
> I have a custom function in my zshrc to make my starship prompt Transient. <br>
(Transient) prompt is when the prompt is visible for only the current input and previous input just contains a symbol.

![image](https://github.com/niksingh710/cdots/assets/60490474/1c1bff31-eb4f-43e7-8dd4-e55892622977)

#### Fzf
I have my fzf setted up via `~/.shell/fzf.zsh` where i perform mapping for fzf and setup `preview` script.<br>
**preview** script can preview text files, list dir's and also show images in fzf preview pane.


<div align="center">

| Mapping | Action |
| - | - |
| `Ctrl-j`  | Move down |
| `Ctrl-k`  | Move Up |
| `Ctrl-t` | List files in current dir |
| `Alt-c` | List dir in current location |
| `Ctrl-r` | Search throught Hitory |
| `Ctrl-/` | Search for aur package with info to install|
| `Ctrl-Alt-/` | Search for aur package with info to remove |
| `Ctrl-space` (fzf list) | Select in multiple Selection |
| `Ctrl-/` (fzf list) | DeSelect in multiple Selection |
</div>

| ![image](https://github.com/niksingh710/cdots/assets/60490474/6ab40586-9978-4b8c-b944-f0343e180b6a) | ![image](https://github.com/niksingh710/cdots/assets/60490474/bf5cf7cf-b5bc-4d59-92ed-d73c71f15df8) |
| - | - |

### Zsh

I have setted up my zsh using **[znap](https://github.com/marlonrichert/zsh-snap)** plugin manager.<br>
It makes plugin installation and completions management a breeze.

- I use Vim mode for navigation in zsh. `jk` can be pressed in quick succession to switch in vim Mode. <br>
- `Ctrl-Space` is to complete throught the ghost text shown on the terminal. <br>
- In Completion option `j,k,l,h` vim navigations can be used. 

<video loop autoplay src="https://github.com/niksingh710/cdots/assets/60490474/fe221a84-e321-4d9b-a339-695660635a6a"></video>


>[!Note]
> Nothing extra is required to be done zsh will automatically install everything.

#### Yay

I use `yay` as my aur helper.
Below is the commnad to be setup yay to ignore annoying questions regarding installs.<br>
This will also force yay to check for git packages if they need rebuilding.

```
yay --save --answerclean "None" --answerdiff "None" --removemake --cleanafter --devel
```
#### Vim

Quick vim setup for TTY. if don't want to setup whole shell

```

curl https://raw.githubusercontent.com/niksingh710/cdots/master/shell/.vimrc > ~/.vimrc

```

<details>

  <summary style="font-weight:bold; font-size: 18px;">
    Tools
  </summary>

- **Node**
  - For Node js i recommend using [fnm](https://github.com/Schniz/fnm). My `~/.shell/path` already includes it as in path i only need to install it.
- Rust
  - Rustup for rust

</details>
