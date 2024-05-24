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
    @State private var showAddressSugestions: Bool = false
    
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
                
                searchField
                Spacer()
                nextButton
            }
        }
        .navigationDestination(isPresented: $goToReportView) { ReportFormView() }
        .sheet(isPresented: $showAddressSugestions) {
            addressSuggestions
        }
    }
    
    @ViewBuilder
    var nextButton: some View {
        
        VStack {
            
            Spacer()
            HorizontalButton(imageString: "arrow.right", label: "Siguiente") { goToReportView = true }
        }
    }
    
    @ViewBuilder
    var searchField: some View {
        
        VStack {
            
            TextField("Busca la dirección a reportar", text: $viewModel.address)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 80)
                .onChange(of: viewModel.address) {
                    viewModel.updateSearchQuery(viewModel.address)
                    showAddressSugestions = true
                }
            
        }.padding()
        
    }
    
    @ViewBuilder
    var addressSuggestions: some View {
        
        VStack {
            
            List(viewModel.searchResults, id: \.self) { result in
                
                Button(action: {
                    viewModel.search(result)
                    showAddressSugestions = false
                }) {
                    VStack(alignment: .leading) {
                        Text(result.title)
                            .font(.body)
                            .foregroundColor(.primary)
                        Text(result.subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }.listStyle(.plain)
                .presentationDetents([.fraction(0.25), .fraction(0.50)])
                .interactiveDismissDisabled()
                .presentationBackgroundInteraction(
                    .enabled
                )
        }
    }
}

#Preview {
    MapView()
}
