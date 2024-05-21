//
//  HorizontalButton.swift
//  ImprovingSpacesApp
//
//  Created by Silvia España Gil on 21/5/24.
//

import SwiftUI

struct HorizontalButton: View {
    
    let imageString: String?
    let label: String
    let action: () -> Void
    
    init(imageString: String?, label: String, action: @escaping () -> Void) {
        self.imageString = imageString
        self.label = label
        self.action = action
    }
    
    var body: some View {
        
        Button(action: {
            
            action()
        }) {
            HStack {
                
                if let image = imageString {
                    
                    Image(systemName: image)
                        .foregroundColor(.black)
                }
                Text(label)
                    .font(.headline)
                    .foregroundColor(.black)
            }.padding()
        }
        .background(Color(hex: "ABFB0E"))
        .clipShape(Capsule())
        .padding(.horizontal, 16)
    }
}
