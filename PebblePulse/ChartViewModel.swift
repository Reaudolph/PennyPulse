//
//  ChartViewModel.swift
//  PebblePulse
//
//  Created by Hrishikesh Vikram on 11/27/23.
//

import Foundation
import Charts
import Combine



class ChartViewModel: ObservableObject {
    @Published var dataPoints: [ChartDataPoint] = []
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let x: Date    // Assuming timeHappened is a Date
    let y: Double  // Assuming value is a Double
}
