//
//  LoaderUIView.swift
//  app522
//
//  Created by Dias Atudinov on 05.09.2024.
//

import SwiftUI

struct LoaderUIView: View {
    @State private var progress: Double = 0.0
    @State private var timer: Timer?
    @State private var isLoadingView: Bool = true

    var body: some View {
        if isLoadingView {
            ZStack {
                Color.main
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Image("logo522")
                    Spacer()
                    ZStack {
                        HStack(spacing: 5) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(x: 1, y: 1, anchor: .center)
                           
                            Text("\(Int(progress))%")
                                .font(.system(size: 17))
                                .foregroundColor(.white)
                                
                        }
                            
                    }
                    .foregroundColor(.black)
                    .padding(14)
                    .padding(.bottom, 150)
                }
                .onAppear {
                    startTimer()
                }
                .onDisappear {
                    timer?.invalidate()
                }
                
            }
            
        } else {
            if isWithinTwoDays() {
                ReOnboardingUIView()
                
            } else if getAccess() == false {
                UsOnboardingUIView()
            } else {
                ReOnboardingUIView()
            }
            
        }
    }
    func startTimer() {
        timer?.invalidate()
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            if progress < 100 {
                progress += 1
            } else {
                timer.invalidate()
                isLoadingView.toggle()
            }
        }
    }
    
    private func getAccess () -> Bool {
        let deviceData = DeviceInfo.collectData()
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        guard !deviceData.isCharging else { return true }
        guard deviceData.batteryLevel < 1 && deviceData.batteryLevel > 0 else { return true }
        guard !deviceData.isVPNActive else { return true }
        return false
    }
    
    func isWithinTwoDays() -> Bool {
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 09
        dateComponents.day = 19
        dateComponents.hour = 1
        
        if let today = Calendar.current.date(from: dateComponents) {
          
            if let twoDaysFromNow = Calendar.current.date(byAdding: .day, value: 2, to: today) {
               
                return Date() <= twoDaysFromNow
            }
        }
        return false
    }
   
}

#Preview {
    LoaderUIView()
}


import CoreTelephony

struct DeviceData {
    var isVPNActive: Bool
    var isCharging: Bool
    var batteryLevel: Double
}



struct DeviceInfo {
    
    static func collectData() -> DeviceData {
        
        var isConnectedToVpn: Bool {
            
            let vpnProtocolsKeysIdentifiers = [
                "tap", "tun", "ppp", "ipsec", "utun", "ipsec0", "utun1", "utun2"
            ]
            
            guard let cfDict = CFNetworkCopySystemProxySettings() else { return false }
            
            let nsDict = cfDict.takeRetainedValue() as NSDictionary
            
            guard let keys = nsDict["__SCOPED__"] as? NSDictionary,
                  let allKeys = keys.allKeys as? [String] else { return false }
            for key in allKeys {
                
                for protocolId in vpnProtocolsKeysIdentifiers
                        
                where key.starts(with: protocolId) {
                    
                    return true
                }
            }
            
            return false
        }
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = Double(UIDevice.current.batteryLevel)
        
        return DeviceData(
            isVPNActive: isConnectedToVpn,
            isCharging: UIDevice.current.batteryState == .charging,
            batteryLevel: batteryLevel
        )
    }
}

