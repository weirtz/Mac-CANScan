//
//  BluetoothManager.swift
//  Mac CANScan
//
//  Created by Brendan Weirtz on 9/28/23.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject {
    private var centralManager: CBCentralManager!
    
    @Published var isScanning = false
    @Published var discoveredPeripherals: [CBPeripheral] = []
    
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
        return centralManager.retrievePeripherals(withIdentifiers: identifiers)
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
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Handle discovered devices here
        print("Discovered device: \(peripheral.name ?? "Unknown Device")")
        
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
        }
    }
}
