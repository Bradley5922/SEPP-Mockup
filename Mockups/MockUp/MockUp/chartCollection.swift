//
//  chartCollection.swift
//  MockUp
//
//  Created by Bradley Cable on 22/11/2023.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    // Average carbon UK per day: 27.397kg
    // "https://www.carbonindependent.org/23.html"
    
    let weekdays: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    let data: [Int] = (0..<8).map { _ in
        return Int.random(in: 20...30)
    }
    
    var foregroundColor: Color = .green
    
    var body: some View {
        Chart {
            ForEach(0..<weekdays.count, id: \.self) { index in
                BarMark(
                    x: .value("Weekday", weekdays[index]),
                    y: .value("Carbon KG/£", Double(data[index]))
                )
                
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
            }
        }
        .padding([.leading, .trailing])
        .frame(height: 200)
        .padding()
        .padding([.top])
        
        .background(
            RoundedRectangle(cornerRadius: 8.0)
                .foregroundColor(Color(uiColor: .tertiarySystemGroupedBackground))
        )
    }
}

struct PieChart: View {
    
    @State private var arrayData: [Int] = []
    
    var body: some View {
        if arrayData != [] {
            Chart {
                SectorMark(angle: .value("Transport", arrayData[0]),
                           innerRadius: .ratio(0.5),
                           angularInset: 1.5)
                .cornerRadius(5)
                .foregroundStyle(.blue)
                .foregroundStyle(by: .value("Product category", "Transport"))
                
                SectorMark(angle: .value("Electricity", arrayData[1]),
                           innerRadius: .ratio(0.5),
                           angularInset: 1.5)
                .cornerRadius(5)
                .foregroundStyle(.red)
                .foregroundStyle(by: .value("Product category", "Electricity"))
                
                SectorMark(angle: .value("Food Waste", arrayData[2]),
                           innerRadius: .ratio(0.5),
                           angularInset: 1.5)
                .cornerRadius(5)
                .foregroundStyle(.orange)
                .foregroundStyle(by: .value("Product category", "Food Waste"))
            }
            .frame(height: 275)
            .chartLegend(position: .bottom, alignment: .center, spacing: 25)
        } else {
            ProgressView()
                .onAppear() {
                    arrayData = generateIntArrayWithSum(targetSum: 100, count: 3)
                }
        }
    }
        
    func generateIntArrayWithSum(targetSum: Int, count: Int) -> [Int] {
        var array: [Int] = []

        for _ in 0..<(count - 1) {
            let upperBound = max(1, targetSum - array.reduce(0, +))
            let randomValue = Int.random(in: 1...upperBound)
            array.append(randomValue)
        }

        array.append(targetSum - array.reduce(0, +))

        return array.shuffled()
    }
}

struct CarbonTypeArea: View {
    
    @State private var graphData: [areaGraphDataStruct]?
    
    @State var forgroundColor: Color = .blue
    
    @State var selectedOption: Int = 0
    
    let options = ["Transport", "Electricity", "Food Waste"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Weekly Carbon By Type")
                .font(.title3)
                .fontWeight(.semibold)
            
            if let data = graphData {
                Chart {
                    ForEach(data, id: \.self) { datum in
                        getPlottableValue(valueType: selectedOption, datum: datum, type: "PointMark").0
                            .symbol(.square)
                            .foregroundStyle(.secondary)
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(.gray)
                        
                        getPlottableValue(valueType: selectedOption, datum: datum, type: "AreaMark").1
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(
                                Gradient(
                                    colors: [forgroundColor.opacity(0.9),
                                             forgroundColor.opacity(0.5),
                                             forgroundColor.opacity(0.25),
                                             forgroundColor.opacity(0)]
                                )
                            )
                    }
                }
                .padding()
                .frame(height: 275)
                
                .chartYScale(domain: 0...100)
            } else {
                ProgressView()
                    .onAppear() {
                        graphData = collateData(dates: getPreviousDates(backdate: 7))
                    }
            }
            
            Picker("", selection: $selectedOption) {
                Text("Transport").tag(0)
                Text("Electricity").tag(1)
                Text("Food Waste").tag(2)
            }
            .pickerStyle(.segmented)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8.0)
                .foregroundColor(Color(uiColor: .tertiarySystemGroupedBackground))
        )
        .onChange(of: selectedOption) {
            switch selectedOption {
            case 0: forgroundColor = .blue
            case 1: forgroundColor = .red
            case 2: forgroundColor = .orange
            default: forgroundColor = .clear
            }
        }
    }
    
    func getPlottableValue(valueType: Int, datum: areaGraphDataStruct, type: String) -> (PointMark?, AreaMark?) {
        
        let x: PlottableValue = .value("Date", datum.date)
        let y: PlottableValue<Double>
        
        switch valueType {
        case 0:
            y = .value("Carbon", Double(datum.percentTransport))
        case 1:
            y = .value("Carbon", Double(datum.percentElec))
        case 2:
            y = .value("Carbon", Double(datum.percentFood))
        default:
            y = .value("Carbon", 0)
        }
        
        if type == "PointMark" {
            return (PointMark(x: x, y: y), nil)
        } else {
            return (nil, AreaMark(x: x, y: y))
        }
    }
}

struct areaGraphDataStruct: Hashable {
    var date: String
    var percentTransport: Int
    var percentFood: Int
    var percentElec: Int
}

func getPreviousDates(backdate: Int) -> [String] {
    let currentDate = Date()

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM"
    
    var previousDays: [String] = []

    // Generate dates for the previous 7 days
    for i in 0..<backdate {
        if let previousDate = Calendar.current.date(byAdding: .day, value: -i, to: currentDate) {
            let dateString = dateFormatter.string(from: previousDate)
            previousDays.append(dateString)
        }
    }
    
    return previousDays
}

func collateData(dates: [String]) -> [areaGraphDataStruct] {
    print("yeay")
    var allData: [areaGraphDataStruct] = []
    
    for i in 0..<dates.count {
        var temp: areaGraphDataStruct =
        areaGraphDataStruct(date: dates[i],
                            percentTransport: Int.random(in: 1...100),
                            percentFood: Int.random(in: 1...100),
                            percentElec: Int.random(in: 1...100))
        
        allData.append(temp)
    }
    
    return allData
}
