//
//  MapView.swift
//  ImprovingSpacesApp
//
//  Created by Silvia España Gil on 15/5/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        
        MapReader { proxy in
            
            Map(position: $viewModel.mapCameraPosition) {
                if let selection = viewModel.selectedCoordinate {
                    
                    Marker(coordinate: selection) {
                        
                        Image(systemName: "exclamationmark.bubble")
                    }
                    
                    MapCircle(center: selection, radius: CLLocationDistance(100))
                        .foregroundStyle(.orange.opacity(0.40))
                        .mapOverlayLevel(level: .aboveLabels)
                }
            }.navigationBarTitleDisplayMode(.inline)
            .onTapGesture { position in
                
                if let coordinate = proxy.convert(position, from: .local) {
                    
                    viewModel.updateSelectedCoordinate(coordinate)
                }
            }
        }
        .mapControls {
            
            MapScaleView()
            MapCompass()
            MapUserLocationButton()
        }
        .ignoresSafeArea(edges: .all)
        .onAppear {
            viewModel.requestLocationPermission()
        }
    }
}
