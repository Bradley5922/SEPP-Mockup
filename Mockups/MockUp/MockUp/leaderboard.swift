//
//  leaderboard.swift
//  MockUp
//
//  Created by Bradley Cable on 22/11/2023.
//

import SwiftUI
import LoremSwiftum

struct Leaderboard: View {
    
    @State var selectedOption: Int = 0
    @State var refresh: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView() {
                
                Picker("", selection: $selectedOption) {
                    Text("Local Area").tag(0)
                    Text("Friends").tag(1)
                }
                .pickerStyle(.segmented)
                
                PieChart()
                    .padding([.top], 25)
                
                Divider()
                    .padding([.top, .bottom], 4)
                
                CarbonTypeArea()
                
                Divider()
                    .padding([.top, .bottom], 4)
                
                ChartView()
                
                if selectedOption == 1 {
                    
                    Divider()
                        .padding([.top, .bottom], 4)
                    
                    Group {
                        VStack {
                            HStack {
                                Text("Friends List")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Image(systemName: "plus")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .background {
                                        Capsule()
                                            .foregroundColor(.blue)
                                            .frame(width: 25, height: 25)
                                    }
                                    .padding([.trailing], 6)
                            }
                            
                            ForEach(6..<12) {_ in
                                Event(textTitle: Lorem.fullName, textDesc: "Friend Code: \(UUID().uuidString.prefix(13))", imgURLString: "https://source.unsplash.com/random/200x200/?person")
                            }
                        }
                    }
                }
                
                Spacer()
                Spacer()
                Spacer()
            }
            .padding([.leading, .trailing])
            .navigationTitle("Leaderboard 🏅")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            // for show only
                        }) {
                            HStack {
                                Image(systemName: "calendar.day.timeline.left")
                                Text("Last 7 Days")
                            }
                        }

                        Button(action: {
                            // for show only
                        }) {
                            HStack {
                                Image(systemName: "clock.arrow.2.circlepath")
                                Text("Last 30 Days")
                            }
                        }
                        
                        Button(action: {
                            // for show only
                        }) {
                            HStack {
                                Image(systemName: "timelapse")
                                Text("Lifetime")
                            }
                        }

                    } label: {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

#Preview("Leaderboard") {
       Leaderboard()
}
