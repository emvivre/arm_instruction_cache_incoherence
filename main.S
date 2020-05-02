.set __NR_SYSCALL_BASE, 0
.set __NR_exit, (__NR_SYSCALL_BASE+1)
.set __NR_write, (__NR_SYSCALL_BASE+4)
.set __NR_mprotect, (__NR_SYSCALL_BASE+125)
.set PAGE_SIZE, 4096
.set PROT_READ, 0x1             @ Page can be read.
.set PROT_WRITE, 0x2            @ Page can be written.
.set PROT_EXEC, 0x4             @ Page can be executed.
.set PROT_NONE, 0x0             @ Page can not be accessed.
.set STDOUT, 1

	.global _start
	.text
_start:
	@ get aligned page address of _start code
	ldr r0, =_start
	mov r1, #PAGE_SIZE
	neg r1, r1
	and r0, r1

	@ authorize modification of .text
        mov r1, #PAGE_SIZE
        mov r2, #(PROT_READ | PROT_WRITE | PROT_EXEC)
        mov r7, #__NR_mprotect
        swi #0

	@ default not flush entry
	ldr r1, =msg_not_flush_entry

	@ modify opcode
	@   bmi -> bpl
	ldr r0, =op
	mov r2, #0x5a
modif:
	strb r2, [r0,#3]

	@ set N=1
	mov r0, #0
	subs r0, #1

	@ flush detection
op:
	bmi continue

	@ code section here is execute if instruction cache has been flushed
	ldr r1, =msg_flush_entry

continue:
	@ display mesg
	mov r0, #STDOUT
	ldr r2, [r1]
	add r1, #4
	mov r7, #__NR_write
	swi #0

	@ exit(0)
	mov r0, #0
	mov r7, #__NR_exit
	swi #0


msg_flush_entry:
	.int msg_flush_end - msg_flush
msg_flush:
	.ascii "The cache instruction has AUTOMATICALLY been flushed.\n"
msg_flush_end:


msg_not_flush_entry:
	.int msg_not_flush_end - msg_not_flush
msg_not_flush:
	.ascii "The cache instruction has NOT been flushed.\n"
msg_not_flush_end:
