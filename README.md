unmaintained
please goto https://github.com/asakous/Neo-EmuELEC-H3 instead<br>
#H3<br>
This repository is only for Allwinner H3 devices. Don't use it on other devices and don't build as KODI addon because it probably won't work.

Because Libreelec use host tools to make image, so if you are using linux distro that have new ext4 features such as 64bit metadata_csum(/etc/mke2fs.conf) .don't forget to remove it otherwise image won't boot.

use command below to compile the program.<br>
PROJECT=H3 ARCH=arm DISTRO=EmuELEC make -j4 image

#Traditional Chinese<br>
編譯完的 image 的只能用在 Allwinner H3 相關的版子上，不能用在其它的版子上。<br>
程式也不保証能用在 KODI 的 addon 上。<br>

如果你用的是 Orange Pi PC ，image 檔直接用 win32image 燒即可，其它 H3 相關的版子可試著把script.bin 換掉，也許這樣就可以用。<br>
相關的 scripts.bin 在 bootloader 的壓縮檔裡。把 xxx.fex 更名成script.bin 然後取代SD卡上的script.bin<br>

如果你自已想編譯你自已的版本請注意。你必需拿掉 /etc/mke2fs.conf 檔裡的 64bit 跟 metadata_csum。不然產生的IMAGE 不會開機。<br>
這主要的原因是因為這版本的linux kernel 用的是舊ext4 ，但在產生IMAGE時用卻用本機上新的ext4程式，所以開機時舊的ext4 mount 不起來新ext4 的image，然後當掉。雖然我已經上了一版新的修正程式，但我不保証在其它的LINUX版本上也能正確編譯。

編譯時請在用底下的指令<br>
PROJECT=H3 ARCH=arm DISTRO=EmuELEC make -j4 image<br>

我的開發環境用的是 18.04.1-Ubuntu x64 。用 windows 10 的 hyper-v 建的。<br>

# EmuELEC  
Retro emulation for Amlogic devices.  
Based on  [CoreELEC](https://github.com/CoreELEC/CoreELEC) and [Lakka](https://github.com/libretro/Lakka-LibreELEC), I just combine them with [Emulationstation](https://github.com/RetroPie/EmulationStation) and some standalone emulators ([Advancemame](https://github.com/amadvance/advancemame), [PPSSPP](https://github.com/hrydgard/ppsspp), [Reicast](https://github.com/reicast/reicast-emulator), [Amiberry](https://github.com/midwan/amiberry) and others). 

To build use:  

```
sudo apt update && sudo apt upgrade
sudo apt-get install gcc make git unzip wget xz-utils libsdl2-dev libsdl2-mixer-dev libfreeimage-dev libfreetype6-dev libcurl4-openssl-dev rapidjson-dev libasound2-dev libgl1-mesa-dev build-essential libboost-all-dev cmake fonts-droid-fallback libvlc-dev libvlccore-dev vlc-bin texinfo
git clone https://github.com/shantigilbert/EmuELEC.git EmuELEC    
cd EmuELEC  
git checkout EmuELEC  
PROJECT=Amlogic ARCH=arm DISTRO=EmuELEC make image   
```
For the Odroid N2:   
`PROJECT=Amlogic-ng ARCH=arm DISTRO=EmuELEC make image`

if you want to build the addon: 
```
cd EmuELEC
./emuelec-addon.sh
```
resulting zip files will be inside EmuELEC/repo

**Remember to use the proper DTB for your device!**

Need help? have suggestions? check out the Wiki at https://github.com/shantigilbert/EmuELEC/wiki or join us on our EmuELEC Discord: https://discord.gg/QqGYBzG

**EmuELEC DOES NOT INCLUDE KODI**

Please note, this is mostly a personal project made for my S905 box I can't guarantee that it will work for your box, I've spent many hours trying to optimize and make sure everything works, but I can't test everything and things might just not work at all, also keep in mind the limitations of the hardware and don't expect everything to run at 60FPS (specially N64, PSP and Reicast) I can't guarantee changes to fit your personal needs, but I do appreciate any PRs, help on testing other boxes and fixing issues in general.  
I work on this project on my personal time, I don't make any money out of it, so it takes a while for me to properly test any changes, but I will do my best to help you fix issues you might have on other boxes limited to my time and experience. 

Happy retrogaming! 
