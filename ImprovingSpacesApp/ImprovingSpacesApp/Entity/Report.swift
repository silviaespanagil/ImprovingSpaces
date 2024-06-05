//
//  Report.swift
//  ImprovingSpacesApp
//
//  Created by Silvia España Gil on 30/5/24.
//

import Foundation
import FirebaseFirestoreSwift

struct Report: Codable, Identifiable {
    
    @DocumentID var id: String? = UUID().uuidString
    var subject: String
    var message: String
    var address: String
    var imageUrl: String?
    var timestamp: Date = Date()
}
