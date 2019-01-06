# Jake's Fallout 4 UI Mod

I got tired of how single item focused the inventory was in Fallout 4. So I decided to implement a "Detailed" view.

Do note, that a lot of this is freshly decompiled flash! And this is a very work-in-progress project!

# How To Setup / Compile
Run setup.bat to create the shared folder "Windows Links" needed to compile.

The actual flash files can be found in the `PipBoy InvPage\PipBoy InvPage` and `PipboyMenu\PipboyMenu`. (I tried cleaning that up, but Adobe Animate is wacky.) You'll need Adobe Flash/Animate to compile the xfl file to swf. I personally use Adobe Animate CC. It's a bit pricey, but it works. 

I recommend using something like Visual Studio Code for the Actionscript files, especially using [this plugin](https://marketplace.visualstudio.com/items?itemName=bowlerhatllc.vscode-nextgenas) and the Adobe Flex SDK for autocomplete. 

Once compiled/published, place the SWFs in `Fallout 4\Data\Interface`. 

# Shared Folder
The UI code uses a `Shared` package. However this is not stored in a one off swf. Instead pieces are put in each published swf. Normally you'd just modify them like any other file, but in this case `PipboyMenu.swf` loads `PipBoy InvPage.swf`. So the shared code from `PipboyMenu.swf` is already loaded memory by the time it loads in `PipBoy InvPage.swf`. So basically if you have to edit any `Shared` package code, make sure to publish `PipboyMenu.swf` as well!

# Live Reloading
By default (for some reason...) most (if not all) of Fallout 4's UI code is loaded on demand and not cached. So you can leave the game running, save a new swf and press tab to view your new pipboy immediately. 

# Logging Trace Statements
[Fallout 4 Script Extender](http://f4se.silverlock.org/) is needed. Once installed, create a file called `f4se.ini` in `Fallout 4\Data\F4SE` and add the following to the file.

```
[Interface]
bEnableGFXLog=1
```

The log file should be generated `My Documents\my games\Fallout4\F4SE` as `f4se.log`. You can use tail to live load the file.

Note: Before I found out about this (Thanks [Scrivener](https://github.com/Scrivener07) for the tip!) I wrote a mini on screen debug logger. It's still semi-functional but it'll be removed eventually. You can activate it in the inventory screen by pressing scroll lock!


# Fonts Fonts Fonts!
I've included fonts_en.swf which is needed to compile. 

# Thanks
Special thanks to [Scrivener](https://github.com/Scrivener07) for answering my questions about Fallout 4's interface code and quirks!
