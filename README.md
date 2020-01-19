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

# JOIN THE THINKPAD DISCORD r/ThinkPad MODS DON'T WANT YOU TO KNOW ABOUT! @ http://discord.gg/Ybdz7AS
                  
Software-based "jailbreak" allowing all ivybridge-based xx30 thinkpads to softmod custom bios images.

This repo contains the main script and pre-compiled binary files used in the 1vyrain image to flash machines.

The main link to the ready to go live USB image can be found **[here](https://n4ru.it/1vyrain/)**. *Requires a 4GB+ USB flash drive.*

Updates will be published here in the form of scripts that can be downloaded and ran on the USB image.

**Although 1vyrain has been very thoroughly tested and there were zero bricks during testing, there are some random quirks associated with bypassing normal flashing methods and things can always go awry randomly. There is no warranty or support guaranteed so please keep this in mind if you intend to use this software. I am not responsible for broken devices. Fortunately, it is impossible to permanently brick a device with this method. Worst case scenario, you can flash a backup or fresh BIOS using a hardware programmer.**

# Features:
- Automatic exploit chain unlocking bios region for flashing
- Model detection and automatic bios flashing
- Support for custom bios images (coreboot, skulls, heads)

# BIOS Mod Features:
- Overclocking support (37xx, 38xx, 39xx CPUs)
- Whitelist removal to use any WLAN adapter
- Advanced menu (custom fan curve, TDP, core disable, etc)
- Intel ME disablement via advanced menu

# Before Installing
**Please pay careful attention to this section.** . Ensure you're on a compatible BIOS version before beginning (check compatability [here](https://github.com/gch1p/thinkpad-bios-software-flashing-guide#bios-versions)). Run [IVprep](https://github.com/n4ru/IVprep) if you are not or are unsure. Clear any BIOS passwords or settings prior to flashing, and do a BIOS setting reset if you can. Ensure your ThinkPad is charged and your adapter is plugged in. If you intend to use a custom image, make sure you plug in ethernet prior to boot and that your image is directly accessible via URL.

# Supported Systems
- X230
- X230t
- T430s
- T430
- T530
- W530

**X330 Owners:** Sit tight, we've got support coming for you in the next update.

# Bugs
The following issues persist in Rev1 of 1vyrain but should be fixed in the upcoming release (Rev2)
- WLAN patch doesn't appear to function on X230t, but is fixed and just needs to be updated in 1vyrain.
- T430s exploit fails to unlock the BIOS on some systems.

# Installing

1. Burn the 1vyrain image onto a flash drive.
2. Boot in UEFI mode from the flash drive.
3. Follow the on-screen instructions.
4. That's it! 

Don't be alarmed if your ThinkPad/ThinkLight power cycles a few times after a flash, or you get a CRC Security error. That is *normal* and will go away after another restart!

**NOTE:** This will NOT modify your EC. You are safe to flash your EC with the battery or keyboard mod at any time as long as you are on a version compatible with the EC mod (check compatibility [here](https://github.com/hamishcoleman/thinkpad-ec#compatibilty-warning)). Both IVprep and 1vyrain will only modify the BIOS region! You can safely use this image to update to the latest modded BIOS without losing your EC mod!

# Custom BIOS Images
By default, the image includes the latest BIOS versions for all models, but you can flash a custom image such as heads, skulls, or a coreboot build. Make sure you have wired ethernet attached on boot, and that your image is *EXACTLY* 4MB and uploaded somewhere that you can grab with a simple `wget` command. When asked what to flash, select "Flash a custom BIOS from URL" (option 2). Input the URL. That's it!

Don't worry, if your download screws up or the filesize was wrong, the flashing will simply fail. You won't brick.

# License

I retain all rights to the code found in this repo, and no one may reproduce, distribute, or create derivative works from this repo without including this README.me in its entirety!

This project is not permitted to be shared on the r/ThinkPad subreddit.

---

# Credits

This was a monumental amount of work to put together and release, and took a lot of time. 

Special thanks goes to the r/ThinkPad discord for their efforts testing, especially \x!

Huge thanks go out to [gch1p](https://github.com/gch1p/thinkpad-bios-software-flashing-guide) for publishing the method used and [pgera](https://github.com/hamishcoleman/thinkpad-ec/issues/70#issuecomment-417903315) for the working commands, without them this would have not been possible.

Somehow we had ZERO bricks throughout the entire process! No hardware programmers were needed for recovery!

Please consider donating or passing my resume along if this helped you.

Tip me: 
- BTC 3H8kRYoiwS5hNjZddTr5NLYJ77ZwHBpyKp
- ETH 0xB4683485899A654F9DE413FCfDA6ac39d1eB383E
- [PayPal.me](https://paypal.me/customthinkpads)

Hire me:
- [Resume](https://n4ru.it/resume.pdf)
- [Github](https://github.com/n4ru)
- [Email](mailto:admin@n4ru.it)
