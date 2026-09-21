"""Smoke-check the bare Neovim configuration."""

import json
import os
from pathlib import Path
import subprocess
import tempfile

REPO = Path(__file__).resolve().parents[1]
NVIM_CHECK = r"""
set nomore
function! Check() abort
  try
    call assert_equal('dotfiles', get(g:, 'colors_name', ''))
    call assert_equal(1, &termguicolors)
    call assert_equal(1, &number)
    call assert_equal(0, &relativenumber)
    execute 'edit ' . fnameescape($NVIM_TEST_FILE)
    call assert_equal('hello', getline(1))
  catch
    call add(v:errors, v:exception . ' at ' . v:throwpoint)
  endtry
  call writefile([json_encode(v:errors)], $NVIM_TEST_RESULT)
  if !empty(v:errors)
    cquit
  endif
  qa!
endfunction
autocmd VimEnter * call timer_start(0, {timer -> Check()})
"""


with tempfile.TemporaryDirectory(prefix="dotfiles-nvim-") as directory:
    base = Path(directory).resolve()
    sample = base / "sample.txt"
    sample.write_text("hello\n")
    (base / "check.vim").write_text(NVIM_CHECK)
    result = base / "result.json"
    env = dict(os.environ, NVIM_TEST_RESULT=str(result), NVIM_TEST_FILE=str(sample))
    process = subprocess.run(
        ["nvim", "--clean", "-u", str(REPO / "nvim" / "init.vim"), "-i", "NONE",
         "-n", "-es", "-S", str(base / "check.vim")],
        cwd=base, env=env, capture_output=True, text=True, timeout=20,
    )
    errors = json.loads(result.read_text()) if result.exists() else [process.stderr]
    if process.returncode != 0 or errors:
        raise AssertionError(f"{errors}\n{process.stderr}")
    print("PASS nvim: Ghostty colorscheme, line numbers, file opens")
