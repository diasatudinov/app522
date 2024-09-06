//
//  ReOnboardingUIView.swift
//  app522
//
//  Created by Dias Atudinov on 05.09.2024.
//

import SwiftUI

struct ReOnboardingUIView: View {
    @State private var pageNum: Int = 1
    @State private var showSheet = false
    @AppStorage("signedUP") var signedUP: Bool = false
    
    var body: some View {
        if !signedUP {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.green, Color.yellow]),
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                VStack(spacing: 0) {
                    Spacer()
                    switch pageNum {
                    case 1: Image("app522Screen1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 540)
                            
                    case 2: Image("app522Screen2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 540)
                    default:
                        Image("appScreen3")
                            .resizable()
                            .frame(height: 549)
                            .ignoresSafeArea()
                    }
                    
                    Spacer()
                    
                    
                }
                VStack {
                    
                    switch pageNum {
                    case 1:
                        VStack(spacing: 12) {
                            Text("Manage your personal \nfinances")
                                .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .multilineTextAlignment(.center)
                            
                        }.frame(height: 100).padding(.bottom, 10).padding(.horizontal, 30).foregroundColor(.white)
                    case 2:
                        VStack(spacing: 12) {
                            Text("Plan your spending in one \napp")
                                .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .multilineTextAlignment(.center)
                        }.frame(height: 100).padding(.bottom, 10).foregroundColor(.white)
                    case 3:
                        VStack(spacing: 12) {
                            Text("Discounts")
                                .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .multilineTextAlignment(.center)
                            Text("Create discounts for your customers in our app so you don't lose out")
                                .font(.system(size: 16, weight: .semibold))
                                .multilineTextAlignment(.center)
                        }.frame(height: 100).padding(.bottom, 10).padding(.horizontal, 30).foregroundColor(.white)
                    default:
                        Text("Save information about \nyour favorite routes")
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .frame(height: 70)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                        
                    }
                    
                }.padding(.bottom, UIScreen.main.bounds.height * 2/2.8)
                
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
                            if pageNum < 2 {
                                pageNum += 1
                            } else {
                                signedUP = true
                            }
                        } label: {
                            
                            Text("Next")
                                .foregroundColor(Color.white)
                                .font(.system(size: 22, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(20)
                                
                        }.padding(.horizontal)
                        
                    }.frame(height: 120)
                        
                }.ignoresSafeArea()
            }
        
            
        } else {
            TabUIView()
        }
    }
}


#Preview {
    ReOnboardingUIView()
}
