//
//  TabUIView.swift
//  app522
//
//  Created by Dias Atudinov on 06.09.2024.
//

import SwiftUI

struct TabUIView: View {
    @State var selectedTab = 0
    private let tabs = ["Home", "Profile", "Settings"]
    @ObservedObject var budgetVM = BudgetViewModel()
    
    var body: some View {
        ZStack {
            
            switch selectedTab {
            case 0:
                BudgetUIView(viewModel: budgetVM)
            case 1:
                Text("Test")

            case 2:
                Text("Test")
            default:
                Text("default")
            }
                VStack {
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 84)
                            .cornerRadius(40)
                            .shadow(radius: 4)
                            
                        HStack(spacing: 100) {
                            ForEach(0..<tabs.count) { index in
                                Button(action: {
                                    selectedTab = index
                                }) {
                                    
                                    ZStack {
                                        VStack {
                                            Image(systemName: icon(for: index))
                                                .font(.system(size: 20, weight: .semibold))
                                                .padding(.bottom, 2)
                                        }.foregroundColor(selectedTab == index ? Color.main : Color.gray.opacity(0.5))
                                    }
                                }
                                
                            }
                        }.padding(.bottom, 25)
                        
                        
                    }
                    
                }.ignoresSafeArea()
            
        }
    }
    
    private func icon(for index: Int) -> String {
        switch index {
        case 0: return "house.fill"
        case 1: return "scroll.fill"
        case 2: return "gearshape.fill"
        default: return ""
        }
    }
    
    private func text(for index: Int) -> String {
        switch index {
        case 0: return "Home"
        case 1: return "Procedures"
        case 2: return "Settings"
        default: return ""
        }
    }
}

#Preview {
    TabUIView()
}
