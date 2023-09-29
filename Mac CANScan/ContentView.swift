//
//  ContentView.swift
//  Mac CANScan
//
//  Created by Brendan Weirtz on 9/28/23.
//

import SwiftUI
import CoreBluetooth

//https://stackoverflow.com/questions/34592179/how-get-the-list-of-paired-bluetooth-devices-in-swift
//https://developer.apple.com/documentation/corebluetooth/cbcentralmanager
//https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH3-SW1
struct ContentView: View {
    @ObservedObject var bluetoothManager = BluetoothManager()
    @State private var selectedPeripheral: CBPeripheral?

    
    @State private var buttonText = ""
    var amountNum: Int = 0
    
    var body: some View {
        HStack(alignment: .top){
            //LEFT-------------------
            VStack(alignment: .leading) {
                
                    
                HStack(){
                    Button(action: {bluetoothManager.toggleScan();buttonTexts();}, label: { Text(buttonText) })
                    if(bluetoothManager.isScanning){
                        ProgressView().padding(.leading, 1.0).controlSize(.small)
                    }

                }
                .padding(.vertical)

            
             
                
                @State var devices = bluetoothManager.discoveredPeripherals
                
                
                    
                    ForEach(bluetoothManager.discoveredPeripherals, id: \.self) { peripheral in
                        
                        //Text(peripheral.name ?? "Unnamed Peripheral").tag(peripheral)
                        
                        Button(action: {connectDevice(perf: peripheral); print("click")}, label: {
                            Text(peripheral.name ?? "unknown").tag(peripheral)
                        })
                        
    //
    //                    Button(action: {
    //                        selectedPeripheral = peripheral
    //                        if bluetoothManager.isScanning{
    //                            bluetoothManager.toggleScan()
    //                        }
    //                    }, label: { Text(buttonText) }     ) {
    //                        Text(peripheral.name ?? "Unnamed Peripheral")
    //                    }.tag(peripheral.identifier)
                    }
                
                
            
                
            }
            .padding(.trailing, 49.597)
            //RIGHT-------------------------
            VStack(){
                Text("Saved Devices")
                List {
                    ForEach(bluetoothManager.savedPeripherals, id: \.self) { peripheral in
                        
                        Button(action: {bluetoothManager.toggleScan();buttonTexts();}, label: { Text(peripheral.name ?? "unknwon") })

    //
    //                    Button(action: {
    //                        selectedPeripheral = peripheral
    //                        if bluetoothManager.isScanning{
    //                            bluetoothManager.toggleScan()
    //                        }
    //                    }, label: { Text(buttonText) }     ) {
    //                        Text(peripheral.name ?? "Unnamed Peripheral")
    //                    }.tag(peripheral.identifier)
                    }

                }
                
                
            }
            .frame(width: 265.33)
            
        }
        
        .padding()
        .onAppear {
            // Set the initial button text based on the initial state of bluetoothManager
            buttonTexts()
            //bluetoothManager.retrievePeripherals()
        }
    }
    
    func selectDevice(){}
    func buttonTexts(){
        buttonText = bluetoothManager.isScanning ? "Stop Scanning" : "Start Scanning"
    }
    func connectDevice(perf: CBPeripheral){
        print("conn call 1")
        bluetoothManager.connectDevice(perf: perf)
    }
    
    mutating func incr(){
        amountNum += 1
    }
    
}

#Preview {
    ContentView()
}
