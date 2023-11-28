//
//  ContentView.swift
//  MockUp
//
//  Created by Bradley Cable on 19/11/2023.
//

import Charts
import SwiftUI
import LoremSwiftum

struct ContentView: View {
    
    var body: some View {
        TabView {
            Group {
                mainScreen()
                    .tabItem {
                        Label("Dashboard", systemImage: "house.fill")
                    }
                
                Leaderboard()
                    .tabItem {
                        Label("Community", systemImage: "person.3.fill")
                    }
                
                HotEvents()
                    .tabItem {
                        Label("Hot Events", systemImage: "party.popper.fill")
                    }
                
                Carbon_Offsetting()
                    .tabItem {
                        Label("Offsetting", systemImage: "leaf.fill")
                    }
            }
        }
    }
}

struct mainScreen: View {
    
    @State var carbonAddSheetShow: Bool = false
    
    @State var selectedItem: String = "Transport" // relates to pop up sheet
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack (alignment: .leading) {
                        Text("Weekly Carbon")
                            .fontWeight(.bold)
                            .font(.title)
                        
                        ChartView()
                        
                        Divider()
                            .padding([.top, .bottom], 4)
                        
                        Text("Featured Events")
                            .fontWeight(.bold)
                            .font(.title)
                        
                        ForEach(1..<4) { index in
                            Event(textTitle: "Special Event", textDesc: Lorem.shortTweet, imgURLString: "https://source.unsplash.com/random/200x200/?environment")
                        }
                        
                        Spacer()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                .padding([.leading, .trailing])
                .navigationTitle(Text("MyCarbonApp"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // Add your action for the trailing button
                        }) {
                            AsyncImage(url: URL(string: "https://source.unsplash.com/random/200x200/?person"), transaction: Transaction(animation: .easeInOut)) { image in
                                if let uiImage = image.image {
                                    uiImage
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                } else {
                                    Group {
                                        LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.8), Color.blue.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            .frame(width: 40, height: 40)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(action: {
                                // Transport button action
                                selectedItem = "Transport"
                                carbonAddSheetShow.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "car")
                                    Text("Transport")
                                }
                            }

                            Button(action: {
                                // Electricity Consumption button action
                                selectedItem = "Electricity"
                                carbonAddSheetShow.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "bolt")
                                    Text("Electricity Consumption")
                                }
                            }

                            Button(action: {
                                // Food Waste button action
                                selectedItem = "Food Waste"
                                carbonAddSheetShow.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "leaf.arrow.triangle.circlepath")
                                    Text("Food Waste")
                                }
                            }
                        } label: {
                            Image(systemName: "plus")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .background {
                                    Capsule()
                                        .foregroundColor(.blue)
                                        .frame(width: 40, height: 40)
                                }
                        }
                    }
                }

            }
        }
        .sheet(isPresented: $carbonAddSheetShow, content: {
            addCarbon(carbonAddSheetShow: $carbonAddSheetShow, selectedOption: selectedItem)
        })
    }
}

struct Event: View {
    
    var textTitle: String
    var textDesc: String
    var imgURLString: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(textTitle)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(textDesc)
                    .font(.caption)
                    .foregroundColor(Color.secondary)
            }
            .padding(.trailing)
            
            Spacer()
            
            AsyncImage(url: URL(string: imgURLString), transaction: Transaction(animation: .easeInOut)) { image in
                if let Image = image.image {
                    Image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8.0)
                } else {
                    Group {
                        LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.8), Color.blue.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            .cornerRadius(8.0)
                    }
                }
            }
            .shadow(radius: 8)
            .padding(4)
            .frame(width: 100, height: 100)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8.0)
                .foregroundColor(Color(uiColor: .tertiarySystemGroupedBackground))
        )
    }
}

struct HotEvents: View {
    
    @State private var showDetailSheet: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                ForEach(1..<10) { index in
                    Button {
                        showDetailSheet.toggle()
                    } label: {
                        Event(textTitle: "Special Event", textDesc: Lorem.shortTweet, imgURLString: "https://source.unsplash.com/random/200x200/?environment")
                    }
                    .buttonStyle(.plain)
                }
                .padding([.leading, .trailing])
                
                Spacer()
                Spacer()
            }
            .navigationTitle("Hot Events 🔥")
            .sheet(isPresented: $showDetailSheet, content: {
                HotEventsSheet()
            })
        }
    }
}

struct HotEventsSheet: View {
    
    @State var buttonColor: Color = .green
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: "https://source.unsplash.com/random/1600x1025/?environment"), transaction: Transaction(animation: .easeInOut)) { image in
                if let uiImage = image.image {
                    uiImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                } else {
                    Group {
                        LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.8), Color.blue.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    }
                }
            }
            .shadow(radius: 8)
            .frame(height: 250)
            
            Group {
                Group {
                    Text(Lorem.words(2).capitalized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(Lorem.url)
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundStyle(.gray)
                }
                .padding([.leading,.trailing])
                
                Divider()
                
                ZStack {
                    ScrollView(showsIndicators: false) {
                        Text(Lorem.paragraphs(3))
                        
                        Spacer()
                            .padding(.bottom, 140)
                    }
                    .padding([.leading,.trailing])
                    
                    VStack {
                        Spacer()
                        
                        Button {
                            // open third party site
                            // dismiss sheet
                            buttonColor = .gray
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8.0)
                                    .foregroundColor(buttonColor)
                                
                                Text("I'm Interested")
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                                    .font(.title)
                            }
                            .shadow(radius: 10)
                        }
                        .padding([.leading, .trailing])
                        .frame(height: 65)
                        .padding([.top, .bottom])
                        .opacity((buttonColor == .gray) ? 0.5 : 1)
                        .background(.ultraThinMaterial)
                        .disabled((buttonColor == .gray))
                    }
                    .safeAreaPadding(.bottom)
                    .padding(.bottom, 8)
                }
            }
            
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
}



#Preview("Main Screen") {
    ContentView()
}
#Preview("Chars") {
    Group {
        CarbonTypeArea()
        PieChart()
    }
}

#Preview("Detail Sheet") {
       HotEventsSheet()
}
