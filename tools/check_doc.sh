#! /bin/bash

if [ ! $(ls | grep ^tools$) ]; then
    echo "Tools directory not found, please run the"
    echo "script form the disa-user-guide directory"
    exit 1
fi

setup_build_env () {
    virtualenv ./tools/build_tools
    source ./tools/build_tools/bin/activate
    pip install -r ./doc/requirements.txt
}


if [ "$(find . -iname build_tools)" = "" ]; then
    setup_build_env
fi

source tools/build_tools/bin/activate
echo "=======Running doc8 style check=========="
doc8 doc/*.rst
if [ $? -eq 0 ]; then
    style=true
else
    style=false
fi

echo "=======Running bashate style check=========="
find * -name "*.sh" | grep -v build_tools | xargs --no-run-if-empty bashate
if [ $? -eq 0 ]; then
    bashcheck=true
else
    bashcheck=false
fi
echo "=======Running spell check==============="
mkdir -p ./build/spelling
make spelling

if [ $? -eq 0 ]; then
    spell=true
else
    spell=false
fi
echo "=======Building doc==============="
mkdir -p ./build/html
make html

if [ $? -eq 0 ]; then
    buildcheck=true
else
    buildcheck=false
fi

deactivate

echo "======SUMMARY======="
if [ $style = true ]; then
    echo "Style check PASSED!"
else
    echo "Style check FAILED!"
fi
if [ $bashcheck = true ]; then
    echo "Bash style check PASSED!"
else
    echo "Bash style check FAILED!"
fi
if [ $spell = true ]; then
    echo "Spell check PASSED!"
else
    echo "Spell check FAILED!"
    echo "  Please see build/spelling/output.txt"
fi
if [ $buildcheck = true ]; then
    echo "Build check PASSED!"
else
    echo "Build check FAILED!"
    echo "  Please see build/html/build_err.txt"
fi
