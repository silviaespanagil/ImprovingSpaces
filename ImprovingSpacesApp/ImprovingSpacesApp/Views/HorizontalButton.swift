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
    let isDisabled: Bool?
    let action: () -> Void
    
    init(imageString: String?, label: String, isDisabled: Bool? = false, action: @escaping () -> Void) {
        self.imageString = imageString
        self.label = label
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        
        Button(action: {
            
            action()
        }) {
            HStack {
                
                if let image = imageString {
                    
                    Image(systemName: image)
                        .foregroundColor(isDisabled ?? false ? .white : .black)
                }
                Text(label)
                    .font(.headline)
                    .foregroundColor(isDisabled ?? false ? .white : .black)
            }.padding()
        }.disabled(isDisabled ?? false)
            .background(isDisabled ?? false ? .gray.opacity(0.3) : Color(hex: "ABFB0E"))
        .clipShape(Capsule())
        .padding(.horizontal, 16)
    }
}
