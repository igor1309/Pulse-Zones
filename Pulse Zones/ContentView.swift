//
//  ContentView.swift
//  Pulse Zones
//
//  Created by Igor Malyarov on 28.06.2020.
//

import SwiftUI

enum Gender: String, CaseIterable {
    case female = "женский"
    case male = "мужской"
    case binary = "бинарный"
    case other = "другой"
}

struct GenderAgeView: View {
    
    @Binding var gender: Gender
    @Binding var age: Double
    
    var body: some View {
        Group {
            HStack {
                Text("Пол")
                
                Picker("Пол", selection: $gender) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue).tag(0)
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
    
    let maxPulse: Double
    
    var body: some View {
        Group {
            Label("Пульсовые зоны".uppercased(), systemImage: "heart")
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
            Label("Примечания".uppercased(), systemImage: "text.justify")
            
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
    private var gender = Gender.female
    
    @AppStorage("age")
    private var age: Double = 30
    
    ///  Обобщенная формула подсчета МЧСС: 220 минус ваш возраст. Более современная формула: 214-(0.8 x возраст) для мужчин и 209-(0.9 x возраст) для женщин. Но более информативным будет получить значение в лабораторных условиях.
    var maxPulse: Double {
        gender == Gender.male
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
                        
                        ZonesView(maxPulse: maxPulse)
                        
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
