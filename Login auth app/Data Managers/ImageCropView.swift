import SwiftUI

struct CropImageView: View {
    @Binding var selectedImage: UIImage?
    @Binding var isCropping: Bool
    @State private var croppedImage: UIImage?
    @State private var cropRect: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200)

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: croppedImage ?? image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .border(Color.gray, width: 1)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let translation = value.translation
                            cropRect.origin.x += translation.width
                            cropRect.origin.y += translation.height
                        }
                    )
                    .gesture(MagnificationGesture()
                        .onChanged { value in
                            let scale = value.magnitude
                            cropRect.size.width *= scale
                            cropRect.size.height *= scale
                        }
                    )
            }
            Button("Crop Image") {
                if let image = selectedImage {
                    if let croppedCGImage = image.cgImage?.cropping(to: cropRect) {
                        croppedImage = UIImage(cgImage: croppedCGImage)
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .opacity(selectedImage != nil ? 1.0 : 0.0)

            Spacer()
        }
        .padding()
        .onAppear {
            if let image = selectedImage {
                croppedImage = image
            }
        }
        .onDisappear {
            if isCropping {
                isCropping = false
                selectedImage = croppedImage
            }
        }
    }
}
