//
//  FirestoreService.swift
//  ImprovingSpacesApp
//
//  Created by Silvia España Gil on 30/5/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class FirestoreService {
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    func addReport(report: Report, image: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {
        
        var newReport = report
        
        if let image = image {
            
            uploadImage(image) { result in
                
                switch result {
                    
                case .success(let url):
                    newReport.imageUrl = url.absoluteString
                    self.saveReport(newReport, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            
            saveReport(newReport, completion: completion)
        }
    }
    
    private func saveReport(_ report: Report, completion: @escaping (Result<Void, Error>) -> Void) {
        
        do {
            
            try db.collection("reports").document(report.id ?? UUID().uuidString).setData(from: report)
            completion(.success(()))
        } catch {
            
            completion(.failure(error))
        }
    }

    private func uploadImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            
            completion(.failure(NSError(domain: "Invalid image data", code: -1, userInfo: nil)))
            return
        }

        let storageReference = storage.reference().child("images/\(UUID().uuidString).jpg")
        
        storageReference.putData(imageData, metadata: nil) { metadata, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }

            storageReference.downloadURL { url, error in
                
                if let url = url {
                    completion(.success(url))
                } else {
                    completion(.failure(error!))
                }
            }
        }
    }
}
