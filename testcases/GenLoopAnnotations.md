# Generate Loop Annotations

This is the documentation for the script `GenLoopAnnotations`. This script can
be used to semi-automatically generate the loop annotations file for LLVMTA
from source code that has been manually annotated with loop bounds.

To run this script simply execute:

```
$ ./GenLoopAnnotations
```

Like most other scripts, it accepts the `--testcase` parameter or you can give
it the Benchmark name as `$1`. Similarly, you can pass it different options,
the most interesting ones are:

  * `--enable-optimizations`
  * `--disable-hard-floating-point`

Since they can change the loop structures

On running the script, it produces human readable output stating its progress.

```
Running loopexamples/dowhile Done (1 entrypoints)
Running loopexamples/dowhile2 Fail (No. of Loops != AnnotationCount)
Running loopexamples/goto Fail (No. of Loops != AnnotationCount)
Running loopexamples/irreducible SKIP (No Loops)
Running loopexamples/loopsinmultiplefunction Done (1 entrypoints)
Running loopexamples/nested Done (1 entrypoints)
Running loopexamples/nested2 Fail (No. of Loops != AnnotationCount)
Running loopexamples/simplewhile Done (1 entrypoints)
Running loopexamples/twoloopssamestart Fail (No. of Loops != AnnotationCount)
Running scadetests/cruise_control Done (1 entrypoints)
Running scadetests/digital_stopwatch Done (1 entrypoints)
Running scadetests/es_lift Done (1 entrypoints)
Running scadetests/flight_control Done (1 entrypoints)
Running scadetests/pilot Done (1 entrypoints)
Running scadetests/roboDog Done (1 entrypoints)
Running scadetests/trolleybus Done (1 entrypoints)
```

The analysis may report a number of warnings. In each of those cases, some
manual intervention is required as it implies that the heuristics were unable
to completely determine a particular loop.

## Warnings and Errors

The following warnings or errors are possible:

### No. of Loops != AnnotationCount

As it mentions, this implies that the number of Loops reported by LLVMTA in its
LoopAnnotations.txt file do not match the number of annotations provided in the
source code. This usually means that the source has not been fully annotated.

Go to "Benchmarks/path/to/benchmark/build/entry_point/LoopAnnotations.txt" and
ensure that the source has an annotation for each of the lines mentioned there

### Unknown Loops

The script returns this error when the helper script exits with a value of 4.
This implies that the script was unable to match the triplet of (filename,
func, lineno) to a corresponding one in the base case (NotOptimized|HardFloat).
In most cases this happens because the compiler rearranged the lines and hence
there is a mismatch. Simply open the current case and base case loop annotation
files and compare the lines. In most cases one can simply match them manually
and copy the bounds value to the new file

### Base Not Found

When optimizations are enabled the structure and location of the loops may
change significantly. Hence, the script tries to simply match the loop triplet
(filename, function, lineno) to the one in the base case and identify a loop
bound. However, in some cases, the base case may not be generated at all, but a
loop bound is required in the other cases. Then, simply copy the
LoopAnnotations.csv file with the right name and edit it to modify its loop
bounds
