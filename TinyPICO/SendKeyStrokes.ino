#include <BleKeyboard.h>

// Modifier flags
bool isShiftPressed = false;

// Initialize BleKeyboard instance
BleKeyboard bleKeyboard("PicoKeyboard");

// Function to map macOS key codes to BleKeyboard constants or ASCII characters
uint8_t mapMacKeyCodeToBleKeyboardKey(int keyCode) {
    switch (keyCode) {
        // Letters
        case 0x00: return isShiftPressed ? 'A' : 'a';  // A
        case 0x01: return isShiftPressed ? 'S' : 's';  // S
        case 0x02: return isShiftPressed ? 'D' : 'd';  // D
        case 0x03: return isShiftPressed ? 'F' : 'f';  // F
        case 0x04: return isShiftPressed ? 'H' : 'h';  // H
        case 0x05: return isShiftPressed ? 'G' : 'g';  // G
        case 0x06: return isShiftPressed ? 'Z' : 'z';  // Z
        case 0x07: return isShiftPressed ? 'X' : 'x';  // X
        case 0x08: return isShiftPressed ? 'C' : 'c';  // C
        case 0x09: return isShiftPressed ? 'V' : 'v';  // V
        case 0x0B: return isShiftPressed ? 'B' : 'b';  // B
        case 0x0C: return isShiftPressed ? 'Q' : 'q';  // Q
        case 0x0D: return isShiftPressed ? 'W' : 'w';  // W
        case 0x0E: return isShiftPressed ? 'E' : 'e';  // E
        case 0x0F: return isShiftPressed ? 'R' : 'r';  // R
        case 0x10: return isShiftPressed ? 'Y' : 'y';  // Y
        case 0x11: return isShiftPressed ? 'T' : 't';  // T

        // Numbers and Symbols
        case 0x12: return isShiftPressed ? '!' : '1';  // 1 or !
        case 0x13: return isShiftPressed ? '@' : '2';  // 2 or @
        case 0x14: return isShiftPressed ? '#' : '3';  // 3 or #
        case 0x15: return isShiftPressed ? '$' : '4';  // 4 or $
        case 0x16: return isShiftPressed ? '^' : '6';  // 6 or ^
        case 0x17: return isShiftPressed ? '%' : '5';  // 5 or %
        case 0x18: return isShiftPressed ? '+' : '=';  // Equals or Plus
        case 0x19: return isShiftPressed ? '(' : '9';  // 9 or (
        case 0x1A: return isShiftPressed ? '&' : '7';  // 7 or &
        case 0x1B: return isShiftPressed ? '_' : '-';  // Hyphen or Underscore
        case 0x1C: return isShiftPressed ? '*' : '8';  // 8 or *
        case 0x1D: return isShiftPressed ? ')' : '0';  // 0 or )
        case 0x1E: return isShiftPressed ? '}' : ']';  // Close Bracket or Brace
        case 0x1F: return isShiftPressed ? 'O' : 'o';  // O
        case 0x20: return isShiftPressed ? 'U' : 'u';  // U
        case 0x21: return isShiftPressed ? '{' : '[';  // Open Bracket or Brace
        case 0x22: return isShiftPressed ? 'I' : 'i';  // I
        case 0x23: return isShiftPressed ? 'P' : 'p';  // P
        case 0x24: return KEY_RETURN;  // Return/Enter
        case 0x25: return isShiftPressed ? 'L' : 'l';  // L
        case 0x26: return isShiftPressed ? 'J' : 'j';  // J
        case 0x27: return isShiftPressed ? '"' : '\'';  // Single or Double Quote
        case 0x28: return isShiftPressed ? 'K' : 'k';  // K
        case 0x29: return isShiftPressed ? ':' : ';';  // Semicolon or Colon
        case 0x2A: return isShiftPressed ? '|' : '\\';  // Backslash or Pipe
        case 0x2B: return isShiftPressed ? '<' : ',';  // Comma or Less-than
        case 0x2C: return isShiftPressed ? '?' : '/';  // Slash or Question Mark
        case 0x2D: return isShiftPressed ? 'N' : 'n';  // N
        case 0x2E: return isShiftPressed ? 'M' : 'm';  // M
        case 0x2F: return isShiftPressed ? '>' : '.';  // Period or Greater-than

        // Special Characters
        case 0x32: return isShiftPressed ? '~' : '`';  // Grave/Tilde
        case 0x33: return KEY_BACKSPACE;  // Backspace/Delete
        case 0x30: return KEY_TAB;  // Tab
        case 0x31: return ' ';  // Space
        case 0x35: return KEY_ESC;  // Escape
        case 0x39: return KEY_CAPS_LOCK;  // Caps Lock

        // Function Keys (F1-F12)
        case 0x7A: return KEY_F1;
        case 0x78: return KEY_F2;
        case 0x63: return KEY_F3;
        case 0x76: return KEY_F4;
        case 0x60: return KEY_F5;
        case 0x61: return KEY_F6;
        case 0x62: return KEY_F7;
        case 0x64: return KEY_F8;
        case 0x65: return KEY_F9;
        case 0x6D: return KEY_F10;
        case 0x67: return KEY_F11;
        case 0x6F: return KEY_F12;

        // Arrow Keys
        case 0x7B: return KEY_LEFT_ARROW;
        case 0x7C: return KEY_RIGHT_ARROW;
        case 0x7D: return KEY_DOWN_ARROW;
        case 0x7E: return KEY_UP_ARROW;

        // Navigation Keys
        case 0x73: return KEY_HOME;
        case 0x74: return KEY_PAGE_UP;
        case 0x75: return KEY_DELETE;  // Forward Delete
        case 0x77: return KEY_END;
        case 0x79: return KEY_PAGE_DOWN;

        // Modifier Keys
        case 0x38: isShiftPressed = true; return KEY_LEFT_SHIFT;
        case 0x3B: return KEY_LEFT_CTRL;
        case 0x3A: return KEY_LEFT_ALT;
        case 0x37: return KEY_LEFT_GUI;  // Command key
        case 0x3C: isShiftPressed = true; return KEY_RIGHT_SHIFT;
        case 0x3D: return KEY_RIGHT_ALT;
        case 0x3E: return KEY_RIGHT_CTRL;

        default: return 0;  // Unknown key
    }
}

void setup() {
    Serial.begin(9600);
    bleKeyboard.begin();
}

void loop() {
    if (Serial.available()) {
        String command = Serial.readStringUntil('\n');
        if (command.length() > 1) {
            char action = command.charAt(0);
            int keyCode = command.substring(1).toInt();
            uint8_t mappedKey = mapMacKeyCodeToBleKeyboardKey(keyCode);

            if (action == 'P') {  // Press action
                bleKeyboard.press(mappedKey);
            } else if (action == 'R') {  // Release action
                bleKeyboard.release(mappedKey);

                // If Shift key was released, update its state
                if (keyCode == 0x38 || keyCode == 0x3C) {
                    isShiftPressed = false;
                }
            }
        }
    }
}
