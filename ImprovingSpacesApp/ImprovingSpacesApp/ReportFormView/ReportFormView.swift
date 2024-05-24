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
        
        VStack {
            
            ScrollView {
                
                VStack(spacing: 20) {
                    imageArea
                    inputsArea
                }
                .padding()
            }
            
            Spacer()
            
            sendButton
        }
        .navigationTitle("Formulario")
    }
    
    @ViewBuilder
    var imageArea: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Comparte una imagen")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray.opacity(0.5), lineWidth: 0.5)
                    .frame(minHeight: 200)
                
                if let image = selectedImage {
                    
                    image
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(10)
                } else {
                    
                    Text("Seleccionar foto")
                        .foregroundColor(.gray)
                }
            }
            .actionSheet(isPresented: $showActionSheet) {
                
                ActionSheet(title: Text("Escoge una imagen o toma una nueva foto"),
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
        }
        .onTapGesture { showActionSheet = true }
    }
    
    @ViewBuilder
    var inputsArea: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Asunto")
                    .font(.headline)
                
                TextField("Un título para tu reporte", text: $subject)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.5), lineWidth: 0.5)
                    )
            }
            
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Mensaje")
                    .font(.headline)
                
                TextEditor(text: $message)
                    .frame(height: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.5), lineWidth: 0.5)
                    )
            }
        }
    }
    
    @ViewBuilder
    var sendButton: some View {
        
        HorizontalButton(imageString: "paperplane", label: "Enviar") {
            // TODO
        }
    }
}

#Preview {
    ReportFormView()
}
