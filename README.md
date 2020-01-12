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
                  
Software-based "jailbreak" allowing all ivybridge-based xx30 thinkpads to softmod custom bios images.

This repo contains the main script and pre-compiled binary files used in the 1vyrain image to flash machines.

The main link to the ready to go live USB image can be found **[here](https://n4ru.it/1vyrain/)**. *Requires a 4GB+ USB flash drive.*

Updates will be published here in the form of scripts that can be downloaded and ran on the USB image.

# Features:
- Automatic exploit chain unlocking bios region for flashing
- Model detection and automatic bios flashing
- Support for custom bios images (coreboot, skulls, heads)

# BIOS Mod Features:
- Overclocking support (37xx, 38xx, 39xx CPUs)
- Whitelist removal to use any WLAN adapter
- Advanced menu (custom fan curve, TDP, core disable, etc)
- Intel ME disablement via advanced menu

# Install

0. Ensure you're on a compatible BIOS version. Run [IVprep](https://github.com/n4ru/IVprep) if you are not.
1. Burn the 1vyrain image onto a flash drive.
2. Boot in UEFI mode from the flash drive.
3. Follow the on-screen instructions.
4. That's it! 

Don't be alarmed if your ThinkPad/ThinkLight power cycles a few times after a flash. That is *normal*!

**NOTE:** This will NOT modify your EC. You are safe to flash your EC with the battery or keyboard mod at any time as long as you are on a version compatible with the EC mod (check compatibility [here](https://github.com/hamishcoleman/thinkpad-ec#compatibilty-warning)). Both IVprep and 1vyrain will only modify the BIOS region! You can safely use this image to update to the latest modded BIOS without losing your EC mod!

# Custom BIOS Images
By default, the image includes the latest BIOS versions for all models, but you can flash a custom image such as heads, skulls, or a coreboot build. Make sure you have wired ethernet attached on boot, and that your image is *EXACTLY* 4MB and uploaded somewhere that you can grab with a simple `wget` command. When asked what to flash, select "Flash a custom BIOS from URL" (option 2). Input the URL. That's it!

Don't worry, if your download screws up or the filesize was wrong, the flashing will simply fail. You won't brick.

---

This was a monumental amount of work to put together and release, and took a lot of time. 

Special thanks goes to the r/ThinkPad discord for their efforts testing, especially \x!

Somehow we had ZERO bricks throughout the entire process! No hardware programmers were needed for recovery!

Please consider donating or passing my resume along.

Tip me: 
- BTC 3H8kRYoiwS5hNjZddTr5NLYJ77ZwHBpyKp
- ETH 0xB4683485899A654F9DE413FCfDA6ac39d1eB383E
- [PayPal.me](https://paypal.me/customthinkpads)

Hire me:
- [Resume](https://n4ru.it/resume.pdf)
- [Github](https://github.com/n4ru)
- [Email](mailto:admin@n4ru.it)
