//
//  ContentView.swift
//  Mac CANScan
//
//  Created by Brendan Weirtz on 9/28/23.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @ObservedObject var bluetoothManager = BluetoothManager()
    @State private var selectedPeripheral: CBPeripheral?
    
    @State private var buttonText = ""
    
    var body: some View {
        VStack {
            
            Button(action: {bluetoothManager.toggleScan();buttonTexts();}, label: { Text(buttonText) })
            
            Menu {
                ForEach((1...5), id: \.self) {
                    Button("\($0)", action: selectDevice)
                    Divider()
                }
            } label: {
                Image(systemName: "bookmark.circle")
                    .resizable()
                    .frame(width:24.0, height: 24.0)
            }
            
            
            
            Menu("Discovered Peripherals") {
                           ForEach(bluetoothManager.discoveredPeripherals, id: \.self) { peripheral in
                               Button(action: {
                                   selectedPeripheral = peripheral
                                   if bluetoothManager.isScanning{
                                       bluetoothManager.toggleScan()
                                   }
                               }) {
                                   Text(peripheral.name ?? "Unnamed Peripheral")
                               }
                           }
                       }
                       
                       if let selectedPeripheral = selectedPeripheral {
                           Text("Selected Peripheral: \(selectedPeripheral.name ?? "Unnamed Peripheral")")
                       }
            
            
        }
        .padding()
        .onAppear {
            // Set the initial button text based on the initial state of bluetoothManager
            buttonTexts()
        }
    }
    
    func selectDevice(){}
    func buttonTexts(){
        buttonText = bluetoothManager.isScanning ? "Stop Scanning" : "Start Scanning"
    }
}

#Preview {
    ContentView()
}
