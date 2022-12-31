#!/bin/bash

set -eux

rm -rf output
mkdir -p output
cp -a /host/pgroonga/expected output/results

PG_REGRESS_DIFF_OPTS="-u"
if diff --help | grep -q color; then
  PG_REGRESS_DIFF_OPTS+=" --color=always"
fi
export PG_REGRESS_DIFF_OPTS

if ! $(dirname $(pg_config --pgxs))/../test/regress/pg_regress \
        --user=pgroonga \
        --schedule=/host/pgroonga/schedule \
        --inputdir=/host/pgroonga \
        --outputdir=output \
        --load-extension=pgroonga \
        --launcher=/host/pgroonga/test/short-pgappname; then
  cat output/regression.diffs
  exit 1
fi
