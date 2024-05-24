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
    @State private var selectedAddress: String = ""
    
    var body: some View {
        
        ZStack {
            
            mapView
            
            VStack {
                
                searchField
                Spacer()
            }
        }
        .navigationDestination(isPresented: $goToReportView) { ReportFormView() }
        .sheet(isPresented: $showAddressSugestions, onDismiss: {
            viewModel.address = selectedAddress
        }) {
            addressSuggestions
        }
    }
    
    @ViewBuilder
    var mapView: some View {
        
        VStack {
            
            MapReader { proxy in
                
                Map(position: $viewModel.mapCameraPosition) {
                    
                    if let selection = viewModel.selectedCoordinate {
                        
                        Annotation("", coordinate: selection) {
                            
                            Image(systemName: "mappin.and.ellipse")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            .foregroundColor(Color(hex: "FF5714")) }
                        
                        MapCircle(center: selection, radius: CLLocationDistance(100))
                            .foregroundStyle(Color(hex: "ABFB0E").opacity(0.40))
                            .mapOverlayLevel(level: .aboveLabels)
                    }
                }.navigationBarTitleDisplayMode(.inline)
                    .onTapGesture { position in
                        
                        if let coordinate = proxy.convert(position, from: .local) {
                            
                            viewModel.updateSelectedCoordinate(coordinate)
                            viewModel.searchAddress(for: coordinate)
                        }
                    }
            }
            .mapControls {
                
                MapScaleView()
                MapCompass()
                MapUserLocationButton()
            }
        }.ignoresSafeArea(edges: .all)
            .onAppear {
                viewModel.requestLocationPermission()
            }
    }
    
    @ViewBuilder
    var nextButton: some View {
        
        HorizontalButton(imageString: "arrow.right", label: "Siguiente", isDisabled: selectedAddress.isEmpty) {
            goToReportView = true
            showAddressSugestions = false
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
                    viewModel.address = result.title
                    selectedAddress = result.title
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
            nextButton
        }
    }
}

#Preview {
    MapView()
}
