# vim-prj

A per project vimrc based on [direnv](https://direnv.net/).

## Install

### vim-plug

```vim
Plug 'emersonmx/vim-prj'
```

## Usage

- Run `vim`
- Edit the config file with `:call prj#edit()`
- Add anything you want
- Save the config file
- Run `call prj#reload()` to reload config files

## Commands

```vim
call prj#reload  " Reload config files (`.vim/vimrc` by default).
call prj#edit()  " Edit the config file.
```

## Configuration

```vim
let g:prj_config_path     = ".vim/vimrc"
let g:prj_authorized_path = "$HOME/.cache/vim-prj"
```
