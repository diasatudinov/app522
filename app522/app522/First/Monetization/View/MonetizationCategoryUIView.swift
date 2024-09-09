//
//  MonetizationCategoryUIView.swift
//  app522
//
//  Created by Dias Atudinov on 09.09.2024.
//

import SwiftUI

struct MonetizationCategoryUIView: View {
    @ObservedObject var viewModel: MonetizationViewModel
    @State private var name = ""
    @State private var showAlert = false
    @Binding var openSheet: Bool
    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                Text("Category")
                    .font(.system(size: 22, weight: .bold))
               
                VStack(alignment: .leading) {
                    
                    ForEach(viewModel.categories, id: \.self) { category in
                        if category.name != "All" {
                            HStack {
                                HStack {
                                    Text(category.name)
                                        .font(.system(size: 16))
                                    Image(systemName: "trash")
                                }
                                .padding(10)
                                .padding(.horizontal, 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.main, lineWidth: 2)
                                )
                                .padding(2)
                                .onTapGesture {
                                    showAlert = true
                                }
                                Spacer()
                                
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Delete a category?"),
                                    message: Text(""),
                                    primaryButton: .destructive(Text("Delete")) {
                                        viewModel.deleteCategory(for: category)
                                    },
                                    secondaryButton: .cancel(Text("Close"))
                                )
                            }
                        }
                    }
                }
                
                TextField("Name", text: $name)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                
                HStack {
                    Button("Cancel") {
                        openSheet = false
                    }
                    .foregroundColor(.black)
                    .padding()
                    .padding(.horizontal, 38)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.main, lineWidth: 2))
                    
                    Button("Save") {
                        if !name.isEmpty {
                            let category = Category(name: name)
                            viewModel.addCategory(category)
                            openSheet = false
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal, 45)
                    .background(Color.main.opacity(name.isEmpty ? 0.5 : 1))
                    .cornerRadius(20)
                }
            }.padding().padding(.vertical, 6)
                
        }.background(Color.white).cornerRadius(20).padding(.horizontal)
    }
}


#Preview {
    MonetizationCategoryUIView(viewModel: MonetizationViewModel(), openSheet: .constant(true))
}
