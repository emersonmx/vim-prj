if exists('s:did_load')
    finish
endif
let s:did_load = 1

let g:prj_config_path = ".vim"
let g:prj_config_filename = "vimrc"
let g:prj_cache_path = "$HOME/.cache/vim-prj"
let g:prj_authorized_path = g:prj_cache_path."/authorized"

function! s:get_filename()
    return g:prj_config_path."/".g:prj_config_filename
endfunction

function! s:get_config_path()
    let filename = s:get_filename()
    let filepath = findfile(filename, ";")
    if empty(filepath)
        return
    endif
    return fnamemodify(filename, ":p")
endfunction

function! s:base64(data)
    return system("echo ".a:data. " | base64")
endfunction

function! s:setup_cache()
    call system("mkdir -p ".g:prj_authorized_path)
endfunction

function! s:get_auth_path(path)
    let b64_path = s:base64(a:path)
    return g:prj_authorized_path."/".b64_path
endfunction

function! s:is_authorized()
    let config_path = s:get_config_path()
    if empty(config_path)
        return 0
    endif

    let auth_path = s:get_auth_path(config_path)
    call system("sha256sum --quiet --check ".auth_path)
    return v:shell_error == 0
endfunction

function! s:load_config()
    let config_path = s:get_config_path()
    if empty(config_path)
        return
    endif

    if !s:is_authorized()
        echo "Unable to source \"".config_path."\".
            \ Authorize with \"call prj#allow()\"."
        return
    endif

    exec "source ".config_path
endfunction

function! prj#load()
    let config_path = s:get_config_path()
    if empty(config_path)
        echo "config not found!"
        return
    endif

    call s:load_config()
endfunction

function! prj#allow()
    let config_path = s:get_config_path()
    if empty(config_path)
        echo "config not found!"
        return
    endif

    call s:setup_cache()

    let auth_path = s:get_auth_path(config_path)
    call system("sha256sum ".config_path." > ".auth_path)

    call s:load_config()
endfunction

function! prj#disallow()
    let config_path = s:get_config_path()
    if empty(config_path)
        echo "config not found!"
        return
    endif

    call s:setup_cache()

    let auth_path = s:get_auth_path(config_path)
    call system("rm -f ".auth_path)
    call s:load_config()
endfunction

function! prj#edit()
    let config_path = s:get_config_path()
    if empty(config_path)
        call system("mkdir -p ".g:prj_config_path)
        call system("touch ".s:get_filename())
        call prj#edit()
        return
    endif

    exec "edit ".config_path
endfunction

augroup prj
    autocmd!
    autocmd VimEnter * call s:load_config()
augroup END
