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
        default: return .red
        }
    }
}

// ChartDataPoint.swift
struct ChartDataPoint: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let cost: Double
    let mood: Int
    
    static func == (lhs: ChartDataPoint, rhs: ChartDataPoint) -> Bool {
        return lhs.id == rhs.id
    }
}


struct ChartView: View {
    @ObservedObject var viewModel: ChartViewModel
    
    var body: some View {
        ZStack {
            Color.white // Set the background color of the chart to white
                .edgesIgnoringSafeArea(.all)
            VStack {
                if viewModel.dataPoints.isEmpty {
                    Text("No data available.")
                        .foregroundColor(.white)
                        .padding()
                } else {
                    Chart {
                        ForEach(viewModel.dataPoints) { dataPoint in
                            LineMark(
                                x: .value("Date", dataPoint.date),
                                y: .value("Cost", dataPoint.cost)
                            )
                            .foregroundStyle(.green)
                            .interpolationMethod(.catmullRom)
                            .shadow(color: .green.opacity(0.3), radius: 8)
                            
                            PointMark(
                                x: .value("Date", dataPoint.date),
                                y: .value("Cost", dataPoint.cost)
                            )
                            .foregroundStyle(viewModel.moodColor(mood: dataPoint.mood))
                        }
                    }
                    .frame(height: 400)
                    
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Spacer(minLength: 5)
                    Text("Overview")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.bottom, 5) // Add bottom padding
                        .padding(.horizontal) // Add horizontal padding
                    
                    Text("This is a brief description of your spending and mood over time.")
                        .font(.body)
                        .foregroundColor(.black)
                        .padding(.horizontal) // Add horizontal padding
                    
                    Text("Statistics")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.top, 5)
                        .padding(.horizontal) // Add horizontal padding
                    
                    // Use white foreground color for green text
                    StatisticsView(label: "Highest Costing Transaction:", value: viewModel.highestTransaction?.cost)
                        .foregroundColor(.black)
                        .padding(.horizontal) // Add horizontal padding
                    StatisticsView(label: "Lowest Costing Transaction:", value: String(format: "%.2f", viewModel.lowestTransaction?.cost ?? 0.0))
                        .foregroundColor(.black)
                        .padding(.horizontal) // Add horizontal padding
                    StatisticsView(label: "Average Cost:", value: String(format: "%.2f", viewModel.averageCost))
                        .foregroundColor(.black)
                        .padding(.horizontal) // Add horizontal padding
                    StatisticsView(label: "Average Mood:", value: viewModel.averageMoodDescription)
                        .foregroundColor(.black)
                        .padding(.horizontal) // Add horizontal padding
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 0)
                    .fill(Color.pennyGreen) // Set the background color of the overview stats box to green
                    .opacity(1)) // Set the opacity as needed
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}
struct CustomTabBar: View {
    enum Tab {
        case home
        case chat
        case resources
    }
    
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    self.selectedTab = .home
                }) {
                    VStack {
                        Image(systemName: "house.fill")
                            .font(.title2)
                        Text("Home")
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == .home ? .purple : .gray)
                }
                
                Spacer()
                
                Button(action: {
                    self.selectedTab = .chat
                }) {
                    VStack {
                        Image(systemName: "message.fill")
                            .font(.title2)
                        Text("Chat")
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == .chat ? .purple : .gray)
                }
                
                Spacer()
                
                Button(action: {
                    self.selectedTab = .resources
                }) {
                    VStack {
                        Image(systemName: "book.fill")
                            .font(.title2)
                        Text("Resources")
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == .resources ? .purple : .gray)
                }
            }
            .padding(.horizontal, 50)
            .padding(.vertical, 5)
            .background(Color.white.opacity(0.2))
            .clipShape(Capsule())
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            Color.clear.frame(height: 5)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}





struct StatisticsView: View {
    var label: String
    var value: CustomStringConvertible?
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.black)
            Spacer()
            Text(value?.description ?? "N/A")
                .foregroundColor(.black)
                .bold()
        }
    }
}

