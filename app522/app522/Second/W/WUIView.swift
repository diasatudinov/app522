//
//  WUIView.swift
//  app522
//
//  Created by Dias Atudinov on 18.09.2024.
//

import SwiftUI
import WebKit

struct WUIView: View {
    @State private var lastVisitedURL: URL? = UserDefaults.standard.url(forKey: "lastVisitedURL")
    @State private var decodedString: String? = "https://podlaorlf.space/Zx7PsPLw"
    
    var body: some View {
        WebView(lastVisitedURL: $lastVisitedURL)
            .onAppear {
                loadLastVisitedURL()
            }
            .onDisappear {
                saveLastVisitedURL()
            }
    }

    private func loadLastVisitedURL() {
        if let savedURL = UserDefaults.standard.url(forKey: "lastVisitedURL") {
            lastVisitedURL = savedURL
        } else {
            lastVisitedURL = URL(string: decodedString ?? "https://google.com")
        }
    }
    
    private func saveLastVisitedURL() {
        if let url = lastVisitedURL {
            UserDefaults.standard.set(url, forKey: "lastVisitedURL")
        }
    }
}

struct WebView: UIViewControllerRepresentable {
    @Binding var lastVisitedURL: URL?

    func makeUIViewController(context: Context) -> WebViewController {
        let viewController = WebViewController()
        viewController.lastVisitedURL = lastVisitedURL
        return viewController
    }

    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
        if let url = lastVisitedURL, url != uiViewController.webView.url {
            let request = URLRequest(url: url)
            uiViewController.webView.load(request)
        }
    }
}

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var lastVisitedURL: URL?

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        loadCookies(into: webView)
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = lastVisitedURL {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Allow autorotation
        UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }

    private func loadCookies(into webView: WKWebView) {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
            }
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HTTPCookieStorage.shared.cookies?.forEach { cookie in
            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        if let url = webView.url {
            UserDefaults.standard.set(url, forKey: "lastVisitedURL")
        }
    }
}


#Preview {
    WUIView()
}
