<pre>
 d888                                      d8b          
d8888                                      Y8P          
  888                                                   
  888   888  888 888  888 888d888  8888b.  888 88888b.  
  888   888  888 888  888 888P"       "88b 888 888 "88b 
  888   Y88  88P 888  888 888     .d888888 888 888  888 
  888    Y8bd8P  Y88b 888 888     888  888 888 888  888 
8888888   Y88P    "Y88888 888     "Y888888 888 888  888 
                      888                               
                 Y8b d88P                               
                  "Y88P"                                
</pre>

### Revision 5 (MD5: `dd30313a8665e870360920b00cec55c4`)

Software-based "jailbreak" allowing all ivybridge-based xx30 thinkpads to softmod custom bios images.

This repo contains the main script and pre-compiled binary files used in the 1vyrain image to flash machines.

The main link to the ready to go live USB image can be found **[here](https://1vyra.in/)**.

Updates will be published here in the form of scripts that can be downloaded and run on the USB image.

**Although 1vyrain has been very thoroughly tested and there were zero bricks during testing, there are some random quirks associated with bypassing normal flashing methods and things can always randomly go awry. There is no warranty or support guaranteed so please keep this in mind if you intend to use this software. I am not responsible for broken devices. Fortunately, it is impossible to permanently brick a device with this method. Worst case scenario, you can flash a backup or fresh BIOS using a hardware programmer.**

## Read the [long form FAQ](https://medium.com/@n4ru/1vyrain-an-xx30-thinkpad-jailbreak-fd4bb0bdb654) before opening an issue.

# Features:
- Automatic exploit chain unlocking bios region for flashing
- Model detection and automatic bios flashing
- Support for custom bios images (coreboot, skulls, heads)

# BIOS Mod Features:
- Overclocking support (35xx, 37xx, 38xx, 39xx CPUs)
- Whitelist removal to use any WLAN/WWAN adapter
- Advanced menu (custom fan curve, TDP, etc)
- Intel ME "Soft Temporary Disable" via advanced menu

# Before Installing
**Please pay careful attention to this section.** . Ensure you're on a compatible BIOS version before beginning (check compatibility [here](https://github.com/gch1p/thinkpad-bios-software-flashing-guide#bios-versions)). Run [IVprep](https://github.com/n4ru/IVprep) if you are not or are unsure. Clear any BIOS passwords or settings prior to flashing, and do a BIOS setting reset if you can. Ensure your ThinkPad is charged and your adapter is plugged in. If you intend to use a custom binary, make sure you plug in ethernet prior to boot and that your binary is directly accessible via URL.

# Supported Systems
- X230
- X330*
- X230t
- T430
- T430s
- T530
- W530

*X330 machines are supported but not automatically detected. They are detected as normal X230 machines. The flashing menu has an additional option to flash a BIOS with the LVDS patch for machines detected as an X230.*


# Supporting New Systems and Opening Issues
Please read the [longform FAQ](https://medium.com/@n4ru/1vyrain-an-xx30-thinkpad-jailbreak-fd4bb0bdb654) before asking about compatibility or reporting an issue to make sure it is not a duplicate.

# Installing

1. Burn the 1vyrain image onto a flash drive. Validated and recommended tools are: `dd`, `Win32DiskImager`, and `Rufus (note you have to use DD mode)`
2. Boot in UEFI mode from the flash drive, with Secure Boot off.
3. Follow the on-screen instructions.
4. That's it! 

Don't be alarmed if your ThinkPad/ThinkLight power cycles a few times after a flash, or you get a CRC Security error. That is *normal* and will go away after another restart!

**NOTE:** This will NOT modify your EC. You are safe to flash your EC with the battery or keyboard mod at any time as long as you are on a version compatible with the EC mod (check compatibility [here](https://github.com/hamishcoleman/thinkpad-ec#compatibilty-warning)). Both IVprep and 1vyrain will only modify the BIOS region! You can safely use this image to update to the latest modded BIOS without losing your EC mod!

# Custom binaries
By default, the image includes the latest BIOS versions for all models, but you can flash a custom image such as heads, skulls, or a coreboot build. Make sure you have wired ethernet attached on boot, and that your image is *EXACTLY* 4MB and uploaded somewhere that you can grab with a simple `wget` command(http only, https currently not supported.). When asked what to flash, select "Flash a custom BIOS from URL" (option 2). Input the URL. That's it!

Don't worry, if your download screws up or the filesize was wrong, the flashing will simply fail. You won't brick.

# Custom splash image
To get a custom splash image follow this procedure:
1. Update with original Lenovo update tool following LOGO.txt instructions
2. Read back the `bios` region with flashrom or FPTW
3. Chop off first 8M of the rom `dd if=backup.rom of=4M.rom bs=1M skip=8`
4. Apply patches from patched-bios repo
5. Downgrade with IVprep
6. Write as a custom binary from liveUSB

# Upgrading

To update from an older version of 1vyrain, to a newer version follow the follwing steps. Updates may include security bug fixes.

1. Remove any BIOS passwords, including supervisor passwords
2. It is suggested to reset BIOS to default settings, and save
3. Take out any non-whitelisted devices because the FL1's are untouched
4. Use IVprep to downgrade to a flashable stock BIOS version (very important, do not skip!)
5. Obtain the latest 1vyrain image compatible with your machine.
6. Follow the original installation steps above.

**DO NOT SKIP**  the IVprep process at step 4. This is needed to safely reset to a stock BIOS version. This is different from using IVprep during installation to ensure you are using the proper image. Do not skip step 4 above, this is a crucial step.

The steps to upgrade are essentially the same for downgrading, or moving to any version. Ensure you obtain a compatible 1vyrain image for your machine, reset all passwords, reset to default, and use IVprep to downgrade. You would then go through the installation steps to install the desired 1vyrain version.


# License

I retain all rights to the code found in this repo (excluding the BIOS roms and the patcher binary), and no one may reproduce, distribute, or create derivative works from this repo without including this README.md file in its entirety!

You are not permitted to share this project on the ThinkPad subreddit.

### Join the ThinkPad discord where research happens - https://discord.gg/xVFx9vM

---

# Credits

This was a monumental amount of work to put together and release, and took a lot of time. 

Special thanks goes to the ThinkPad discord for their efforts testing, especially \x for helping create and finalize the BIOS patches, and digmorepaka for helping shrink the Linux image down significantly.

Huge thanks go out to [gch1p](https://github.com/gch1p/thinkpad-bios-software-flashing-guide) for publishing the method used and [pgera](https://github.com/hamishcoleman/thinkpad-ec/issues/70#issuecomment-417903315) for the working commands, without them this would have not been possible.

Somehow we had ZERO bricks throughout the entire process! No hardware programmers were needed for recovery!

Please consider donating or passing my resume along if this helped you.

Tip me: 
- BTC 3H8kRYoiwS5hNjZddTr5NLYJ77ZwHBpyKp
- ETH 0xB4683485899A654F9DE413FCfDA6ac39d1eB383E
- [PayPal.me](https://paypal.me/customthinkpads)

Tip digmorepaka
- BTC bc1qq795vlcjzutl2nc8cclepz50yhvj07esx6vvwy
- ETH 0x3883E27f38f0B7Cd450e56c1b8BD5B699174836d

Hire me:
- [Resume](https://n4ru.it/resume.pdf)
- [Github](https://github.com/n4ru)
- [Email](mailto:admin@n4ru.it)
