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
- Run `call prj#allow()` to allow the config file loading

## Commands

```vim
call prj#load()     " Loads the config file (`.vim/vimrc` by default).
call prj#allow()    " Allow config file loading.
call prj#disallow() " Disallow config file loading.
call prj#edit()     " Edit project config file.
```

## Configuration

```vim
let g:prj_config_path     = ".vim"
let g:prj_config_filename = "vimrc"
let g:prj_authorized_path = "$HOME/.cache/vim-prj"
```
