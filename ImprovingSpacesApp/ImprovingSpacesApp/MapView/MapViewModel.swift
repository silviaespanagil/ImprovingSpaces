//
//  MapViewModel.swift
//  ImprovingSpacesApp
//
//  Created by Silvia España Gil on 16/5/24.
//

import Foundation
import MapKit
import SwiftUI

class MapViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    @Published var locationPermission: LocationPermissionManager = LocationPermissionManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    
    @Published var searchResults: [MKLocalSearchCompletion] = []
    @Published var mapCameraPosition: MapCameraPosition = .userLocation(
        fallback: .camera(
            MapCamera(centerCoordinate: .spain, distance: 1000)
        )
    )
    
    @Published var address: String = ""
    
    private var searchCompleter = MKLocalSearchCompleter()
    
    override init() {
        
        super.init()
        configureSearchCompleter()
    }
    
    // MARK: - Configuration Methods
    
    private func configureSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
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
    
    // MARK: - Local Search methods
    func updateSearchQuery(_ query: String) {
        
        address = query
        searchCompleter.queryFragment = query
    }
    
    func search(_ completion: MKLocalSearchCompletion) {
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { [weak self] response, error in
            guard let self = self, let response = response, let item = response.mapItems.first else {
                print("Search error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            self.handleSearchResponse(item)
        }
    }
    
    private func handleSearchResponse(_ item: MKMapItem) {
        
        let coordinate = item.placemark.coordinate
        
        selectedCoordinate = coordinate
        mapCameraPosition = .camera(
            MapCamera(centerCoordinate: coordinate, distance: 1000)
        )
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Autocomplete error: \(error.localizedDescription)")
    }
}

