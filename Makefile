#-----------------------------------------------------------------
# Generated by makemake.pl. Type 'makemake.pl' to see the usage
#-----------------------------------------------------------------
PROG =	trajman

SRCS =	module_input.F90 module_kinds.f90 module_readtraj.f90 \
	module_trajop.f90 module_util.f90 trajman.f90

OBJS =	module_input.o module_version.o module_kinds.o module_readtraj.o module_trajop.o \
	module_util.o trajman.o

LIBS =  #/usr/lib64/liblapack.so.3

#INCLUDES = -I/data/jon/src/LAPACK95/lapack95_modules/ 
INCLUDES = #-I/home/jon/src/LAPACK95/lapack95_modules/ 
#LIBSPATH = -L/usr/common/sprng2.0/lib
#LIBSPATH = /data/jon/src/LAPACK95/lapack95.a /usr/lib64/liblapack.so.3 
LIBSPATH =# /home/jon/src/LAPACK95/lapack95.a /usr/lib/liblapack.so.3 
CC = gcc
CFLAGS = -03
F90 = gfortran 
#F90 = ifort 
FFLAGS =  -O3 
F90FLAGS =  -O3 -g 
FC90FLAGS = -D "CINFO='$$(date)'" $(F90FLAGS)
LDFLAGS = 

all: version $(PROG)


$(PROG): $(OBJS)
	$(F90) $(LDFLAGS) -o $@ $(OBJS) $(LIBSPATH) $(LIBS)

.PHONY: version
version:
ifeq ("$(shell bzr version-info --custom --template="{revno}")","$(shell if [ -f module_version.f90 ];then sed -ne "/^.[0-9][0-9]*[0-9]*/p" module_version.f90|cut -c 2-5;else echo '0';fi)")
	
    else
	@echo "A new revision detected, removing old version module."
	@if [ -f module_version.f90 ];then rm module_version.f90;fi
	@if [ -f module_version.o ];then rm module_version.o;fi
	@if [ -f version.mod ];then rm version.mod;fi
endif

clean:
	rm -f $(PROG) $(OBJS) *.mod

.SUFFIXES: $(SUFFIXES) .f90 

.f90.o:
	$(F90) $(F90FLAGS) -c $< $(LIBS) $(INCLUDES)

#.SUFFIXES: $(SUFFIXES) .f90
#
#.f.o:
#	$(F90) $(F90FLAGS) -c $< $(LIBS)

.SUFFIXES: $(SUFFIXES) .F90 

.F90.o:
	$(F90) $(FC90FLAGS) -c $< $(LIBS) $(INCLUDES)

module_version.f90:
	bzr version-info --custom --template="!{revno}\nmodule version\n    use kinds\n    character(kind=1,len=*),parameter :: branch=\"{branch_nick}\",revision=\"{revno}\",revdate=\"{date}\"\nend module version\n" >module_version.f90

#module_input.o: module_kinds.o module_readtraj.o module_util.o module_version.o
module_input.o: module_util.o module_version.o
module_readtraj.o module_version.o module_trajop.o: module_kinds.o
#module_trajop.o: module_kinds.o
module_util.o: module_readtraj.o
trajman.o: module_input.o module_kinds.o module_readtraj.o module_trajop.o \
	module_util.o