
<div align="center"><p>
    <a href="https://github.com/taurusomar/ufovim/releases/latest">
      <img alt="Latest release" src="https://img.shields.io/github/v/release/taurusomar/ufovim" />
    </a>
    <a href="https://github.com/taurusomar/ufovim/pulse">
      <img alt="Last commit" src="https://img.shields.io/github/last-commit/taurusomar/ufovim"/>
    </a>
    <a href="https://github.com/taurusomar/ufovim/blob/main/LICENSE">
      <img src="https://img.shields.io/github/license/taurusomar/ufovim?style=flat-square&logo=GNU&label=License" alt="License"
    />
    <a href="https://twitter.com/intent/follow?screen_name=chrisatmachine">
      <img src="https://img.shields.io/twitter/follow/TaurusOmar_?style=social&logo=twitter" alt="follow on Twitter">
    </a>
</p>

</div>

## Documentation
![ufovim1](https://i.imgur.com/ChqSrMW.png)

## Requirements

Neovim 0.5
```
sudo apt install neovim (debian)
sudo pacman -Sy neovim (arch)
```
Lua
```
sudo apt install lua (debian)
sudo pacman -Sy lua (arch)
```
npm 

```
sudo apt install npm (debian)
sudo pacman -Sy npm (arch)
```

Gcc
```
sudo apt install gcc (debian)
sudo pacman -Sy gcc (arch)
```
Nerds Fonts
- https://www.nerdfonts.com/font-downloads

```
/usr/share/fonts/
```
## Install UfoVim In One-Liner Command!

```bash
bash <(curl -s https://raw.githubusercontent.com/TaurusOmar/ufovim/master/utils/installer/install.sh)
```

## Exec UfoVim

```
ufovim
```

## Add Alias Zshrc & Bashrc
```
alias vim="~/.local/bin/ufovim"
````


## Install Language support

- Enter `:LspInstall` followed by `<TAB>` to see your language server options for LSP

- Enter `:TSInstall` followed by `<TAB>` to see your syntax language highlighting options

## Additional Plugins Example

- Open config.lua and adding
```
 ufovim.plugins = {
  {"usergithub/pluginnew"},
  {"folke/tokyonight.nvim"}, 
}
```
## Change Color Theme

- Edit config.lua and adding
```
ufovim.colorscheme = "github_dark_default"
```

## Which-Keys

- Space leader key


| Key         | Default Menu Lead                                                           |
|-------------|-----------------------------------------------------------------------------|
| space       | Default Menu Lead                                                           |
| Crtl+w      | Menu Windows Lead	                                                    |
| z           | Menu Line & Cursor Lead                                                     |
| g           | Menu Go-to & marks Lead                                                     |
| [           | Menu Nav Lead                                                               |

## Concept

![ufovim2](https://i.imgur.com/RAFYCsW.png)
![ufovim3](https://i.imgur.com/UkuMY1f.png)
![ufovim4](https://i.imgur.com/z1Jl2CM.png)

<div align="center" id="madewithlua">
	
[![Lua](https://img.shields.io/badge/Made%20with%20Lua-blue.svg?style=for-the-badge&logo=lua)](#madewithlua)

	
</div>
