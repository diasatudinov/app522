//
//  UsOnboardingUIView.swift
//  app522
//
//  Created by Dias Atudinov on 05.09.2024.
//

import SwiftUI
import StoreKit


struct UsOnboardingUIView: View {
    @State private var progress: Double = 0.0
    @State private var timer: Timer?
    @State private var isLoadingView: Bool = true
    @State private var isNotificationView: Bool = true
    @State private var pageNum: Int = 1
    @AppStorage("onboardingShowed") var onboardingShowed: Bool = false

    var body: some View {
        if !onboardingShowed {
            if pageNum < 3 {
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    
                    ZStack {
                        VStack {
                            switch pageNum {
                            case 1:
                                ZStack {
                                    VStack {
                                        ZStack {
                                            Image("firstScreen522Bg")
                                                //.resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 500)
                                                
                                            Image("firstScreen522")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 500)
                                            
                                        }
                                        Spacer()
                                    }
                                }.padding(.top, UIScreen.main.bounds.height/6)
                            case 2: 
                                ZStack {
                                    Image("firstScreen522Bg")
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 500)
                                        
                                    Image("ratings522")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 500)
                                    
                                }
                            default:
                                Image("notifications522")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 500)
                                    .ignoresSafeArea()
                            }
                            
                            
                            
                        }
                        VStack {
                            
                            switch pageNum {
                            case 1:
                                VStack(spacing: 12) {
                                    Text("Show your financial \ngrowth")
                                        .font(.system(size: 32, weight: .bold))
                                        .multilineTextAlignment(.center)
                                    
                                }.frame(height: 160).padding(.bottom, 10).padding(.horizontal, 30).foregroundColor(.black)
                                
                            case 2:
                                VStack(spacing: 12) {
                                    Text("Rate our app in the \nAppStore")
                                        .font(.system(size: 34, weight: .bold))
                                        .multilineTextAlignment(.center)
                                }.frame(height: 160).padding(.bottom, 10).padding(.horizontal, 30).foregroundColor(.black)
                                    .onAppear{
                                        rateApp()
                                    }
                            default:
                                Text("Don’t miss anything")
                                    .font(.title)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.black)
                                    .padding(.bottom, 10)
                                Text("Don’t miss the most userful information")
                                    .foregroundColor(.white).opacity(0.7)
                                
                            }
                            
                        }.padding(.bottom, UIScreen.main.bounds.height * 2/2.7)
                        
                        VStack {
                            
                            Spacer()
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(pageNum == 1 ? Color.black : Color.white)
                                    .frame(height: 8)
                                
                                Circle()
                                    .fill(pageNum == 2 ? Color.black : Color.white)
                                    .frame(height: 8)
                                
                            }
                            
                            ZStack {
                                Rectangle()
                                    
                                    .foregroundColor(Color.white)
                                    .cornerRadius(20)
                                Button {
                                    if pageNum < 3 {
                                        pageNum += 1
                                    } else {
                                    }
                                } label: {
                                    
                                    Text("Next")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 17, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.black)
                                        .cornerRadius(20)
                                        
                                }.padding(.horizontal)
                                
                            }.frame(height: 120)
                            
                                
                        }.ignoresSafeArea()
                    }
                    
                }
            } else {
                if isNotificationView {
                    ZStack {
                        Color.white
                            .ignoresSafeArea()
                        
                        ZStack {
                            VStack {
                                
                                
                                ZStack {
                                    Image("firstScreen522Bg")
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 500)
                                        
                                    Image("notifications522")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 580)
                                    
                                }
                                
                            }
                            
                            VStack {
                                Spacer()
                                
                                ZStack {
                                    Rectangle()
                                        
                                        .foregroundColor(Color.white)
                                        .cornerRadius(20)
                                    Button {
                                        isNotificationView = false
                                        onboardingShowed = true
                                    } label: {
                                        
                                        Text("Next")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 17, weight: .semibold))
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.black)
                                            .cornerRadius(20)
                                            
                                    }.padding(.horizontal)
                                    
                                }.frame(height: 120)
                                
                            }.ignoresSafeArea()
                            VStack {
                                VStack(spacing: 12) {
                                    Text("Don’t miss anything")
                                        .font(.title)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        .multilineTextAlignment(.center)
                                    
                                }.frame(height: 100).padding(.bottom, 10).padding(.horizontal, 30).foregroundColor(.black)
                            }.padding(.bottom, UIScreen.main.bounds.height * 2/2.6)
                        }
                    }
                    
                } else {
                    //WebUIView()
                }
            }
        } else {
           // WebUIView()
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
    
    func rateApp() {
        SKStoreReviewController.requestReview()
    }
}
    

#Preview {
    UsOnboardingUIView()
}
