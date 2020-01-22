# `fprolog` - Functional Prolog

`fprolog` extends standard prolog to allow function declarations, with a syntax similar to that used in
functional languages such as ML.

## Example run of an fprolog program

Example fprolog source (`examples/max.pl`):
```
% Function max2(X,Y) returns greater of X or Y
fun max2(X,Y) = if (X > Y) then X else Y.

% Function max(L) returns maximum element in list L
fun max([X]) = X;
    max([X|L]) = max2(X,max(L)).

% Relation max(L,N) succeeds if N is the maximum element in list L
max(L,N) :- N = max(L).
```

And here is how we 'run' that `fprolog` program:

```
$ prolog

Welcome to SWI-Prolog (threaded, 64 bits, version 7.6.4)
SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.
Please run ?- license. for legal details.

For online help and background, visit http://www.swi-prolog.org
For built-in help, use ?- help(Topic). or ?- apropos(Word).

?- [fprolog].
true.

?- fconsult('examples/max.pl').
true.

?- max([1,3,4,7,3,5],N).
N = 7.

?- 
```

# File sources from ijl20 cl filer archive

These are the latest versions of the ORIGINAL PrologPF files from the Computer Lab filer (ijl20).

The extensions to Prolog supported are:

```o_code``` or ```k_code``` for parallism support via Oracles or Kappa.

```f_code``` for functional support in Prolog, where an argument to a relation can be a 
function, declared in a 'fun' clause.

## Compile-time source-code mangling to support Oracles, Kappa, and functions

### ```wamcc_ocode.pl``` 8653 bytes 1997-10-01

From ```cl_filer/wamcc/src/wamcc_ocode.pl```

Used at compile / consult time to modify source program to include Oracle support via C macros.

### ```wamcc_ocode_pl.pl``` 8019 bytes 1997-10-01

From ```cl_filer/wamcc/src/wamcc_ocode_pl.pl```

Used at compile / consult time to modify source program to include Oracle support via Prolog relations.

### ```wamcc_kcode.pl``` 8739 bytes 1997-10-24

From ```cl_filer/wamcc/src/wamcc_kcode.pl```

Almost identical to wamcc_ocode.pl, but injects 'kappa' oracle relations.

Used at compile / consult time to modify source program to include Kappa support

### ```wamcc_fcode.pl``` 9751 bytes 1997-06-05

From ```cl_filer/wamcc/src/wamcc_fcode.pl```

Used at compile / consult time to modify source program to replace function
definitions with equivalent relations

## Run-time utility code to support Oracles, Kappa and functions

### ```f_utils.pl``` 5555 1997-06-05

From ```cl_filer/wamcc/src/f_utils.pl```

Provides run-time functions that support PrologPF functions (e.g. function
definitions for +, -).

### ```o_utils_pl.pl``` 12703 bytes 1997-06-05

From ```cl_filer/wamcc/src/o_utils_pl.pl```

Provides run-time relations that support Prolog Oracle management code (i.e. build, follow
oracles via Prolog relations such as o_next).

### ```o_utils.pl``` 8213 bytes 1997-09-29 

From ```cl_filer/wamcc/src/o_utils.pl```

Provides run-time relations that support C-based oracles (i.e via relations defined with
C macros).

### ```o_utils.usr``` 8238 1997-08-20  ./cl-wamcc-src/o_utils.usr 

From ```cl_filer/wamcc/src/o_utils.usr```

Provides C macro-based relations for run-time oracle support

### ```k_utils.pl``` 7603 1997-11-06

From ```cl_filer/wamcc/src/k_utils.pl```

Provides relations (calling C macros) for run-time Kappa support

### ```k_utils.usr``` 10143 1997-11-05

From ```cl_filer/wamcc/src/k_utils.usr```

Provides C macros for run-time Kappa support


