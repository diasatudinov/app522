//
//  SettingsViewModel.swift
//  app522
//
//  Created by Dias Atudinov on 09.09.2024.
//

import SwiftUI
import StoreKit

class SettingsViewModel: ObservableObject {
    func shareApp() {
        guard let url = URL(string: "https://apps.apple.com/app/dafaski/id6633439878") else { return }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func rateApp() {
        SKStoreReviewController.requestReview()
    }
    
    func openUsagePolicy() {
        guard let url = URL(string: "https://www.termsfeed.com/live/58023c7e-7f73-46fd-9717-e9b281701e26") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
