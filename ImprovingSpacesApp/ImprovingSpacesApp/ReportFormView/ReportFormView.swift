import SwiftUI
import AVFoundation

struct ReportFormView: View {
    
    @StateObject var cameraManager = CameraManager()
    private let firestoreService = FirestoreService()
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    
    @State private var subject: String = ""
    @State private var message: String = ""
    
    let selectedAddress: String
    
    init(selectedAddress: String) {
        
        self.selectedAddress = selectedAddress
    }
    
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
                
                if let image = selectedImage.map({ Image(uiImage: $0) }) {
                    
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
                ImagePicker(uiImage: $selectedImage, sourceType: sourceType)
              //  ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
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
            
            
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Dirección")
                    .font(.headline)
                
                Text(selectedAddress)
                    .padding(8)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
            let report = Report(subject: subject, message: message, address: selectedAddress)
            firestoreService.addReport(report: report, image: selectedImage) { result in
                switch result {
                case .success:
                    print("Reporte enviado correctamente")
                case .failure(let error):
                    print("Error al enviar el reporte: \(error)")
                }
            }
        }
    }
}

#Preview {
    ReportFormView(selectedAddress: "Rúa Pena Trevinca 34")
}
