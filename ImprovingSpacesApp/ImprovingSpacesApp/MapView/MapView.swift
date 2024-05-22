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
    
    @State private var goToReportView: Bool = false
    
    var body: some View {
        
        ZStack {
            
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
            
            VStack {
                
                Spacer()
                nextButton
            }
        }
        .navigationDestination(isPresented: $goToReportView) { ReportFormView() }
    }
    
    @ViewBuilder
    var nextButton: some View {
        
        VStack {
            
            Spacer()
            HorizontalButton(imageString: "arrow.right", label: "Siguiente") { goToReportView = true }
        }
    }
}

#Preview {
    MapView()
}
