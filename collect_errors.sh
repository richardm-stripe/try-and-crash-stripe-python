#!/usr/bin/env bash

python_version="$(python -c 'import sys; print("%d.%d" % (sys.version_info[0], sys.version_info[1]))')"

function activate {
  name=$1
  rm -rf $name
  python -m venv $name
  . $name/bin/activate
}

function collect_errors {
  mypy src/access_various_methods_and_properties.py > mypy_errors.$python_version.txt
  pyright src/access_various_methods_and_properties.py > pyright_errors.$python_version.txt
}

function run_and_hope_things_dont_break {
  python3 src/runtime_tests.py
}

# If `types-stripe` is explicitly `pip installed`, the types
# there will always take precedence.
function do_venv_1 {
  activate venv1
  pip install mypy pyright
  pip install types-stripe
  pip install stripe==6.0.0
  collect_errors
  run_and_hope_things_dont_break
}

# If `types-stripe` is explicitly `pip installed`, the types
# there will always take precedence.
function do_venv_2 {
  activate venv2
  pip install mypy pyright
  pip install types-stripe
  test -f ../../stripe/stripe-python/stripe/py.typed
  pip install ../../stripe/stripe-python
  collect_errors
  run_and_hope_things_dont_break
}

# If `types-stripe` is explicitly `pip installed`, the types
# there will always take precedence.
function do_venv_3 {
  activate venv3
  pip install mypy pyright
  pip install types-stripe
  test -f ../../stripe/stripe-python/stripe/py.typed
  pip install ../../stripe/stripe-python
  touch venv3/lib/python$python_version/site-packages/stripe/py.typed
  collect_errors
  run_and_hope_things_dont_break
}

# In this case, mypy and pyright will both use what's in ../../stripe/stripe-python
function do_venv_4 {
  activate venv4
  pip install mypy pyright pycurl
  test -f ../../stripe/stripe-python/stripe/py.typed
  pip install ../../stripe/stripe-python
  touch venv4/lib/python$python_version/site-packages/stripe/py.typed
  collect_errors
  run_and_hope_things_dont_break
}

# In this case, pyright will use what's in Typeshed.
# MyPy will complain about not having types for the stripe module.
function do_venv_5 {
  activate venv5
  pip install mypy pyright
  pip install ../../stripe/stripe-python
  collect_errors
  run_and_hope_things_dont_break
}

# MyPy will crash because this version of typing_extensions is too low, however `run_and_hope_things_don't_break` still succeeds.
function do_venv_6 {
  activate venv6
  pip install mypy pyright ../../stripe/stripe-python typing_extensions==3.7.4
  collect_errors
  run_and_hope_things_dont_break
}

# This version is low enough to crash `run_and_hope_things_don't_break`, i.e. too low for
# stripe-python to support.
function do_venv_7 {
  activate venv7
  pip install mypy pyright ../../stripe/stripe-python typing_extensions==3.7.2
  collect_errors
  run_and_hope_things_dont_break
}

case $1 in
  1) do_venv_1 ;;
  2) do_venv_2 ;;
  3) do_venv_3 ;;
  4) do_venv_4 ;;
  5) do_venv_5 ;;
  6) do_venv_6 ;;
  6) do_venv_7 ;;
  *) echo "Usage: $0 {1|2|3|4|5|6|7}" ;;
esac

