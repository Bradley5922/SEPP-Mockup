//
//  Carbon Offsetting.swift
//  MockUp
//
//  Created by Bradley Cable on 25/11/2023.
//

import SwiftUI
import LoremSwiftum
import Foundation
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL?

    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true

        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs

        return WKWebView(
            frame: .zero,
            configuration: config)
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let myURL = url else {
            return
        }
        let request = URLRequest(url: myURL)
        uiView.load(request)
    }
}


// Locations
let Locations: [String] =
[
    "Europe",
    "Africa",
    "America's",
    "Asia"
]

// Cost Per KG
let CostPer: [String] =
[
    "0-1",
    "1-5",
    "5-10",
    "10+"
]

// Initiative Type
let InitiativeType: [String] =
[
    "Carbon Capture",
    "Carbon Credit Buybacks",
    "Transport",
    "Food/Composting"
]

struct Carbon_Offsetting: View {
        
    @State private var showDetailSheet: Bool = false
    let carbonCompanys: [String] = ["Carbon Trust", "ClimateCare", "Gold Standard", "Myclimate", "Carbon Clear", "3Degrees", "South Pole", "NativeEnergy", "Terrapass", "Wren"]
    let imageTypes: [String] = ["Powerplants", "food", "underground train", "environment"]
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                ForEach(1..<25) { index in
                    Button {
                        showDetailSheet.toggle()
                    } label: {
                        Event(textTitle: (carbonCompanys.randomElement() ?? "Wren"), textDesc: Lorem.shortTweet, imgURLString: ("https://source.unsplash.com/random/200x200/?" + (imageTypes.randomElement() ?? "environment")))
                    }
                    .buttonStyle(.plain)
                }
                .padding([.leading, .trailing])
                
                Spacer()
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Menu {
                            ForEach(Locations, id: \.self) { place in
                                Button(action: {
                                    // Action for the first option
                                }) {
                                    Text(place)
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "pin")
                                Text("Location of Initiative")
                            }
                        }

                        Menu {
                            ForEach(CostPer, id: \.self) { place in
                                Button(action: {
                                    // Action for the first option
                                }) {
                                    Text(place)
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "dollarsign")
                                Text("Cost Per KG")
                            }
                        }
                        
                        Menu {
                            ForEach(InitiativeType, id: \.self) { place in
                                Button(action: {
                                    // Action for the first option
                                }) {
                                    Text(place)
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "doc.text.magnifyingglass")
                                Text("Focus of Project")
                            }
                        }
                    } label: {
                        HStack {
                            Text("Filter")
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                    }
                }
            }
            
            .navigationTitle("Carbon Offsetting")
            .sheet(isPresented: $showDetailSheet, content: {
                CarbonOffsetSheet()
            })
        }
    }
}

struct CarbonOffsetSheet: View {
    
    @State private var isWebsiteSheetPresented: Bool = false
    
    let subtitle: String = String(
        format: "%@ - %@ - $%@/kg",
        InitiativeType.randomElement() ?? "",
        Locations.randomElement() ?? "",
        CostPer.randomElement() ?? ""
    )

    
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
                    Text(subtitle)
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundStyle(.gray)
                }
                .padding([.leading, .trailing])
                
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
                            isWebsiteSheetPresented.toggle()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8.0)
                                    .foregroundColor(.green)
                                
                                Text("Buy Credits")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .font(.title)
                            }
                            .shadow(radius: 10)
                        }
                        .padding([.leading, .trailing])
                        .frame(height: 65)
                        .padding([.top, .bottom])
                        .background(.ultraThinMaterial)
                        
                        .safeAreaPadding(.bottom)
                        .padding(.bottom, 8)
                        
                        .sheet(isPresented: $isWebsiteSheetPresented) {
                            // WebView content goes here
                            WebView(url: URL(string: "https://www.wren.co"))
                                .ignoresSafeArea()
                        }
                    }
                }
            }
            
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
    
}


#Preview {
    CarbonOffsetSheet()
}

#Preview {
    HotEventsSheet()
}
