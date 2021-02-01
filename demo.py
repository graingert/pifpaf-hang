from __future__ import annotations

import re
import contextlib
import sys
import subprocess

import psutil


def _get_envvars(stdout):
    """
    `pifpaf` prints a set of lines designed to be exec'd by your shell to set up etcdctl
    env vars. We extract them by parsing its STDOUT for `export ...` lines
    """
    return {
        match.group("key"): match.group("value")
        for match in re.finditer(
            '^export (?P<key>[A-Z_]+)="(?P<value>.*)";$', stdout, flags=re.MULTILINE
        )
    }


@contextlib.contextmanager
def etcd():
    envvars = _get_envvars(
        subprocess.run(
            [sys.executable, "-m", "pifpaf", "run", "etcd"],
            check=True,
            text=True,
            capture_output=True,
            encoding="utf8",
        ).stdout
    )
    process = psutil.Process(int(envvars["PIFPAF_PID"]))
    try:
        yield envvars["PIFPAF_ETCD_PORT"]
    finally:
        process.terminate()
        process.wait(timeout=10)


def main():
    with etcd() as port:
        print(f"{port=}")


if __name__ == "__main__":
    sys.exit(main())
