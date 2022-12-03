//
//  RangeFinderDeviceDelegate.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 11/19/22.
//

import Foundation
import nutble
import GoogleMaps

class RangeFinderDeviceService: NSObject, NTDeviceManagerDelegate, NTDeviceDelegate {
    
    static let sharedInstance = RangeFinderDeviceService()
    
    private var discoveredDevices: [NTDevice] = []
    private var connectedDevice: NTDevice?
    private var deviceLocation: CLLocationCoordinate2D?
        
    func setDeviceLocation(location: CLLocationCoordinate2D) {
        deviceLocation = location
    }
    
    func disconnectDevice() {
        if connectedDevice != nil {
            connectedDevice?.cancelConnection()
        }
    }
    
    func getConnectedDevice() -> NTDevice? {
        return connectedDevice
    }
    
    func isConnectedToADevice() -> Bool {
        return connectedDevice != nil
    }
    
    func deviceManager(_ manager: NTDeviceManager!, didUpdate state: CBCentralManagerState) {
        
    }
    
    func deviceManager(_ manager: NTDeviceManager!, didDiscoveredDevice device: NTDevice!, rssi: NSNumber!) {
        discoveredDevices.append(device)
    }
    
    func deviceDidConnect(_ device: NTDevice!) {
        connectedDevice = device
        print("Device Connected: \(device.localName ?? "" )")
        NotificationCenter.default.post(name: Constants.deviceConnectionSuccessNotifName, object: nil)
    }
    
    func deviceDidDisconnected(_ device: NTDevice!) {
        print("Device disconnected.")
        connectedDevice = nil
        var deviceInfo = DeviceInfoDTO()
        deviceInfo.deviceName = device.localName
        deviceInfo.deviceLatitude = Double(deviceLocation?.latitude ?? 0)
        deviceInfo.deviceLongitude = Double(deviceLocation?.longitude ?? 0)
        OneFinderUserDefaults.sharedInstance.addDeviceInfo(deviceInfo: deviceInfo)
    }
    
    func device(_ device: NTDevice!, didFailedToConnect error: Error!) {
        print("Unable to connect to the device: \(device.localName ?? "" )")
    }
    
    func device(_ device: NTDevice!, didUpdateRSSI RSSI: NSNumber!) {
        
    }
    
    func device(_ device: NTDevice!, didUpdateBattery battery: NSNumber!) {
        
    }
    
    func device(_ device: NTDevice!, didClicked numberOfClick: Int) {
        
    }
    
}
