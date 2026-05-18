# contrib/saio/Makefile

MODULE_big = saio
EXTENSION  = saio
EXTVERSION = 0.0.1

OBJS = \
	src/saio.o \
	src/saio_main.o \
	src/saio_recalc.o \
	src/saio_trees.o \
	src/saio_util.o

DATA = saio--0.0.1.sql

DOCS = $(wildcard doc/*.md)

PGFILEDESC = "saio - join order search with simulated annealing"

EXTRA_CLEAN = src/saio_probes.h

ifdef USE_PGXS
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
else
subdir = contrib/saio
top_builddir = ../..
include $(top_builddir)/src/Makefile.global
include $(top_srcdir)/contrib/contrib-global.mk
endif

# DTrace support: when enabled add the probes object; otherwise expand the .d
# file into a dummy header with sed.
ifeq ($(enable_dtrace), yes)
OBJS += src/saio_probes.o

src/saio_probes.o: src/saio_probes.d
	$(DTRACE) -C -G -s $< -o $@

src/saio_probes.h: src/saio_probes.d
	$(DTRACE) -C -h -s $< -o $@.tmp
	sed -e 's/SAIO_/TRACE_SAIO_/g' $@.tmp >$@
	rm $@.tmp
else
src/saio_probes.h: src/saio_probes.d src/Gen_dummy_probes.sed
	sed -f src/Gen_dummy_probes.sed $< >$@
endif

src/saio.o src/saio_main.o src/saio_recalc.o src/saio_trees.o src/saio_util.o: src/saio_probes.h
