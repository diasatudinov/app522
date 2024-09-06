//
//  ContentView.swift
//  app522
//
//  Created by Dias Atudinov on 05.09.2024.
//

import SwiftUI



struct MainIncomeView: View {
    @State private var sheetMode: SheetMode = .half
    @State private var incomes: [Income] = []
    @State private var categories: [Category] = [
        Category(name: "Salary"),
        Category(name: "Freelance"),
        Category(name: "Investments")
    ]
    @State private var selectedCategory: Category?
    @State private var showAddIncomeView = false
    @State private var showAddCategoryView = false

    var filteredIncomes: [Income] {
        if let category = selectedCategory {
            return incomes.filter { $0.category == category }
        } else {
            return incomes
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
            VStack {
                // Фильтр по категориям
                Picker("Filter by Category", selection: $selectedCategory) {
                    Text("All").tag(Category?.none)
                    ForEach(categories) { category in
                        Text(category.name).tag(Category?.some(category))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Список доходов
                List {
                    ForEach(filteredIncomes) { income in
                        HStack {
                            Text(income.name)
                            Spacer()
                            Text("\(income.amount, specifier: "%.2f")")
                            Text(income.category.name)
                        }
                    }
                    .onDelete(perform: removeIncome)
                }
                
                // Кнопки для добавления дохода и категории
                HStack {
                    Button("Add Category") {
                        showAddCategoryView = true
                        //showAddCategoryView.toggle()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("Add Income") {
                        showAddIncomeView.toggle()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                
                
            }
            .navigationTitle("Incomes")
            .sheet(isPresented: $showAddIncomeView) {
                AddIncomeView(viewModel: BudgetViewModel(), selectedTab: Tab.income)
            }
            .sheet(isPresented: $showAddCategoryView) {
                AddCategoryView(categories: $categories)
                
            }
        }
            if showAddCategoryView {
                
                    FlexibleSheet(sheetMode: $sheetMode) {
                        VStack {
                            Text("Hello World!")
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                    }
                
            }
        }
    }

    func removeIncome(at offsets: IndexSet) {
        incomes.remove(atOffsets: offsets)
    }
}
#Preview {
    MainIncomeView()
}
#Preview {
    ContentView()
}


struct AddCategoryView: View {
    @Binding var categories: [Category]
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newCategoryName = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Category Name", text: $newCategoryName)

                Button("Add Category") {
                    let newCategory = Category(name: newCategoryName)
                    categories.append(newCategory)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add Category")
        }
    }
}

struct BottomSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetContent: () -> SheetContent

    func body(content: Content) -> some View {
        ZStack {
            content
        
            if isPresented {
                VStack {
                    Spacer()
                
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    self.isPresented = false
                                }
                            }) {
                                Text("done")
                                    .padding(.top, 5)
                            }
                        }
                    
                        sheetContent()
                    }
                    .padding()
                }
                .zIndex(.infinity)
                .transition(.move(edge: .bottom))
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

extension View {
    func customBottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        sheetContent: @escaping () -> SheetContent
    ) -> some View {
        self.modifier(BottomSheet(isPresented: isPresented, sheetContent: sheetContent))
    }
}


struct ContentView: View {
    
    @State private var sheetMode: SheetMode = .none
    
    var body: some View {
        ZStack {
            FlexibleSheet(sheetMode: $sheetMode) {
                VStack {
                    Text("Hello World!")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.green)
                .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
            }
            
            Button("Show") {
                
                switch sheetMode {
                    case .none:
                        sheetMode = .quarter
                    case .quarter:
                        sheetMode = .half
                    case .half:
                        sheetMode = .full
                    case .full:
                        sheetMode = .none
                        
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


enum SheetMode {
    case none
    case quarter
    case half
    case full
}

struct FlexibleSheet<Content: View>: View {
    
    let content: () -> Content
    var sheetMode: Binding<SheetMode>
    
    init(sheetMode: Binding<SheetMode>, @ViewBuilder content: @escaping () -> Content) {
        
        self.content = content
        self.sheetMode = sheetMode
        
    }
    
    private func calculateOffset() -> CGFloat {
        
        switch sheetMode.wrappedValue {
            case .none:
                return UIScreen.main.bounds.height
            case .quarter:
                return UIScreen.main.bounds.height - 200
            case .half:
                return UIScreen.main.bounds.height/2
            case .full:
                return 0
        }
        
    }
    
    var body: some View {
        content()
            .offset(y: calculateOffset())
            .animation(.spring())
            .edgesIgnoringSafeArea(.all)
    }
}

struct FlexibleSheet_Previews: PreviewProvider {
    static var previews: some View {
        FlexibleSheet(sheetMode: .constant(.none)) {
            VStack {
                Text("Hello World")
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
        }
    }
}
