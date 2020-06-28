//
//  ContentView.swift
//  Pulse Zones
//
//  Created by temp on 28.06.2020.
//

import SwiftUI

struct GenderAgeView: View {
    
    @Binding var gender: String
    @Binding var age: Double
    
    let genders = ["женский", "мужской", "бинарный", "другой"]
    
    var body: some View {
        Group {
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
        }
        .foregroundColor(Color(UIColor.systemOrange))
    }
}

struct ZonesView: View {
    
    let gender: String
    let age: Double
    let maxPulse: Double
    
    var body: some View {
        Group {
            HStack {
                Image(systemName: "heart")
                Text("Пульсовые зоны".uppercased())
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            
            ForEach(zones) { zone in
                DisclosureGroup("\(zone.name): \(Int(maxPulse * zone.min))" + " – " + "\(Int(maxPulse * zone.max))"
                ) {
                    Text(zone.description)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                .foregroundColor(zone.color)
                .font(.headline)
            }
        }
    }
}

struct NotesView: View {
    var body: some View {
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
}

struct ContentView: View {
    
    @AppStorage("gender")
    var gender = "женский"
    
    @AppStorage("age")
    private var age: Double = 30
    
    ///  Обобщенная формула подсчета МЧСС: 220 минус ваш возраст. Более современная формула: 214-(0.8 x возраст) для мужчин и 209-(0.9 x возраст) для женщин. Но более информативным будет получить значение в лабораторных условиях.
    var maxPulse: Double {
        gender == "мужской"
            ? 214 - (0.80 * age)
            : 209 - (0.90 * age)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                GenderAgeView(gender: $gender, age: $age)
                
                Divider()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        
                        ZonesView(gender: gender, age: age, maxPulse: maxPulse)
                        
                        Divider()
                        
                        NotesView()
                    }
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
            .environment(\.sizeCategory, .large)
    }
}
