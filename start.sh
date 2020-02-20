#!/bin/bash
# init
clear
echo " d888                                      d8b          "
echo "d8888                                      Y8P          "
echo "  888                                                   "
echo "  888   888  888 888  888 888d888  8888b.  888 88888b.  "
echo "  888   888  888 888  888 888P\`       \`88b 888 888 \`88b "
echo "  888   Y88  88P 888  888 888     .d888888 888 888  888 "
echo "  888    Y8bd8P  Y88b 888 888     888  888 888 888  888 "
echo "8888888   Y88P    \`Y88888 888     \`Y888888 888 888  888 "
echo "                      888                               "
echo "                 Y8b d88P                               "
echo "                  \`Y88P\`                              "
echo "Software-based jailbreak for IvyBridge (xx30) series ThinkPads"
echo "Revision 4"

# Give the network time to come online
if ! ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then echo -e "\e[1;32mWaiting 10 seconds for Network...\e[0m" && sleep 10; fi

# verify EFI vars
if [ ! -d "/sys/firmware/efivars" ] && [ ! -d "/sys/firmware/efi" ]; then
    echo -e "\e[1;31mEFI Vars not found! Make sure you are running in UEFI mode! Exiting.\e[0m"
    exit 1
fi

# Get BIOS version
bios=$(dmidecode -t bios | grep -i version | awk {'print $2'})
machine=$(dmidecode -t system | grep -i "Family" | awk {'print $3$4'})
version=$(dmidecode -t bios | grep -i "Version" | awk {'print $3'} | sed 's/(//g' | sed 's/\.//g')
valid="false"
flashsize=$(/root/flashrom/flashrom -p internal:laptop=force_I_want_a_brick --ifd -i bios -N -r /tmp/backup.rom > /dev/null && du -h /tmp/backup.rom | sed "s/[^0-9]//g")
padding=$(expr $flashsize - 4)

# Check if BIOS version is valid
case $machine in  
    X230Tablet|X230t)
        if [ "259" -gt "$version" ]; then machine="X230t" && valid="true"; fi ;;
    X230|T530)
        if [ "261" -gt "$version" ]; then valid="true"; fi ;;
    T430)
        if [ "265" -gt "$version" ]; then valid="true"; fi ;;
    T430s)
        if [ "260" -gt "$version" ]; then valid="true"; fi ;;
    W530)
        if [ "259" -gt "$version" ]; then valid="true"; fi ;;
esac

if [ $valid == "false" ]; then
    echo -e "\e[1;31mNo Valid BIOS detected, but you can still attempt the S3 exploit to see if your machine may be compatible in the future."
    echo -e "\eYou will not be able to flash a custom BIOS, but this data can help make your device compatible in the future.\e[0m"
else
    echo -e "\e[1;32mDetected Compatible Configuration - $machine $bios ($(dmidecode -t bios | grep -i "Version" | awk {'print $3'} | sed 's/(//g')).\e[0m"
fi

read -p "Press Enter key to attempt BIOS exploit. Your ThinkPad will suspend as part of the process. Press the power button to wake it up!"

/root/chipsec/chipsec_main.py -m tools.uefi.s3script_modify -a replace_op,mmio_wr,0xFED1F804,0x6009,0x2

systemctl suspend

echo "Waiting for wake from S3 sleep..."

sleep 5

setpci -s 00:1f.0 dc.b=09
/root/chipsec/chipsec_util.py mmio write SPIBAR 0x74 0x4 0xAAF0800
/root/chipsec/chipsec_util.py mmio write SPIBAR 0x78 0x4 0xADE0AD0
/root/chipsec/chipsec_util.py mmio write SPIBAR 0x7C 0x4 0xB100B10
/root/chipsec/chipsec_util.py mmio write SPIBAR 0x80 0x4 0xBFF0B40

# make sure BIOS is writable now
if [ $(/root/chipsec/chipsec_main.py -m common.bios_wp | sed 's/\n//g' | grep -c 'None of the SPI protected ranges write-protect BIOS region') == 0 ]; then
    echo -e "\e[1;31mBIOS still write-protected! Something went wrong or your device is not compatible. Exiting.\e[0m"
    exit 1
else if [ $valid == "false" ]; then
    echo -e "\e[1;32mBIOS no longer write-protected! Your machine is compatible but unsupported. Please report the following details as a GitHub issue:"
    echo -e "Machine: $machine\nBIOS: $bios\nVersion: $(dmidecode -t bios | grep -i "Version" | awk {'print $3'} | sed 's/(//g')\nFlashsize: $flashsize M\e[0m"
    read -p "Press Enter to exit the script."
    exit 1
fi

echo -e "\e[1;32mPlease enter a choice:\e[0m"
$([[ $machine == "X230" ]] && echo "0) Flash LVDS Modified Lenovo BIOS for X330" 
$([[ $valid == "valid" ]] && echo "1) Flash Modified Lenovo BIOS" 
echo "2) Flash a custom BIOS from URL" 
echo "3) Shutdown / Abort Procedure"
read choice
case $choice in
    "0") if [[ $machine == "X230" ]]; then machine="X330"; fi ;;
    "2")
        echo "Enter the full URL for your 4MB BIOS file. Double, triple, and QUADRUPLE check that you are providing the CORRECT file! "
        read userInput
        if [[ -n "$userInput" ]]
        then
            echo "Downloading from $userInput"
            wget $userInput -O /root/bios/custom.rom
            machine="custom"
        fi
        ;;
    "3") shutdown NOW ;;
    *) ;;
esac

read -p "Press Enter key to begin flashing your jailbroken BIOS! Do NOT let the ThinkPad shut off during this process, you will need a hardware programmer to fix it!"

echo -e "\e[1;32mFlashing BIOS...\e[0m"

# pad the BIOS to 12MB or 16MB before flashing
dd if=/dev/zero of=/root/bios/pad bs=1M count=$padding
cat /root/bios/pad /root/bios/$machine.rom > /root/bios/rom.temp

/root/flashrom/flashrom -p internal:laptop=force_I_want_a_brick -w /root/bios/rom.temp --ifd -i bios -N

rm /root/bios/rom.temp

read -p "All done! Press Enter key to restart your ThinkPad or CTRL+C to exit to shell."

reboot NOW