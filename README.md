# BLEVirtualKeyboard

This repo uses your MacBook's built-in keyboard to act as a Bluetooth keyboard. This is useful when you bring a MacBook and another no-keyboard device with you, such as Steam Deck, Rog Ally or a Surface Pro without a keyboard. You can use the MacBook to type to that no-keyboard device. The only additional hardware you need to bring is TinyPICO, which is as small and light as chewing gum.

To use this code, you need a TinyPICO, which you can purchase from here: https://www.adafruit.com/product/5028

Then, upload the code TinyPICO/SendKeyStrokes.ino to TinyPICO using Arduino IDE.

Next, search for the Bluetooth keyboard named BLEKeyboard on your device and connect to it.

After that, open MacApp using XCode, compile and run, then type the keyboard, you can see it becomes a virtual Bluetooth keyboard.
