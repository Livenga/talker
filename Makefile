EABI    = arm-none-eabi
AS      = $(EABI)-as
LD      = $(EABI)-ld
CC      = $(EABI)-gcc
OBJCOPY = $(EABI)-objcopy

PRJC   = talker
OBJDIR = objs

CSRC = src/main.c \
	   src/init.c
SSRC = src/asm/startup.s

CPU  = cortex-m0plus
ARCH = armv6-m

DEFINES = -D__DEBUG__
CFLAGS  = -mcpu=$(CPU) \
		 -mtune=$(CPU) \
		 -march=$(ARCH) \
		 -msoft-float \
		 -mfloat-abi=soft \
		 -mthumb \
		 -g \
		 $(DEFINES)

ASFLAGS = -mcpu=$(CPU) \
		  -mthumb

COBJS   = $(addprefix $(OBJDIR)/,$(patsubst %.c,%.o,$(CSRC)))
SOBJS   = $(addprefix $(OBJDIR)/,$(patsubst %.s,%.o,$(SSRC)))
OBJSDIR = $(sort $(dir $(COBJS) $(SOBJS)))


.PHONY : default all clean
default:
	[ -d $(OBJDIR) ] || mkdir -v $(OBJDIR)
	[ -d "$(OBJSDIR)" ] || mkdir -pv $(OBJSDIR)
	make $(PRJC)

$(PRJC):$(COBJS) $(SOBJS)
	$(CC) -o $@ $^ \
		$(CFLAGS) \
		--specs=nosys.specs \
		-T ./stm32l010f4p6.ld \
		-lc -lnosys


$(OBJDIR)/%.o:%.c
	$(CC) -o $@ -c $< \
		$(CFLAGS)

$(OBJDIR)/%.o:%.s
	$(AS) -o $@ \
		$< \
		$(ASFLAGS)

clean:
	[ ! -d $(OBJDIR) ] || rm -rv $(OBJDIR)

all:
	make clean default
