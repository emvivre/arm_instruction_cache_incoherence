all:
	arm-linux-gnueabihf-as -o main.o main.S
	arm-linux-gnueabihf-ld -o main main.o
	arm-linux-gnueabihf-objdump -d main
