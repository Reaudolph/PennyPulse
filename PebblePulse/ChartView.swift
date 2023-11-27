//
//  ChartView.swift
//  PebblePulse
//
//  Created by Hrishikesh Vikram on 11/27/23.
//

import Foundation
import SwiftUI
import Charts

import SwiftUI
import Charts

class ChartViewModel: ObservableObject {
    @Published var dataPoints: [ChartDataPoint] = []
    
    var highestTransaction: ChartDataPoint? {
        dataPoints.max(by: { $0.cost < $1.cost })
    }
    
    var lowestTransaction: ChartDataPoint? {
        dataPoints.min(by: { $0.cost < $1.cost })
    }
    
    var averageCost: Double {
        let totalCost = dataPoints.map { $0.cost }.reduce(0, +)
        return !dataPoints.isEmpty ? totalCost / Double(dataPoints.count) : 0
    }
    
    var averageMood: Double {
        let sumMoods = dataPoints.map { $0.mood }.reduce(0, +)
        return !dataPoints.isEmpty ? Double(sumMoods) / Double(dataPoints.count) : 0
    }
    
    var averageMoodDescription: String {
        switch averageMood {
        case 1..<2.5: return "Negative"
        case 2.5...3.5: return "Neutral"
        case 3.5...4: return "Positive"
        default: return "Undefined"
        }
    }
    
    func moodColor(mood: Int) -> Color {
        switch mood {
        case 1..<2: return .red
        case 2...3: return .orange
        case 3...4: return .green
        default: return .gray
        }
    }
}

// ChartDataPoint.swift
struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let cost: Double
    let mood: Int
}

// ChartView.swift
struct ChartView: View {
    @ObservedObject var viewModel: ChartViewModel
    
    var body: some View {
        VStack {
            if viewModel.dataPoints.isEmpty {
                Text("No data available.")
                    .padding()
            } else {
                Chart {
                    ForEach(viewModel.dataPoints) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Cost", dataPoint.cost)
                        )
                        .foregroundStyle(.green) // Change to your preferred color
                        .interpolationMethod(.catmullRom)
                        .shadow(color: Color.green.opacity(0.3), radius: 8)
                        
                        PointMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Cost", dataPoint.cost)
                        )
                        .foregroundStyle(viewModel.moodColor(mood: dataPoint.mood))
                    }
                }
                .background(Color.clear)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
            }
            
            VStack(alignment: .leading) {
                Text("Overview")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("This is a brief description of your spending and mood over time.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let highest = viewModel.highestTransaction {
                    Text("Highest Costing Transaction: \(highest.cost, specifier: "%.2f") - Mood: ")
                        .foregroundColor(viewModel.moodColor(mood: highest.mood))
                }
                
                if let lowest = viewModel.lowestTransaction {
                    Text("Lowest Costing Transaction: \(lowest.cost, specifier: "%.2f") - Mood: ")
                        .foregroundColor(viewModel.moodColor(mood: lowest.mood))
                }
                
                Text("Average Cost: \(viewModel.averageCost, specifier: "%.2f")")
                Text("Average Mood: \(viewModel.averageMoodDescription)")
                    .padding([.horizontal, .top])
                
                HStack {
                    Button("Resources") {
                        // Action for Resources Button
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button("Chat") {
                        // Action for Chat Button
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.bottom)
            }
        }
    }
    // Define a basic button style
    struct PrimaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .padding()
                .background(configuration.isPressed ? Color.blue.opacity(0.5) : Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .scaleEffect(configuration.isPressed ? 0.95 : 1)
        }
    }
    
}
