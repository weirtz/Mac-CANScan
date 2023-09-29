//
//  BluetoothManager.swift
//  Mac CANScan
//
//  Created by Brendan Weirtz on 9/28/23.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    private var centralManager: CBCentralManager!
    let serviceUUIDs: [CBUUID]? = nil
    @Published var isScanning = false
    @Published var discoveredPeripherals: [CBPeripheral] = []
    @Published var savedPeripherals: [CBPeripheral] = []

    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isScanning = false
        } else {
            isScanning = true
        }
    }
    
    func retrievePeripherals(withIdentifiers identifiers: [UUID]) -> [CBPeripheral] {
        savedPeripherals = centralManager.retrievePeripherals(withIdentifiers: identifiers)
        return savedPeripherals
    }
    
    func connectDevice(perf: CBPeripheral){
        print("conn call 2")
        centralManager.connect(perf)
        
        
    }
    
    func toggleScan() {
            if isScanning {
                centralManager.stopScan()
                isScanning = false
            }else{
                discoveredPeripherals = []
                centralManager.scanForPeripherals(withServices: nil)
                isScanning = true
            }
        }
    
    func centralManager(_ central: CBCentralManager,  didConnect peripheral: CBPeripheral){
        print("Connected device: \(peripheral.name ?? "Unknown Device")")
        
        // Create an instance of your delegate class
        let peripheralDelegate = BluetoothManager()

        // Set the delegate of the peripheral
        peripheral.delegate = peripheralDelegate

        // Start discovering services (you can pass nil to discover all services)
        peripheral.discoverServices(nil)

    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("service check")
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        
        // Services have been discovered successfully
        if let services = peripheral.services {
            for service in services {
                print("Discovered Service: \(service.uuid)")
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        print("Disconnected device: \(peripheral.name ?? "Unknown Device")")

    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Handle discovered devices here
        //print("Discovered device: \(peripheral.name ?? "Unknown Device")")
        
        if !discoveredPeripherals.contains(peripheral) {
            //print(peripheral.identifier)
            discoveredPeripherals.append(peripheral)
        }
        
        
        //retrievePeripherals(peripheral.identifier)
        
        
//        let uuid = peripheral.identifier
//        let cb = retrievePeripherals(withIdentifiers: [uuid])[0]
//        let name = cb.name
    }
}
