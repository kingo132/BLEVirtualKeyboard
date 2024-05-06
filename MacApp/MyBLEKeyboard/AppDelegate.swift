import Foundation
import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var downEventMonitor: Any?
    var upEventMonitor: Any?
    var flagsChangedMonitor: Any?
    var serialManager = SerialManager()
    var previousModifierFlags: NSEvent.ModifierFlags = []
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create and set up the main window with the desired size
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 300),  // Adjust to the desired size
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered, defer: false
        )
        
        // Center the window on the screen
        window.center()
        window.title = "My BLE Keyboard"
        window.makeKeyAndOrderFront(nil)

        // Create a SwiftUI ContentView and embed it in the window
        let contentView = ContentView()
        window.contentView = NSHostingView(rootView: contentView)
        
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)

        if accessEnabled {
            setupLocalKeyMonitor()
            // 9600   115200
            serialManager.openSerialPort(path: "/dev/tty.usbserial-57130819461", baudRate: 9600)
        } else {
            NSLog("Accessibility access is not enabled")
        }
    }
    
    func handleModifierKeys(event: NSEvent) {
        // Current state of modifier flags
        let currentFlags = event.modifierFlags

        // Check for Shift key changes
        let shiftChanged = currentFlags.contains(.shift) != previousModifierFlags.contains(.shift)
        if shiftChanged {
            if currentFlags.contains(.shift) {
                //print("Shift key pressed")
                let command = "P56\n"
                if let data = command.data(using: .utf8) {
                    serialManager.send(data: data)
                }
            } else {
                //print("Shift key released")
                let command = "R56\n"
                if let data = command.data(using: .utf8) {
                    serialManager.send(data: data)
                }
            }
        }

        // Check for Control key changes
        let controlChanged = currentFlags.contains(.control) != previousModifierFlags.contains(.control)
        if controlChanged {
            if currentFlags.contains(.control) {
                //print("Control key pressed")
                let command = "P59\n"
                if let data = command.data(using: .utf8) {
                    serialManager.send(data: data)
                }
            } else {
                //print("Control key released")
                let command = "R59\n"
                if let data = command.data(using: .utf8) {
                    serialManager.send(data: data)
                }
            }
        }

        // Check for Alt/Option key changes
        let optionChanged = currentFlags.contains(.option) != previousModifierFlags.contains(.option)
        if optionChanged {
            if currentFlags.contains(.option) {
                //print("Alt/Option key pressed")
                let command = "P58\n"
                if let data = command.data(using: .utf8) {
                    serialManager.send(data: data)
                }
            } else {
                //print("Alt/Option key released")
                let command = "R58\n"
                if let data = command.data(using: .utf8) {
                    serialManager.send(data: data)
                }
            }
        }

        // Check for Command key changes
        let commandChanged = currentFlags.contains(.command) != previousModifierFlags.contains(.command)
        if commandChanged {
            if currentFlags.contains(.command) {
                //print("Command key pressed")
                let command = "P55\n"
                if let data = command.data(using: .utf8) {
                    serialManager.send(data: data)
                }
            } else {
                //print("Command key released")
                let command = "R55\n"
                if let data = command.data(using: .utf8) {
                    serialManager.send(data: data)
                }
            }
        }

        // Update previous modifier flags
        previousModifierFlags = currentFlags
    }
    
    func handleKeyPress(event: NSEvent, action: String) {
        //print("Key \(action == "P" ? "Pressed" : "Released"): \(event.keyCode)")
        
        // Create a string command with action ("P" for press, "R" for release) and key code
        let command = "\(action)\(event.keyCode)\n"
        //print("Sending command: \(command)")
        if let data = command.data(using: .utf8) {
            serialManager.send(data: data)
        }
    }

    func setupLocalKeyMonitor() {
        // Monitor key-down events
        downEventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { event in
            self.handleKeyPress(event: event, action: "P")
            return event
        }
        
        // Monitor key-up events
        upEventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyUp]) { event in
            self.handleKeyPress(event: event, action: "R")
            return event
        }

        // Monitor modifier keys (Shift, Alt, Ctrl, Command)
        flagsChangedMonitor = NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged]) { event in
            self.handleModifierKeys(event: event)
            return event
        }
    }

    /*
    func setupGlobalKeyMonitor() {
        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { (event) -> NSEvent? in
            self.handleKeyPress(event: event)
            return event  // Return the event for further processing
        }
    }

    func handleKeyPress(event: NSEvent) {
        print("Key Pressed: \(event.keyCode)")
        if let data = "\(event.keyCode)\n".data(using: .utf8) {
            serialManager.send(data: data)
        }
    }
     */

    func applicationWillTerminate(_ aNotification: Notification) {
        if let monitor = downEventMonitor {
            NSEvent.removeMonitor(monitor)
        }
        if let monitor = upEventMonitor {
            NSEvent.removeMonitor(monitor)
        }
        if let monitor = flagsChangedMonitor {
            NSEvent.removeMonitor(monitor)
        }
        serialManager.closeSerialPort()
    }
}
