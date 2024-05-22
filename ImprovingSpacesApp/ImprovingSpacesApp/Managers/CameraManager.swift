//
//  CameraManager.swift
//  ImprovingSpacesApp
//
//  Created by Silvia España Gil on 22/5/24.
//

import Foundation
import AVFoundation

class CameraManager: NSObject, ObservableObject {
    
    @Published var permissionGranted = false
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        
        AVCaptureDevice.requestAccess(for: .video) { accessGranted in
            
            DispatchQueue.main.async {
                
                self.permissionGranted = accessGranted
                completion(accessGranted)
            }
        }
    }
}
