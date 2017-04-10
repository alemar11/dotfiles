#https://github.com/qianxinfeng/vscode

#Usage
#If vs command is called without an argument, launch Visual Studio Code

#If vs is passed a directory, cd to it and open it in Visual Studio Code

#If vs is passed a file, open it in Visual Studio Code

#If vsf command is called, it is equivalent to vs ., opening the current folder in Visual Studio Code

#If svs command is called, it is like sudo vs, opening the file or folder in Visual Studio Code. Useful for editing system protected files.

if [[ $('uname') == 'Linux' ]]; then
    local _vscode_linux_paths > /dev/null 2>&1
    _vscode_linux_paths=(
        "/usr/local/bin/code"
        "$HOME/bin/code"
        "/opt/vscode/code"
    )
    for _vscode_path in $_vscode_linux_paths; do
        if [[ -a $_vscode_path ]]; then
            vs_run() { $_vscode_path $@ >/dev/null 2>&1 &| }
            vs_run_sudo() {sudo $_vscode_path $@ >/dev/null 2>&1}
            alias svs=vs_run_sudo
            alias vs=vs_run
            break
        fi
    done

elif  [[ "$OSTYPE" = darwin* ]]; then
    local _vscode_darwin_paths > /dev/null 2>&1
    _vscode_darwin_paths=(
        "/usr/local/bin/code"
        "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
        "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
    )
    for _vscode_path in $_vscode_darwin_paths; do
        if [[ -a $_vscode_path ]]; then
            vs_run () { "$_vscode_path" $* }
            vs_run_sudo () {sudo "$_vscode_path" $* }
            alias svs=vs_run_sudo
            alias vs=vs_run
            break
        fi
    done

elif [[ "$OSTYPE" = 'cygwin' ]]; then
    local _vscode_cygwin_paths > /dev/null 2>&1
    _vscode_cygwin_paths=(
        "$(cygpath $ProgramW6432/Visual\ Studio\ Code)/code.exe"
    )
    for _vscode_path in $_vscode_cygwin_paths; do
        if [[ -a $_vscode_path ]]; then
            vs_run () { "$_vscode_path" $* }
            alias vs=vs_run
            break
        fi
    done

fi

alias vsf='vs .'
