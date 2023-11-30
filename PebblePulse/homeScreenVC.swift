//
//  homeScreenVC.swift
//  PebblePulse
//
//  Created by Hrishikesh Vikram on 11/20/23.
//

import UIKit
import UIKit
import SwiftUI
import Charts
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import Foundation


class homeScreenVC: UIViewController {
    
    let chartViewModel = ChartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setupChartView()
        fetchLastTransactions()
    }
    
    private func setupChartView() {
        let chartView = ChartView(viewModel: chartViewModel)
        let hostingController = UIHostingController(rootView: chartView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        let bottomMargin: CGFloat = 100  // Adjust this value to leave the desired space at the bottom
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomMargin) // Adjusted bottom constraint
        ])
    }

    private func fetchLastTransactions() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user ID found.")
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("transactions")
            .order(by: "timeHappened", descending: true)
            .limit(to: 50)
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("Error getting transactions: \(error.localizedDescription)")
                    return
                }
                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    print("No documents or empty data")
                    return
                }
                
                var dataPoints: [ChartDataPoint] = []
                for document in documents {
                    let data = document.data()
                    if let cost = data["cost"] as? Double,
                       let mood = data["mood"] as? Int, // Make sure to fetch the mood from the document
                       let timestamp = data["timeHappened"] as? Timestamp {
                        let date = timestamp.dateValue()
                        let dataPoint = ChartDataPoint(date: date, cost: cost, mood: mood)
                        dataPoints.append(dataPoint)
                    } else {
                        print("Error parsing document data: \(data)")
                    }
                }
                print("Fetched \(dataPoints.count) data points.")
                DispatchQueue.main.async {
                    self?.chartViewModel.dataPoints = dataPoints
                }
            }
    }

}
