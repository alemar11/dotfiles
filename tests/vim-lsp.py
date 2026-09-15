"""Integration checks against installed Vim/plugins/servers, using temporary projects."""

import json
import os
from pathlib import Path
import subprocess
import tempfile
import venv

REPO = Path(__file__).resolve().parents[1]
VIM_CHECK = r"""
set nomore
let g:lsp_log_file = $VIM_TEST_LOG
function! WaitFor(expression) abort
  let started = reltime()
  while !eval(a:expression) && reltimefloat(reltime(started)) < 15
    sleep 50m
  endwhile
  if !eval(a:expression)
    throw 'Timed out: ' . a:expression . ' (at ' . expand('%:p') . ':' . line('.') . ')'
  endif
endfunction
function! Check() abort
  try
    let g:server = $VIM_TEST_SERVER
    call WaitFor('lsp#get_server_status(g:server) ==# "running"')
    call WaitFor('has_key(DotfilesWhichKeyMenu(), "l")')
    call assert_equal(resolve($VIM_TEST_ROOT), resolve(lsp#utils#uri_to_path(lsp#get_server_root_uri(g:server))))
    call assert_equal(resolve($VIM_TEST_CWD), resolve(getcwd()))
    call assert_equal('', maparg('gr', 'n'))
    call assert_equal('', maparg('gi', 'n'))
    call assert_equal(':LspReferences<CR>', maparg(' lr', 'n'))
    call assert_equal(':LspRename<CR>', maparg(' lR', 'n'))
    call assert_equal('lsp#complete', &omnifunc)
    if g:server ==# 'pyright'
      let config = lsp#utils#workspace_config#get(g:server)
      call assert_equal($VIM_TEST_PYTHON, get(get(config, 'python', {}), 'pythonPath', ''))
      call assert_equal($VIM_TEST_ACTIVE_VENV, $VIRTUAL_ENV)
      call WaitFor('!empty(lsp#internal#diagnostics#state#_get_all_diagnostics_grouped_by_server_for_uri(lsp#utils#get_buffer_uri()))')
      let diagnostics = lsp#internal#diagnostics#state#_get_all_diagnostics_grouped_by_server_for_uri(lsp#utils#get_buffer_uri())
      call assert_equal([], diagnostics.pyright.params.diagnostics)
      call assert_false(has_key(DotfilesWhichKeyMenu().l, 'f'))
      call assert_equal('', maparg(' lf', 'n'))
    elseif g:server ==# 'typescript-language-server'
      call assert_true(has_key(DotfilesWhichKeyMenu().l, 'f'))
      let options = lsp#get_server_info(g:server).initialization_options.tsserver
      call assert_false(has_key(options, 'path'))
      call assert_true(filereadable(options.fallbackPath))
      call WaitFor('join(readfile(g:lsp_log_file), "\n") =~# "typescriptVersion"')
    endif
    call cursor(str2nr($VIM_TEST_CALL_LINE), 1)
    call search('greet', 'c')
    call assert_equal(':LspDefinition<CR>', maparg('gd', 'n'))
    " Vim suppresses mappings in timer callbacks; test the mapped command here.
    LspDefinition
    call WaitFor('resolve(expand("%:p")) ==# resolve($VIM_TEST_DEFINITION) && line(".") == 1')
    if g:server ==# 'pyright'
      " Jumping into a dependency must keep the original project's environment.
      call assert_equal(config, lsp#utils#workspace_config#get(g:server))
    endif

    " Filetype changes in the same buffer must also remove obsolete mappings.
    let original_filetype = &filetype
    setlocal filetype=text
    call assert_false(has_key(DotfilesWhichKeyMenu(), 'l'))
    call assert_equal('', maparg('gd', 'n'))
    call assert_equal('', maparg(' lr', 'n'))
    let &filetype = original_filetype
    call assert_true(has_key(DotfilesWhichKeyMenu(), 'l'))

    execute 'edit ' . fnameescape($VIM_TEST_MARKDOWN)
    call assert_false(has_key(DotfilesWhichKeyMenu(), 'l'))
    call assert_equal('', maparg(' lr', 'n'))
    call assert_equal(0, &conceallevel)
    call assert_equal('```swift', getline(2))
    call assert_equal('', maparg('/', 'n'))
    bprevious
    call assert_true(has_key(DotfilesWhichKeyMenu(), 'l'))
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


def write(path, content):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)


with tempfile.TemporaryDirectory(prefix="dotfiles-vim-lsp-") as directory:
    base = Path(directory).resolve()
    write(base / "check.vim", VIM_CHECK)
    write(base / "README.md", "# Fixture\n```swift\nlet value = 1\n```\n")
    # An outer root with more markers must not win over the nearest project.
    (base / ".git").mkdir()
    write(base / "package.json", "{}\n")
    write(base / "pyproject.toml", "[tool.example]\n")
    python_root = base / "python project"
    write(python_root / "pyrightconfig.json", '{"extraPaths":["lib"],"typeCheckingMode":"strict"}\n')
    write(python_root / "lib/helpers.py", 'def greet(name: str) -> str:\n    return name\n')
    write(python_root / "src/main.py", 'from helpers import greet\n\nresult = greet("Vim")\n')
    ts_root = base / "typescript"
    write(ts_root / "tsconfig.json", '{"compilerOptions":{"strict":true},"include":["src/main.ts"]}\n')
    write(ts_root / "src/main.ts", 'function greet(name: string): string { return name; }\nconst result = greet("Vim");\n')
    swift_root = base / "swift"
    write(swift_root / "Package.swift", '// swift-tools-version: 6.0\nimport PackageDescription\nlet package = Package(name: "Fixture", targets: [.executableTarget(name: "Fixture")])\n')
    write(swift_root / "Sources/Fixture/main.swift", 'func greet(_ name: String) -> String { return name }\nprint(greet("Vim"))\n')

    def run(label, server, root, file, definition, call_line, *, shims=False,
            python_path="", active_venv=""):
        log = base / f"{label}.log"
        result = base / f"{label}.json"
        env = dict(os.environ, VIM_TEST_LOG=str(log), VIM_TEST_RESULT=str(result),
                   VIM_TEST_SERVER=server, VIM_TEST_ROOT=str(root), VIM_TEST_CWD=str(base),
                   VIM_TEST_CALL_LINE=str(call_line), VIM_TEST_DEFINITION=str(definition),
                   VIM_TEST_PYTHON=str(python_path), VIM_TEST_ACTIVE_VENV=str(active_venv),
                   VIM_TEST_MARKDOWN=str(base / "README.md"))
        env.pop("VIRTUAL_ENV", None)
        if active_venv:
            env["VIRTUAL_ENV"] = str(active_venv)
        if shims:
            env["PATH"] = f"{Path.home()}/.local/share/mise/shims:/opt/homebrew/bin:/usr/bin:/bin"
            command = ["/usr/bin/vim"]
        else:
            command = ["mise", "exec", "--", "vim"]
        process = subprocess.run(
            command + ["-Nu", str(REPO / "vimrc"), "-i", "NONE", "-n", "-es",
                       "-V1" + str(base / f"{label}-vim.log"), str(file), "-S", str(base / "check.vim")],
            cwd=base, env=env, capture_output=True, text=True, timeout=40,
        )
        errors = json.loads(result.read_text()) if result.exists() else [process.stderr]
        if process.returncode != 0 or errors:
            details = (base / f"{label}-vim.log").read_text()[-1800:]
            details += '\nLSP tail:\n' + (log.read_text()[-2400:] if log.exists() else '(no log)')
            raise AssertionError(f"{label}: {errors}\n{details}")
        print(f"PASS {label}: root, navigation, mappings, menu, conceal")
        return log

    run("python", "pyright", python_root, python_root / "src/main.py", python_root / "lib/helpers.py", 3)

    def python_environment(path):
        venv.EnvBuilder(with_pip=False, symlinks=True).create(path)
        interpreter = path / "bin/python"
        site_packages = Path(subprocess.check_output(
            [str(interpreter), "-c", "import sysconfig; print(sysconfig.get_path('purelib'))"], text=True,
        ).strip())
        dependency = site_packages / "dotfiles_fixture_dependency/__init__.py"
        write(dependency, 'def greet(name: str) -> str:\n    return name\n')
        write(dependency.parent / "py.typed", "")
        return interpreter, dependency

    interpreter, dependency = python_environment(python_root / ".venv")
    write(python_root / "src/main.py", 'from dotfiles_fixture_dependency import greet\n\nresult = greet("Vim")\n')
    run("python-project-venv", "pyright", python_root, python_root / "src/main.py",
        dependency, 3, python_path=interpreter)
    active = base / "activated environment"
    interpreter, dependency = python_environment(active)
    run("python-active-venv", "pyright", python_root, python_root / "src/main.py",
        dependency, 3, python_path=interpreter, active_venv=active)

    log = run("typescript-shims", "typescript-language-server", ts_root, ts_root / "src/main.ts", ts_root / "src/main.ts", 2, shims=True)
    # Make the real installed SDK a project dependency without downloading a copy.
    fallback = None
    for line in log.read_text().splitlines():
        data = json.loads(line[line.index("["):])
        for value in data:
            if isinstance(value, dict) and value.get("method") == "initialize":
                fallback = value["params"]["initializationOptions"]["tsserver"]["fallbackPath"]
    assert fallback, "Server did not receive a valid fallback SDK"
    (ts_root / "node_modules").mkdir()
    (ts_root / "node_modules/typescript").symlink_to(Path(fallback).parent.parent, target_is_directory=True)
    log = run("typescript-project", "typescript-language-server", ts_root, ts_root / "src/main.ts", ts_root / "src/main.ts", 2)
    versions = []
    for line in log.read_text().splitlines():
        data = json.loads(line[line.index("["):])
        response = data[-1].get("response", {}) if isinstance(data[-1], dict) else {}
        if response.get("method") == "$/typescriptVersion":
            versions.append(response["params"])
    assert any(version["source"] == "workspace" for version in versions), versions
    print("PASS TypeScript prefers the project SDK over the fallback")
    run("swift", "sourcekit-lsp", swift_root, swift_root / "Sources/Fixture/main.swift", swift_root / "Sources/Fixture/main.swift", 2)
