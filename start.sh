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
echo "Revision 3"

# Give the network time to come online
echo -e "\e[1;32mWaiting for Network...\e[0m"
sleep 2

# update script if networked
if [[ $updated != "r3" ]] && ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    rm /home/ivy/start.sh
    wget -q https://1vyra.in/start.sh -O /home/ivy/start.sh
    export updated="r3"
    echo 'export updated=r3' >> /home/ivy/.bashrc 
    bash /home/ivy/start.sh
    exit 1
fi

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
    echo -e "\e[1;31mNo Valid BIOS detected. Please downgrade to a supported BIOS. Exiting.\e[0m"
    exit 1
else
    echo -e "\e[1;32mDetected Compatible Configuration - $machine $bios ($(dmidecode -t bios | grep -i "Version" | awk {'print $3'} | sed 's/(//g')).\e[0m"
fi

read -p "Press Enter key to start the jailbreak. Your ThinkPad will suspend as part of the process. Press the power button to wake it up!"

/home/ivy/chipsec/chipsec_main.py -m tools.uefi.s3script_modify -a replace_op,mmio_wr,0xFED1F804,0x6009,0x2

systemctl suspend

echo "Waiting for wake from S3 sleep..."

sleep 5

setpci -s 00:1f.0 dc.b=09
/home/ivy/chipsec/chipsec_util.py mmio write SPIBAR 0x74 0x4 0xAAF0800
/home/ivy/chipsec/chipsec_util.py mmio write SPIBAR 0x78 0x4 0xADE0AD0
/home/ivy/chipsec/chipsec_util.py mmio write SPIBAR 0x7C 0x4 0xB100B10
/home/ivy/chipsec/chipsec_util.py mmio write SPIBAR 0x80 0x4 0xBFF0B40

# make sure BIOS is writable now
if [ $(/home/ivy/chipsec/chipsec_main.py -m common.bios_wp | sed 's/\n//g' | grep -c 'None of the SPI protected ranges write-protect BIOS region') == 0 ]; then
    echo -e "\e[1;31mBIOS still write-protected! Something went wrong. Exiting.\e[0m"
    exit 1
fi

echo -e "\e[1;32mPlease enter a choice:\e[0m"
echo "1) Flash Modified Lenovo BIOS" 
echo "2) Flash a custom BIOS from URL" 
echo "3) Shutdown / Abort Procedure"
echo "4) Flash a backup BIOS if it exists"
read choice
case $choice in
    "2")
        echo "Enter the full URL for your 4MB BIOS file. Double, triple, and QUADRUPLE check that you are providing the CORRECT file! "
        read userInput
        if [[ -n "$userInput" ]]
        then
            echo "Downloading from $userInput"
            wget $userInput -O /home/ivy/bios/custom.rom
            machine="custom"
        fi
        ;;
    "4") 
        mv /home/ivy/bios/backup.rom /home/ivy/bios/backuptemp.rom
        machine="backuptemp"
        ;;
    "3") shutdown NOW ;;
    *) ;;
esac

read -p "Press Enter key to begin flashing your jailbroken BIOS! Do NOT let the ThinkPad shut off during this process, you will need a hardware programmer to fix it!"

# backup BIOS first each time
echo -e "\e[1;32mBacking up existing BIOS...\e[0m"
rm /home/ivy/bios/backup.rom &> /dev/null
/home/ivy/flashrom/flashrom -p internal:laptop=force_I_want_a_brick -r /home/ivy/bios/backup_12.rom --ifd -i bios -N
dd if=/home/ivy/bios/backup_12.rom of=/home/ivy/bios/backup.rom bs=1M skip=$([[ $machine == "T430s" ]] && echo 12 || echo 8)
rm /home/ivy/bios/backup_12.rom &> /dev/null

echo -e "\e[1;32mFlashing BIOS...\e[0m"

# pad the BIOS to 12MB or 16MB before flashing
dd if=/dev/zero of=/home/ivy/bios/pad bs=1M count=$([[ $machine == "T430s" ]] && echo 12 || echo 8)
cat /home/ivy/bios/pad /home/ivy/bios/$machine.rom > /home/ivy/bios/rom.temp

# delete custom and temporary backup
rm /home/ivy/bios/custom.rom &> /dev/null
rm /home/ivy/bios/backuptemp.rom &> /dev/null

/home/ivy/flashrom/flashrom -p internal:laptop=force_I_want_a_brick -w /home/ivy/bios/rom.temp --ifd -i bios -N

rm /home/ivy/bios/rom.temp

read -p "All done! Press Enter key to restart your ThinkPad or CTRL+C to exit to shell."

reboot NOW