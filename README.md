# Triggering Amstrad BASIC/System errors from machine code

## Topic

I saw [z80 - Triggering Amstrad BASIC/System errors from machine code - Retrocomputing Stack Exchange](https://retrocomputing.stackexchange.com/questions/30650/triggering-amstrad-basic-system-errors-from-machine-code).

> I'm writing some machine code that's intended to be executed from BASIC with a `CALL` and I'd like to trigger genuine errors just like running `ERROR 5` (Improper argument) from BASIC.

> I have the book *The Ins and Outs of the Amstrad* by Don Thomasson and I've looked at the jumpblock entries, but I didn't find it there.

> How can I trigger errors from machine code that can be caught and handled by a BASIC program using `ON ERROR GOTO`?

I found this was an interesting small problem on its own.

It can be done by calling an appropriate location in ROM, but because the firmware does not provide a stable entry point for those features, the location in the ROM will depend on which version of the CPC the code runs (464, 664, 6128, plus).

One nice thing is that it allows you to raise and catch custom error numbers beyond the range 1-30 defined in the BASIC ROM.

## Explanation

The code in this repository allows precisely that.

It is supplied with two example BASIC programs:

* `err.bas` that does not catch errors,
* `errcatch.bas` that does catch errors

See file `asm2err.s` for assembly implementation.

## How to run

``` bash
git clone https://github.com/cpcitor/asm2err
cd asm2err
make
# or, faster, if you have e.g. 8 CPU cores
make -j8
```

Then

``` bash
make
# or, faster, if you have e.g. 8 CPU cores
make -j8
```

(If you don't know how cpc-dev-tool-chain works, be aware that the first time it will download source code of SDCC compiler and other tools useful to develop for Amstrad CPC, compile what is needed, then run the program through cpcec emulator.)

### When inside the Amstrad CPC

A program that loads the assembly, asks you for an error number, and raises this error from assembly:

```
run"err
```

A program that loads the assembly, and once for each error number, raises this error from assembly and confirms that it is caught by `ON ERROR GOTO`:

```
run"errcatch
```
