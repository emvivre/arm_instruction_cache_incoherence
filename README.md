This project modifies an operation code, to produce an incoherence of the cache instruction and the external memory. A branch opcode as been modify to detect whether the cache instruction has been flushed or not. This project is for educational purpose.

In a standard ARM implementation the cache instruction is not automatically flushed whether the memory has been modify. This produce a kind of disynchronization between the content of the memory and the cache instruction.

To run the program, in a terminal type :
```
./main
The cache instruction has NOT been flushed.
```

The following example show a biais that can be produced during a debugging session, here with gdb. If the program is run entirely, same output is produced as with the program alone :
```
$ gdb -q ./main
Reading symbols from ./main...(no debugging symbols found)...done.
(gdb) r
Starting program: /tmp/main
The cache instruction has NOT been flushed.
```

However if a breakpoint is set at the instruction that modify the branch operation code, then a flush of the cache instruction will be performed. In the following example, the label 'modif' has been used to ease the settings of breakpoint :
```
$ gdb -q ./main
Reading symbols from ./main...(no debugging symbols found)...done.
(gdb) b modif
Breakpoint 1 at 0x10080
(gdb) r
Starting program: /tmp/main

Breakpoint 1, 0x00010080 in modif ()
(gdb) c
Continuing.
The cache instruction has AUTOMATICALLY been flushed.
```

Depending of the debugging session you perform with breakpoint, not same behavior of the program is obtained, because of the incoherence between the instruction cache and the external memory.
