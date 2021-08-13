# Timelapse-Creator
An interactive batch-script using ffmpeg to encode a sequence of images into (timelapse) video

## What this does
If you want to create a timelapse (or other video) from still images then this automates much of the process. 
The script takes a sequence of images in png or jpg format and with a four digit number at the end of their names.
Can create videos for editing (prores-codec), all-purpose video (h264/h265) or gifs.

## Dependencies
ffmpeg & Windows

## How to use
Download the **.bat file and move/copy it into the folder with the sequence of images.
Run the script and enter the desired choices or settings.
Pick one of the presets (which are tested for minimum loss of image quality but large sizes) or go into the custom menu.
The script will create three sub-folders and insert the encoded videos accordingly

## Proxy for video editing
When encoding prores-codec video files additional "proxy" videos with the same names will be created in the proxy-sub-folder.
These can be used for video editing and later replaced with their full resolution counterparts

## Aspect ratio
Currently you can use the custom menu to define a nonstandard (i.e. not 16:9) aspect ratio by changing the width (after chosing the height).
This will crop the video around the center.

## Creator's Notice
This is my first repository so be gentle. I created this mainly for myself but wanted to start sharing these small solutions on here. 
