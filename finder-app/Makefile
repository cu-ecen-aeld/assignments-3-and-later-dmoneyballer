SRC:= writer.c
TARGET = writer
OBJS := $(SRC:.c=.o)
cross-compile: $(TARGET)

$(TARGET) : $(OBJS)
	aarch64-none-linux-gnu-gcc $(CFLAGS) $(INCLUDES) $(OBJS) -o $(TARGET) $(LDFLAGS)
all: $(TARGET)

$(TARGET) : $(OBJS)
	$(CC) $(CFLAGS) $(INCLUDES) $(OBJS) -o $(TARGET) $(LDFLAGS)

clean:
	-rm -f *.o $(TARGET) *.elf *.map