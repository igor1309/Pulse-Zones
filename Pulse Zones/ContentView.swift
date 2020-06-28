//
//  ContentView.swift
//  Pulse Zones
//
//  Created by temp on 28.06.2020.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("gender")
    var gender = "женский"
    
    @AppStorage("age")
    private var age: Double = 30
    
    var maxPulse: Double {
        gender == "мужской"
            ? 214 - (0.80 * age)
            : 209 - (0.90 * age)
    }
    
    var genders = ["женский", "мужской", "бинарный", "другой"]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Пол")
                    
                    Picker("Пол", selection: $gender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender).tag(0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                HStack {
                    Text("Возраст \(Int(age))")
                    
                    Slider(value: $age, in: 15.0...100.0)
                }
                
                Divider()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "heart")
                            Text("Пульсовые зоны".uppercased())
                        }
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        
                        ForEach(zones) { zone in
                            DisclosureGroup("\(zone.name): \(Int(maxPulse * zone.min))" + " – " + "\(Int(maxPulse * zone.max))") {
                                Text(zone.description)
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                            .foregroundColor(zone.color)
                            .font(.headline)
                        }
                        
                        Divider()
                        
                        Group {
                            HStack {
                                Image(systemName: "text.justify")
                                Text("Примечания".uppercased())
                            }
                            
                            ForEach(zoneTerms.indices, id: \.self) { index in
                                DisclosureGroup(zoneTerms[index].key) {
                                    Text(zoneTerms[index].value)
                                        .font(.footnote)
                                }
                            }
                        }
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("МЧСС = \(Int(maxPulse))")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
