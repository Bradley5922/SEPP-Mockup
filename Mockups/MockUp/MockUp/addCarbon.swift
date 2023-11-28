//
//  addCarbon.swift
//  MockUp
//
//  Created by Bradley Cable on 20/11/2023.
//

import SwiftUI

struct addCarbon: View {
    
    @Binding var carbonAddSheetShow: Bool
    
    @State var selectedOption: String = "Transport"
    
    @State private var text: String = ""
    
    let options = ["Transport", "Electricity", "Food Waste"]
    let units = ["Miles", "KWh", "KG"]
    
    private enum Field: Int, Hashable { case carbonInput }
    
    @FocusState private var focusFeild: Field?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Picker("", selection: $selectedOption) {
                    ForEach(options, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                
                Divider()
                
                HStack {
                    
                    TextField("Update your carbon here...", text: $text)
                        .textFieldStyle(.plain)
                        .focused($focusFeild, equals: .carbonInput)
                    
                    Text(units[options.lastIndex(of: selectedOption) ?? 0])
                        .fontWeight(.semibold)
                }
                .keyboardType(.decimalPad)
                
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8.0)
                        .foregroundColor(Color(uiColor: .tertiarySystemGroupedBackground))
                )
                
                Text(
                """
                \n**Data Calculation Proces:**\n
                **Travel Emissions**: Calculated based on the an average carbon output via useage of public transport, multiplied by distance inputed.\n
                **Electricity Emissions**: Derived from the user's electricity consumption (via smart meter/manual input), considering the energy mix of their region to provide precise carbon estimates.\n
                **Food Waste Emissions**: Evaluated by considering the quantity of wasted food, emission factors use an average for all foods.\n
                """
                )
                
                Spacer()
                
                Button {
                    // add data to database
                    // dismiss sheet
                    print("Selected Option: \(selectedOption)")
                    carbonAddSheetShow.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8.0)
                            .foregroundColor(.green)
                        
                        Text("Add Data")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .font(.title)
                    }
                    .shadow(radius: 10)
                }
                .frame(height: 65)
            }
            .navigationTitle("Add Carbon")
            .padding()
            
            .onAppear() {
                focusFeild = .carbonInput
//                selectedOption = selectedOptionArg
            }
        }
    }
}

//#Preview {
//    addCarbon(carbonAddSheetShow: <#Binding<Bool?>#>)
//}
