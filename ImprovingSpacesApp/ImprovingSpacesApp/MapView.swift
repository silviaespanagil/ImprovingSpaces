//
//  MapView.swift
//  ImprovingSpacesApp
//
//  Created by Silvia España Gil on 15/5/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject private var locationPermission: LocationPermissionManager = LocationPermissionManager()
    
    @State private var userLocation: MapCameraPosition = .userLocation(
        fallback: .camera(
            
            MapCamera(centerCoordinate: .spain, distance: 1000)
        )
    )
    
    @State private var noPermissionLocation: MapCameraPosition = .camera(
        MapCamera(centerCoordinate: .spain, distance: 1000000)
    )
    
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        
        MapReader { proxy in
            
            Map(position: locationPermission.authorizationStatus == .authorizedWhenInUse || locationPermission.authorizationStatus == .authorizedAlways ? $userLocation : $noPermissionLocation) {
                
                if let selection = selectedCoordinate {
                    
                    Marker("", coordinate: selection)
                    
                    MapCircle(center: selection, radius: CLLocationDistance(100))
                        .foregroundStyle(.orange.opacity(0.40))
                        .mapOverlayLevel(level: .aboveLabels)
                }
            }.onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    
                    selectedCoordinate = coordinate
                }
            }}.mapControls {
                MapScaleView()
                MapCompass()
                MapUserLocationButton()
            }
            .ignoresSafeArea(edges: .all)
            .onAppear {
                locationPermission.requestLocationPermission()
            }
    }
}

extension CLLocationCoordinate2D {
    static let spain: Self = .init(
        latitude: 40.4637,
        longitude: -3.7492
    )
}
