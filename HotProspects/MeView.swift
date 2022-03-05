//
//  MeView.swift
//  HotProspects
//
//  Created by Миша Перевозчиков on 27.02.2022.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    
    @State private var name = "Anonymous"
    @State private var email = "your@site.com"
    
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .font(.title)
                Image(uiImage: qrCode)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .contextMenu{
                        Button {
                            let image = generateQrCode(from: "\(name)\n\(email)")
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: image)
                        } label: {
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                        }
                    }
            }
            .navigationTitle("My code")
            .onAppear(perform: updateQR)
            .onChange(of: name) { _ in updateQR() }
            .onChange(of: email) { _ in updateQR() }
        }
    }
    
    func updateQR() {
        qrCode = generateQrCode(from: "\(name)\n\(email)")
    }
    
    func generateQrCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimge = context.createCGImage(outputImage, from: outputImage.extent){
                return UIImage(cgImage: cgimge)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
