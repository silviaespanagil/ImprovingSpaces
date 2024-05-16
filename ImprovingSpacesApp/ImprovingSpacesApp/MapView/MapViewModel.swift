//
//  MapViewModel.swift
//  ImprovingSpacesApp
//
//  Created by Silvia España Gil on 16/5/24.
//

import Foundation
import MapKit
import SwiftUI

class MapViewModel: ObservableObject {
    
    @Published var locationPermission: LocationPermissionManager = LocationPermissionManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    
    @Published var mapCameraPosition: MapCameraPosition = .userLocation(
        fallback: .camera(
            MapCamera(centerCoordinate: .spain, distance: 1000)
        )
    )
    
    // MARK: - Update methods
    
    func updateUserLocation(_ location: CLLocationCoordinate2D?) {
        userLocation = location
    }
    
    func updateSelectedCoordinate(_ coordinate: CLLocationCoordinate2D?) {
        selectedCoordinate = coordinate
    }
    
    func updateMapCameraPosition(_ position: MapCameraPosition) {
        mapCameraPosition = position
    }
    
    // MARK: - Location permission methods
    func requestLocationPermission() {
        locationPermission.requestLocationPermission()
    }
}
