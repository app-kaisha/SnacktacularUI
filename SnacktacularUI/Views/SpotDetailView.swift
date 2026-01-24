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
    
    enum ButtonPressed {
        case review, photo
    }
    
    @FirestoreQuery(collectionPath: "spots") var fsPhotos: [Photo]
    @FirestoreQuery(collectionPath: "spots") var fsReviews: [Review]
    
    @State var spot: Spot
    
    @State private var photoSheetIsPresented = false
    @State private var reviewSheetIsPresented = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @State private var reviewToggle = false
    @State private var photoToggle = false
    
    @State private var showingAsSheet = false
    @State private var buttonPressed = ButtonPressed.review
    
    @Environment(\.dismiss) private var dismiss
    
    private var photos: [Photo] {
        // if preview then show mock data
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return [Photo.preview,Photo.preview,Photo.preview,Photo.preview,Photo.preview,Photo.preview]
        }
        // else show the firbase photos
        return fsPhotos
    }
    
    private var reviews: [Review] {
        // if preview then show mock data
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return [Review.preview, Review.preview, Review.preview]
        }
        // else show the firbase reviews
        return fsReviews
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
    
    private var avgRating: String {
        
        guard reviews.count != 0 else {
            return "-.-"
        }
        
        let averageValue = Double(reviews.reduce(0) { $0 + $1.rating }) / Double(reviews.count)
        
        return String(format: "%.1f", averageValue)
    }
    
    var body: some View {
        VStack {
            Group {
                TextField("name", text: $spot.name)
                    .font(.title)
                    .disabled(spot.id != nil)
                    .autocorrectionDisabled()
                TextField("address", text: $spot.address)
                    .font(.title2)
                    .disabled(spot.id != nil)
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
            
            HStack {
                Group {
                    Text("Avg Rating")
                        .font(.title2).bold()
                    Text(avgRating)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundStyle(.snackColour)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                Spacer()
                
                Group {
                    Button {
                        buttonPressed = .photo
                        if spot.id == nil {
                            photoToggle.toggle()
                            alertMessage = "Cannot add a Photo until you save the Spot."
                            showingAlert.toggle()
                        } else {
                            photoSheetIsPresented.toggle()
                        }
                    } label: {
                        Image(systemName: "camera.fill")
                        Text("Photo")
                    }
                    
                    Button {
                        buttonPressed = .review
                        if spot.id == nil {
                            reviewToggle.toggle()
                            alertMessage = "Cannot add a Review until you save the Spot."
                            showingAlert.toggle()
                        } else {
                            reviewSheetIsPresented.toggle()
                        }
                    } label: {
                        Image(systemName: "star.fill")
                        Text("Rate")
                    }
                }
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .buttonStyle(.borderedProminent)
                .tint(.snackColour)
            }
            .padding(.horizontal)
            
            List {
                Section {
                    ForEach(reviews) { review in
                        NavigationLink {
                            ReviewView(spot: spot, review: review)
                        } label: {
                            SpotReviewRowView(review: review)
                        }
                    }
                }
                
            }
            .listStyle(.plain)
            .frame(height: 210)
            
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
            .padding(.bottom, 20)
            .padding(.leading, 10)
            Spacer()
        }
        .padding(.top, 50)
        .navigationBarBackButtonHidden()
        .onAppear {
            if (spot.id == nil) {
                showingAsSheet = true
            } else {
                showingAsSheet = false
            }
        }
        .task {
            
            guard let id = spot.id else {
                print("New record - has no id")
                return
            }
            // update firebase query
            $fsPhotos.path = "spots/\(id)/photos"
            $fsReviews.path = "spots/\(id)/reviews"
        }
        .toolbar {
            if showingAsSheet && spot.id == nil {
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
            } else {
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        dismiss()
                    }
                    
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
                    
                    switch buttonPressed {
                    case .review:
                        reviewToggle.toggle()
                        $fsReviews.path = "spots/\(id)/reviews"
                        reviewSheetIsPresented.toggle()
                        showingAsSheet = false
                    case .photo:
                        photoToggle.toggle()
                        $fsPhotos.path = "spots/\(id)/photos"
                        photoSheetIsPresented.toggle()
                        showingAsSheet = false
                    }
                    
                }
            }
        }
        .fullScreenCover(isPresented: $photoSheetIsPresented) {
            PhotoView(spot: spot)
        }
        .fullScreenCover(isPresented: $reviewSheetIsPresented) {
            ReviewView(spot: spot, review: Review())
        }
    }
    
    func saveSpot() {
        Task {
            guard let id = await SpotViewModel.saveSpot(spot: spot) else {
                print("😡 ERROR: Saving spot from Save button.")
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
