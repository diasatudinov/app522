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
        guard let url = URL(string: "https://apps.apple.com/app/abilogic-core/id6690986537") else { return }
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
        guard let url = URL(string: "https://www.termsfeed.com/live/5c5af29b-255f-4ea9-95cc-0b126a79b48c") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
