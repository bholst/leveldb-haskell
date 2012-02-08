VERBOSITY ?= 1

LEVELDBDIR = `pwd`/cbits/leveldb
LIBLEVELDB = $(LEVELDBDIR)/libleveldb.a

LIBHSLEVELDB = dist/build/*.a
EXECUTABLES  = dist/build/hsleveldb-example/hsleveldb-example

HADDOCK = dist/doc/html/leveldb-haskell/*.html
HOOGLE  = dist/doc/html/leveldb-haskell/leveldb-haskell.txt

.PHONY: all test doc clean prune

all : $(LIBHSLEVELDB)

example : $(EXECUTABLES)
		dist/build/hsleveldb-example/hsleveldb-example

doc : $(HADDOCK) $(HOOGLE)

clean :
		rm -rf dist/
		rm *.buildinfo
		(cd $(LEVELDBDIR) && make clean)

prune : clean
		rm -rf cabal-dev/

$(LIBLEVELDB) :
		(cd $(LEVELDBDIR) && make)

$(HADDOCK) :
		runhaskell Setup.hs haddock --hyperlink-source

$(HOOGLE) :
		runhaskell Setup.hs haddock --hoogle

$(LIBHSLEVELDB) $(EXECUTABLES) : $(LIBLEVELDB)
		cabal-dev install \
--verbose=$(VERBOSITY) \
--force-reinstalls
