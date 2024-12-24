//
//  Price.swift
//  WiiEvent
//
//  Created by Wiipuri Developer on 26.09.2024.
//


import SwiftUI


struct PriceView: View {
    let event: Event
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    
                    Section("Общая стоимость") {
                        if let price = event.price {
                            LabeledContent("Общая стоимость (руб.)", value: price, format: .number)
                        }
                    }
                     
                    Section("По годам") {
                        if let limit2020 = event.limit2020 {
                            LabeledContent("2020 (руб.)", value: limit2020, format: .number)
                        }
                        
                        if let limit2021 = event.limit2021 {
                            LabeledContent("2021 (руб.)", value: limit2021, format: .number)
                        }
                        
                        if let limit2022 = event.limit2022 {
                            LabeledContent("2022 (руб.)", value: limit2022, format: .number)
                        }
                        
                        if let limit2023 = event.limit2023 {
                            LabeledContent("2023 (руб.)", value: limit2023, format: .number)
                        }
                        
                        if let limit2024 = event.limit2024 {
                            LabeledContent("2024 (руб.)", value: limit2024, format: .number)
                        }
                        
                        if let limit2025 = event.limit2025 {
                            LabeledContent("2025 (руб.)", value: limit2025, format: .number)
                        }
                        
                        if let limit2026 = event.limit2026 {
                            LabeledContent("2026 (руб.)", value: limit2026, format: .number)
                        }
                        
                        if let limit2027 = event.limit2027 {
                            LabeledContent("2027 (руб.)", value: limit2027, format: .number)
                        }
                        
                        if let limit2028 = event.limit2028 {
                            LabeledContent("2028 (руб.)", value: limit2028, format: .number)
                        }
                        
                        if let limit2029 = event.limit2029 {
                            LabeledContent("2029 (руб.)", value: limit2029, format: .number)
                        }
                        
                        if let limit2030 = event.limit2030 {
                            LabeledContent("2030 (руб.)", value: limit2030, format: .number)
                        }
                    }
                    
                }
            }
        }
    }
}

#Preview {
    PriceView(event: Event.example)
}
