if exists('s:loaded_prj')
    finish
endif
let s:loaded_prj = 1

if !exists("g:prj_config_path")
    let g:prj_config_path = ".prjrc"
endif
if !exists("g:prj_authorized_path")
    let g:prj_authorized_path = "$HOME/.cache/vim-prj"
endif

call prj#reload()
