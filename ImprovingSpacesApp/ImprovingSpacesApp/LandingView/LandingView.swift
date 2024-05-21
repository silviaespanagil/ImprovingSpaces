//
//  LandingView.swift
//  ImprovingSpacesApp
//
//  Created by Silvia España Gil on 16/5/24.
//

import SwiftUI

struct LandingView: View {
    
    @State private var showingMapView = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            ScrollView {
                
                header
                
                Spacer().frame(height: 30)
                
                cardArea
                
                Spacer()
            }
            
            reportButton
        }.navigationDestination(isPresented: $showingMapView) { MapView() }
            .navigationBarTitle("StreetHero")
    }
}

extension LandingView {
    
    // MARK: - ViewBuilders
    
    @ViewBuilder
    var header: some View {
        
        Text("Tu voz para una vía pública mejor")
            .font(.body)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func card(image: Image,
              title: String,
              description: String,
              imagePositionLeading: Bool? = true) -> some View {
        
        HStack {
            
            if imagePositionLeading == true {
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width / 3, height: 150)
                    .clipped()
            }
            
            VStack(alignment: imagePositionLeading! ? .trailing : .leading, spacing: 8) {
                
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(imagePositionLeading! ? .trailing : .leading)
                
                Text(description)
                    .font(.subheadline)
                    .multilineTextAlignment(imagePositionLeading! ? .trailing : .leading)
            }.padding(imagePositionLeading! ? .trailing : .leading, 16)
                .frame(maxWidth: .infinity, alignment: imagePositionLeading! ? .trailing : .leading)
            
            if !(imagePositionLeading ?? false) {
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width / 3, height: 150)
                    .clipped()
            }
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    var cardArea: some View {
        
        card(image: Image("map"), title: "Selecciona el lugar de la incidencia", description: "Utiliza el mapa para escoger el lugar a mejorar")
        
        Spacer().frame(height: 24)
        
        card(image: Image("photo"), title: "Sube una foto", description: "¡Captura el problema con tu cámara!", imagePositionLeading: false)
        
        Spacer().frame(height: 24)
        
        card(image: Image("share"), title: "Cuéntanos qué pasa", description: "Tu voz importa. Cuéntanos los detalles.")
    }
    
    @ViewBuilder
    var reportButton: some View {
        
        HorizontalButton(imageString: "map.fill",
                         label: "Hacer reporte") {
            showingMapView = true
        }
    }
}

#Preview {
    LandingView()
}
