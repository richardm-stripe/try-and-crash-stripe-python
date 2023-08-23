# try-and-crash-stripe-python

This repo contains a script `./collect_errors.sh` with a bunch of venvs defined, to make manual testing of various environments that include stripe-python easier.

## Usage

* Pick a python version, e.g. `echo 3.6 > .python-version` for pyenv to pick up.
* Look through `collect_errors.sh` to see if one of the venvs matches a test situation you are curious about.
* Run `./collect_errors.sh <number>`.
* Look at `pyright_errors.*.txt` and `mypy_errors.*.txt` to see what type errors are emitted for `src/access_various_methods_and_properties.py`.
* Look at the output to see if `python3 runtime_tests.py` crashed (basically, it shouldn't crash).
