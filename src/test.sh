#!/bin/sh -x
if [ ! $SVNDIR ]; then
    SVNDIR=..
fi
PERL_DL_NONLAZY=1 perl -I$SVNDIR/src/t "-MExtUtils::Command::MM" "-e" "test_harness(0, 't')" $SVNDIR/src/t/*.t
