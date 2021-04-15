if exists('s:did_load')
    finish
endif
let s:did_load = 1

if !exists("g:prj_config_path")
    let g:prj_config_path = ".prjrc"
endif
if !exists("g:prj_authorized_path")
    let g:prj_authorized_path = "$HOME/.cache/vim-prj"
endif

function! s:get_filename()
    return g:prj_config_path
endfunction

function! s:base64(data)
    return system("echo ".a:data. " | base64")
endfunction

function! s:setup_cache()
    call system("mkdir -p ".g:prj_authorized_path)
endfunction

function! s:get_config_files()
    let files = findfile(s:get_filename(), expand(".;$HOME/"), -1)
    call map(files, "fnamemodify(v:val, ':p')")
    call uniq(sort(files))
    call filter(files, "v:val != '".expand("$HOME/".s:get_filename())."'")
    return files
endfunction

function! s:get_auth_path(path)
    let b64_path = s:base64(a:path)
    return g:prj_authorized_path."/".b64_path
endfunction

function! s:is_authorized(config_path)
    let auth_path = s:get_auth_path(a:config_path)
    call system("sha256sum --quiet --check ".auth_path)
    return v:shell_error == 0
endfunction

function! s:authorize(path)
    call s:setup_cache()
    let auth_path = s:get_auth_path(a:path)
    call system("sha256sum ".a:path." > ".auth_path)
endfunction

function! s:load_config()
    let unauth_configs = []
    let configs = s:get_config_files()

    for config in configs
        if s:is_authorized(config) == 1
            continue
        endif

        call add(unauth_configs, config)
    endfor

    if !empty(unauth_configs)
        let ss = "Unauthorized configs:\n"
        let ss = ss.join(map(copy(unauth_configs), '"- ".v:val."\n"'), '')
        let authorize = input(ss."Authorize all? (y/N) ")
        if authorize != 'y'
            return
        endif

        for c in unauth_configs
            call s:authorize(c)
        endfor
    endif

    for config in configs
        exec "source ".config
    endfor
endfunction

function! prj#reload()
    let configs = s:get_config_files()
    if empty(configs)
        echo "config not found!"
        return
    endif

    call s:load_config()
endfunction

function! prj#edit()
    let configs = s:get_config_files()
    if empty(configs)
        exec "edit ".s:get_filename()
        return
    endif

    exec "edit ".configs[-1]
endfunction

augroup prj
    autocmd!
    autocmd VimEnter * call s:load_config()
augroup END
