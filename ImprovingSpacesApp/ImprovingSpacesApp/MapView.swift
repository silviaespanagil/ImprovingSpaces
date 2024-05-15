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
    
    @State private var position: MapCameraPosition = .userLocation(
            fallback: .camera(
                MapCamera(centerCoordinate: .spain, distance: 1000000)
            )
        )
    
    var body: some View {
        Map(position: $position) {
            Marker("", coordinate: .spain)
        }.ignoresSafeArea(edges: .all)
            .onAppear { 
                locationPermission.requestLocationPermission()
            }
    }
}

#Preview {
    MapView()
}
extension CLLocationCoordinate2D {
    static let spain: Self = .init(
        latitude: 40.4637,
        longitude: -3.7492
    )
}
