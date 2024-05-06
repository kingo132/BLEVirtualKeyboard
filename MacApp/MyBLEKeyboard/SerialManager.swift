import Foundation

class SerialManager: NSObject, ORSSerialPortDelegate {
    var serialPort: ORSSerialPort?

    func openSerialPort(path: String, baudRate: Int) {
        if let serial = serialPort, serial.isOpen {
            print("Closing existing serial port connection...")
            serial.close()
        }

        serialPort = ORSSerialPort(path: path)
        serialPort?.delegate = self
        serialPort?.baudRate = NSNumber(value: baudRate)

        do {
            try serialPort?.open()
        } catch {
            print("Error opening serial port: \(error)")
        }
    }

    func closeSerialPort() {
        serialPort?.close()
        serialPort = nil
    }

    func send(data: Data) {
        serialPort?.send(data)
    }

    // MARK: - ORSSerialPortDelegate Methods

    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        print("Serial port opened successfully.")
    }

    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        print("Serial port was closed.")
    }

    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        print("Received data: \(data)")
    }

    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print("Serial port error: \(error)")
    }

    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        print("Serial port was removed from the system.")
        self.serialPort = nil
    }
}
