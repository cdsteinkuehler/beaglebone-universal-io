echo "compiling universal device tree overlays..."
dtc -@ -I dts -O dtb -o /lib/firmware/cape-universal-00A0.dtbo cape-universal-00A0.dts
dtc -@ -I dts -O dtb -o /lib/firmware/cape-universaln-00A0.dtbo cape-universaln-00A0.dts
dtc -@ -I dts -O dtb -o /lib/firmware/cape-univ-emmc-00A0.dtbo cape-univ-emmc-00A0.dts
echo "done"
echo "installing config-pin utility"
cp -v config-pin /usr/bin/
