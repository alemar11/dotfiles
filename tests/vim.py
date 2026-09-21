"""Smoke-check the bare Vim configuration."""

import json
import os
from pathlib import Path
import subprocess
import tempfile

REPO = Path(__file__).resolve().parents[1]
VIM_CHECK = r"""
set nomore
function! Check() abort
  try
    call assert_false(exists('g:plug_home'))
    call assert_true(empty(globpath(&runtimepath, 'autoload/which_key.vim')))
    call assert_true(empty(globpath(&runtimepath, 'autoload/lsp.vim')))
    call assert_true(!exists('g:colors_name') || g:colors_name !=# 'dotfiles')
    call assert_equal('', &omnifunc)
    call assert_equal('', maparg(' ', 'n'))
    call assert_equal(0, &conceallevel)
    execute 'edit ' . fnameescape($VIM_TEST_FILE)
    call assert_equal('hello', getline(1))
  catch
    call add(v:errors, v:exception . ' at ' . v:throwpoint)
  endtry
  call writefile([json_encode(v:errors)], $VIM_TEST_RESULT)
  if !empty(v:errors)
    cquit
  endif
  qa!
endfunction
autocmd VimEnter * call timer_start(0, {timer -> Check()})
"""


with tempfile.TemporaryDirectory(prefix="dotfiles-vim-") as directory:
    base = Path(directory).resolve()
    sample = base / "sample.txt"
    sample.write_text("hello\n")
    (base / "check.vim").write_text(VIM_CHECK)
    result = base / "result.json"
    env = dict(os.environ, VIM_TEST_RESULT=str(result), VIM_TEST_FILE=str(sample))
    process = subprocess.run(
        ["vim", "-Nu", str(REPO / "vimrc"), "-i", "NONE", "-n", "-es",
         "-S", str(base / "check.vim")],
        cwd=base, env=env, capture_output=True, text=True, timeout=20,
    )
    errors = json.loads(result.read_text()) if result.exists() else [process.stderr]
    if process.returncode != 0 or errors:
        raise AssertionError(f"{errors}\n{process.stderr}")
    print("PASS vim: no plugins, no custom colorscheme, file opens")
