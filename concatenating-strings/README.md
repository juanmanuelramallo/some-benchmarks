# Concatenating strings

Assumption: Concatenating a collection of strings using map and join is faster than using an inject/reduce.

Reasoning: Reallocating memory for an existing object is more expensive than allocating memory for a new one.

Ruby: 2.7.1

CPU: Intel(R) Core(TM) i7-8750H CPU @ 2.20GHz

Results:

```
Warming up --------------------------------------
            map-join   959.513k i/100ms
              inject   887.441k i/100ms
Calculating -------------------------------------
            map-join     11.280M (± 6.0%) i/s -     56.611M in   5.037624s
              inject      8.723M (± 5.9%) i/s -     43.485M in   5.006639s

Comparison:
            map-join: 11279970.5 i/s
              inject:  8722753.3 i/s - 1.29x  (± 0.00) slower
```

To check how many times realloc has been called, run code.rb using dtrace:

Inject: `sudo dtrace -q -n 'pid$target::realloc:entry { @ = count(); }' -c "ruby absolute-path-to-this-file"`

Map-Join: `sudo dtrace -q -n 'pid$target::realloc:entry { @ = count(); }' -c "ruby absolute-path-to-this-file map"`

More info about [why realloc is more expensive than malloc here](https://medium.com/@jraleman/c-programming-language-functions-malloc-calloc-realloc-and-free-61cfc3e45da7#:~:text=It's%20better%20to%20use%20malloc,memory%20block%20on%20the%20heap.&text=int%20*ptr%20%3D%20malloc(10%20*%20sizeof(int))%3B&text=If%20pointer%20passed%20to%20realloc,will%20behave%20exactly%20like%20malloc).

Results:

```
$ sudo dtrace -q -n 'pid$target::realloc:entry { @ = count(); }' -c "ruby /Users/juanmanuel/Desktop/Proyectos/some-benchmarks/code.rb"
dtrace: system integrity protection is on, some features will not be available

inject

            90308
```

```
$ sudo dtrace -q -n 'pid$target::realloc:entry { @ = count(); }' -c "ruby /Users/juanmanuel/Desktop/Proyectos/some-benchmarks/code.rb map"
dtrace: system integrity protection is on, some features will not be available

map-join

             2584
```
