//
//  SpotDetailView.swift
//  SnacktacularUI
//
//  Created by app-kaihatsusha on 17/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import MapKit

struct SpotDetailView: View {
    
    @FirestoreQuery(collectionPath: "spots") var fsPhotos: [Photo]
    
    @State var spot: Spot
    
    @State private var photoSheetIsPresented = false
    @State private var showingAlert = false
    @State private var alertMessage = "Cannot add a Photo until you save the Spot."
    
    @Environment(\.dismiss) private var dismiss
    
    private var photos: [Photo] {
        // if preview then show mock data
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return [Photo.preview,Photo.preview,Photo.preview,Photo.preview,Photo.preview,Photo.preview]
        }
        // else show the firbase photos
        return fsPhotos
    }
    
    private let mapDimensions = 750.0
    private var mapCameraPosition: MapCameraPosition {
        let coordinate = CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude)
        
        return .region(
            MKCoordinateRegion(
                center: coordinate,
                latitudinalMeters: mapDimensions,
                longitudinalMeters: mapDimensions
            )
        )
    }
    
    var body: some View {
        VStack {
            Group {
                TextField("name", text: $spot.name)
                    .font(.title)
                    .autocorrectionDisabled()
                TextField("address", text: $spot.address)
                    .font(.title2)
                    .autocorrectionDisabled()
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            Text("Lat: \(spot.latitude) Lon: \(spot.longitude)")
            
            Map(position: .constant(mapCameraPosition)) {
                Marker(spot.name, coordinate: CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude))
                    .tint(.snackColour)
                
                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
            }
            .mapStyle(.standard(pointsOfInterest: .excluding([.aquarium, .conventionCenter, .zoo]), showsTraffic: true))
            .frame(height: 250)
            
            Button {
                if spot.id == nil {
                    showingAlert.toggle()
                } else {
                    photoSheetIsPresented.toggle()
                }
            } label: {
                Image(systemName: "camera.fill")
                Text("Photo")
            }
            .bold()
            .buttonStyle(.borderedProminent)
            .tint(.snackColour)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(photos) { photo in
                        let url = URL(string: photo.imageURLString)
                        
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                            
                        }

                    }
                }
            }
            .frame(height: 80)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .task {
            
            guard let id = spot.id else {
                print("New record - has no id")
                return
            }
            // update firebase query
            $fsPhotos.path = "spots/\(id)/photos"
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveSpot()
                    dismiss()
                }
            }
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                Task {
                    guard let id = await SpotViewModel.saveSpot(spot: spot) else {
                        print("😡ERROR: Saving spot in alert returned nil.")
                        return
                    }
                    spot.id = id
                    print("spot.id \(id)")
                    $fsPhotos.path = "spots/\(id)/photos"
                    photoSheetIsPresented.toggle()
                }
            }
        }
        .fullScreenCover(isPresented: $photoSheetIsPresented) {
            PhotoView(spot: spot)
        }
    }
    
    func saveSpot() {
        Task {
            guard let id = await SpotViewModel.saveSpot(spot: spot) else {
                print("😡 ERROR: Saving spot from Savve button.")
                return
            }
            print("spot.id \(id)")
            print("😎 Nice Spot save!")
        }
        
    }
}

#Preview {
    NavigationStack {
        SpotDetailView(spot: Spot.preview)
    }
}
