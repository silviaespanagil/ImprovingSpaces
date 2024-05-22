//
//  ReportFormView.swift
//  ImprovingSpacesApp
//
//  Created by Silvia España Gil on 21/5/24.
//

import SwiftUI
import AVFoundation

struct ReportFormView: View {
    
    @StateObject var cameraManager = CameraManager()
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var selectedImage: Image?
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    
    @State private var subject: String = ""
    @State private var message: String = ""
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 20) {
                
                imageArea
                
                inputsArea
                
                sendButton
            }
            .padding()
        }
        .navigationTitle("Formulario")
    }
    
    @ViewBuilder
    var imageArea: some View {
        
        VStack(alignment: .leading) {
            
            Text("Comparte una imagen")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(height: 200)
                
                if let image = selectedImage {
                    
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                } else {
                    
                    Text("Seleccionar foto")
                        .foregroundColor(.gray)
                }
            }.actionSheet(isPresented: $showActionSheet) {
                
                ActionSheet(title: Text("Escoge una imagen o toma una nueva foto"),
                            message: nil,
                            buttons: [
                                .default(Text("Cámara")) {
                                    cameraManager.requestPermission { granted in
                                        if granted {
                                            sourceType = .camera
                                            showImagePicker = true
                                        }
                                    }
                                },
                                .default(Text("Carrete")) {
                                    sourceType = .photoLibrary
                                    showImagePicker = true
                                },
                                .cancel()
                            ])
            }
            .sheet(isPresented: $showImagePicker) {
                
                ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
            }
        }.onTapGesture { showActionSheet = true }
    }
    
    @ViewBuilder
    var inputsArea: some View {
        
        VStack(alignment: .leading) {
            
            Text("Asunto")
                .font(.headline)
            TextField("Un título para tu reporte", text: $subject)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        
        VStack(alignment: .leading) {
            
            Text("Mensaje")
                .font(.headline)
            TextEditor(text: $message)
                .frame(height: 150)
                .border(Color.gray, width: 1)
        }
    }
    
    @ViewBuilder
    var sendButton: some View {
        
        HorizontalButton(imageString: "paperplane", label: "Enviar") { }
    }
}

#Preview {
    ReportFormView()
}
