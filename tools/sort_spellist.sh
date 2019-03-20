#! /bin/bash

if [ ! -e doc/spelling_wordlist.txt ]; then
    echo "ERR: doc/spelling_wordlist.txt not found, make sure"
    echo "to run script from top-level directory, e.g:"
    echo "  # ./tools/sort_spellist.sh"
    exit 1
fi

echo "Sorting spell list"
cat doc/spelling_wordlist.txt | sort > /tmp/tmp_spell.txt
mv /tmp/tmp_spell.txt doc/spelling_wordlist.txt
git --no-pager diff --exit-code doc/spelling_wordlist.txt
res=$?

if [ ! -z ${res} ]; then
    echo
    echo "Spell list change detected, please remember to" \
         "commit doc/spelling_wordlist.txt"
fi
