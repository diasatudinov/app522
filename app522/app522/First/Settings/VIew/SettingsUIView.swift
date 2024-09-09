//
//  SettingsUIView.swift
//  app522
//
//  Created by Dias Atudinov on 09.09.2024.
//

import SwiftUI

struct SettingsUIView: View {
    @ObservedObject var viewModel: SettingsViewModel
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Settings")
                            .font(.system(size: 34, weight: .bold))
                        
                    }
                    Spacer()
                }
                
                VStack(spacing: 15) {
                    ZStack {
                        Rectangle()
                            .cornerRadius(16)
                        VStack(spacing: 4) {
                            Image(systemName: "square.and.arrow.up.fill")
                            Text("Share app")
                                .bold()
                        }.font(.system(size: 20)).foregroundColor(.white)
                            
                    }.frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .onTapGesture {
                            viewModel.shareApp()
                        }
                    
                    ZStack {
                        Rectangle()
                            .cornerRadius(16)
                        VStack(spacing: 4) {
                            Image(systemName: "star.fill")
                            Text("Rate Us")
                                .bold()
                        }.font(.system(size: 20)).foregroundColor(.white)
                            
                    }.frame(height: 100)
                        .onTapGesture {
                            viewModel.rateApp()
                        }
                    
                    ZStack {
                        Rectangle()
                            .cornerRadius(16)
                        VStack(spacing: 4) {
                            Image(systemName: "doc.text.fill")
                            Text("Usage Policy")
                                .bold()
                        }.font(.system(size: 20)).foregroundColor(.white)
                            
                    }.frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .onTapGesture {
                            viewModel.openUsagePolicy()
                        }
                }
                
                Spacer()
            }.padding(.horizontal)
        }
    }
}

#Preview {
    SettingsUIView(viewModel: SettingsViewModel())
}
