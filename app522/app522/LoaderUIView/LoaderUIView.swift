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
            if true {
                ReOnboardingUIView()
                
            } else {
                UsOnboardingUIView()
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
}

#Preview {
    LoaderUIView()
}
