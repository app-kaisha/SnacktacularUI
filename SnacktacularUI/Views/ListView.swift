//
//  ListView.swift
//  SnacktacularUI
//
//  Created by app-kaihatsusha on 17/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ListView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var locationManager = LocationManager()
    @State private var sheetIsPresented = false
    @State private var spotDetailIsPresented = false
    @State private var newSpot = Spot() // for passed back to here up binding value
    
    @FirestoreQuery(collectionPath: "spots") var spots: [Spot]
    
    var body: some View {
        NavigationStack {
            List(spots) { spot in
                NavigationLink {
                    SpotDetailView(spot: spot)
                } label: {
                    Text(spot.name)
                        .font(.title2)
                }
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        SpotViewModel.deleteSpot(spot: spot)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Snack Spots:")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("🪵➡️ Log out successful!")
                            dismiss()
                        } catch {
                            print("😡 ERROR: Could not sign out!")
                        }
                        
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
            .sheet(isPresented: $sheetIsPresented) {
                PlaceLookupView(locationManager: locationManager, spot: $newSpot)
                    .onDisappear {
                        // if a place was selected, spot and a name so presetn the detail view
                        if !newSpot.name.isEmpty {
                            spotDetailIsPresented.toggle()
                        } else {
                            // reset the spot if dismissed/Cancelled
                            newSpot = Spot()
                        }
                    }
            }
            .sheet(isPresented: $spotDetailIsPresented) {
                SpotDetailView(spot: newSpot)
                    .onDisappear {
                        // reset the spot if dismissed/Cancelled
                        newSpot = Spot()
                    }
            }
        }
    }
}

#Preview {
    ListView()
}
