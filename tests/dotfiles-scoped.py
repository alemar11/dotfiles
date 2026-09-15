"""Exercise the real link manager against a disposable target directory."""

import os
from pathlib import Path
import subprocess
import tempfile

repo = Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix="dotfiles-links-") as temp:
    target = Path(temp)
    env = dict(os.environ, DOTFILES_TARGET_DIR=temp)

    def run(action, source="yazi", ok=True):
        result = subprocess.run(
            ["bash", str(repo / "dotfiles.sh"), action, source],
            env=env,
            capture_output=True,
            text=True,
            check=False,
        )
        assert (result.returncode == 0) == ok, result.stdout + result.stderr

    run("install", "does-not-exist", ok=False)
    assert not list(target.iterdir())
    run("install")
    link = target / ".config/yazi"
    assert link.is_symlink() and link.resolve() == repo / "yazi"
    assert list((target / ".config").iterdir()) == [link]
    run("install")
    run("remove")
    assert not link.is_symlink()

    link.mkdir()
    (link / "keep").write_text("existing config")
    run("install")
    run("remove")
    assert (link / "keep").read_text() == "existing config"
    (link / "keep").unlink()
    link.rmdir()

    # A symlink owned by another checkout is also preserved, including by clean.
    link.symlink_to(target / "missing-other-checkout")
    run("remove")
    run("clean")
    assert link.is_symlink()

    run("install", "vimrc")
    vimrc = target / ".vimrc"
    assert vimrc.is_symlink() and vimrc.resolve() == repo / "vimrc"
    run("remove", "vimrc")
    assert not vimrc.is_symlink()

print("Scoped link tests passed: selection, idempotence, existing config and foreign links")
