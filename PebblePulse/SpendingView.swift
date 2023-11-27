//
//  SpendingView.swift
//  PebblePulse
//
//  Created by Hrishikesh Vikram on 11/27/23.
//

import Foundation
import SwiftUI

struct SpendingView: View {
    var body: some View {
        Text("Spending Screen Content")
            .navigationBarTitle("Spending", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action for the plus button
                        print("Plus button tapped")
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
    }
}
