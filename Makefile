PREFIX ?= /usr/bin
FIRMWAREPATH ?= /lib/firmware
BUILDPATH = .

SRC  = cape-universal-00A0.dts
SRC += cape-universala-00A0.dts
SRC += cape-universaln-00A0.dts
SRC += cape-univ-emmc-00A0.dts
SRC += cape-univ-hdmi-00A0.dts
SRC += cape-univ-audio-00A0.dts
TARGET = config-pin

all: ensure_path build

install: install_overlays install_target

# Compile: create dtbo files from dts files.
$(BUILDPATH)/%.dtbo : %.dts
	@echo "Compiling file: $<"
	dtc -@ -I dts -O dtb -o $@ $<

ensure_path:
	mkdir -p $(BUILDPATH)
	mkdir -p $(PREFIX)
	mkdir -p $(FIRMWAREPATH)


build : $(SRC:%.dts=$(BUILDPATH)/%.dtbo)

$(FIRMWAREPATH)/%.dtbo : $(BUILDPATH)/%.dtbo
	@echo "Installing file: $<"
	cp $< $@

install_overlays: $(SRC:%.dts=$(FIRMWAREPATH)/%.dtbo)

install_target:
	@echo "Installing config-pin utility"
	cp $(TARGET) $(PREFIX)/
	chmod +x $(PREFIX)/$(TARGET)

clean:
	rm -f $(BUILDPATH)/*.dtbo
