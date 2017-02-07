#!/bin/bash

echo '/*
* pru dts file BB-BONE-PRU-00A0.dts
*/
/dts-v1/;
/plugin/;

/ {
  compatible = "ti,beaglebone", "ti,beaglebone-black";

  /* identification */
  part-number = "BB-BONE-PRU";
  version = "00A0";

  exclusive-use =
    "P8.12",
    "P8.11",
    "P9.31",
    "P9.29",
    "P9.30",
    "P9.28",
    "P9.42",
    "P9.27",
    "P9.41",
    "P9.25";

  fragment@0 {
    target = <&am33xx_pinmux>;
    __overlay__ {
      mygpio: pinmux_mygpio {
        pinctrl-single,pins = <
          0x030 0x06 /* P8_12 to PRU output */
          0x034 0x06 /* P8_11 to PRU output */
					0x190 0x05 /* P9_31 to PRU output */
          0x194 0x05 /* P9_29 to PRU output */
          0x198 0x05 /* P9_30 to PRU output */
          0x19C 0x05 /* P9_28 to PRU output */
          0x1A0 0x05 /* P9_42 to PRU output */
          0x1A4 0x05 /* P9_27 to PRU output */
          0x1A8 0x05 /* P9_41 to PRU output */
          0x1AC 0x05 /* P9_25 to PRU output */
          0x1B4 0x20 /* CLKOUT2 to input as per datasheet (to enable P9_41) */
          0x164 0x20 /* GPIO0_7 to input as per datasheet (to enable P9_42) */
          >;
      };
    };
  };

  fragment@1 {
    target = <&ocp>;
    __overlay__ {
      test_helper: helper {
        compatible = "bone-pinmux-helper";
        pinctrl-names = "default";
        pinctrl-0 = <&mygpio>;
        status = "okay";
      };
    };
  };

  fragment@2{
  target = <&pruss>;
    __overlay__ {
      status = "okay";
    };
  };
};' > BB-BONE-PRU-00A0.dts

dtc -@ -O dtb -o BB-BONE-PRU-00A0.dtbo BB-BONE-PRU-00A0.dts

mv BB-BONE-PRU-00A0.dtbo /lib/firmware/

git clone https://github.com/beagleboard/am335x_pru_package
cd am335x_pru_package
mkdir /usr/include/pruss
cp pru_sw/app_loader/include/prussdrv.h pru_sw/app_loader/include/pruss_intc_mapping.h /usr/include/pruss
cd pru_sw/app_loader/interface/
CROSS_COMPILE= make

cd ../lib
cp * /usr/lib
ldconfig

cd ../../utils/pasm_source
source linuxbuild
mv ../pasm /usr/bin
chmod +x /usr/bin/pasm

echo -e "#!/bin/bash\necho -e 'BB-BONE-PRU' > /sys/bus/platform/devices/bone_capemgr/slots" > /root/boot/capemgr-slots-pru.sh
chmod 755 /root/boot/capemgr-slots-pru.sh
echo -e "[Unit]\nDescription=Enables the PRU0, for running custom PRU programs.\n\n[Service]\nExecStart=/root/boot/capemgr-slots-pru.sh\n\n[Install]\nWantedBy=multi-user.target " > /etc/systemd/system/capemgr-slots-pru.service 

systemctl enable capemgr-slots-pru.service 

