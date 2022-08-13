SRC:= writer.c
TARGET = writer
OBJS := $(SRC:.c=.o)
CC:= aarch64-none-linux-gnu-gcc
all: $(TARGET)

$(TARGET) : $(OBJS)
	$(CC) $(CFLAGS) $(INCLUDES) $(OBJS) -o $(TARGET) $(LDFLAGS)

clean:
	-rm -f *.o $(TARGET) *.elf *.map