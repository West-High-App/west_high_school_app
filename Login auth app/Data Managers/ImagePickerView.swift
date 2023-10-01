//
//  ImagePickerView.swift
//  West High App
//
//  Created by August Andersen on 08/09/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct ImagePickerView: View {
    
    @State var showPicker = false
    @State var selectedImage: UIImage?
    @State var retrievedImages = [UIImage]()
    @State var imagetoshow: UIImage?
    
    @State var imagename: String
    
    var body: some View {
        VStack {
                
            Button {
                getImageFromStorage(fileName: imagename) { image in
                    imagetoshow = image
                }
            } label: {
                Text("Refresh")
            }

            Text("Public image:")
            if let imagetoshow = imagetoshow {
                Image(uiImage: imagetoshow)
                    .resizable()
                    .frame(width: 200, height: 200)
            }
            
            Text("Selected image:")
            if selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .frame(width: 200, height: 200)
            }
            
            Button {
                showPicker = true
            } label: {
                Text("Select image")
            }
            
            if selectedImage != nil {
                Button {
                    imagename = uploadPhoto()
                    getImageFromStorage(fileName: imagename) { image in
                        imagetoshow = image
                    }
                } label: {
                    Text("Publish Image")
                }
            }
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $showPicker)
        }
        .onAppear {
            retrievePhotos()
            getImageFromStorage(fileName: imagename) { image in
                imagetoshow = image
            }
        }
    }
    
    func getImageFromStorage(fileName: String, completion: @escaping (UIImage?) -> Void) {
            let storageRef = Storage.storage().reference()
            let fileRef = storageRef.child("images/\(fileName)")
            fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if error == nil, let imageData = data {
                    if let image = UIImage(data: imageData) {
                        completion(image)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
        }
    
    func uploadPhoto() -> String{
        guard selectedImage != nil else {
            return ""
        }
        
        let storageRef = Storage.storage().reference()
        
        let imageData = selectedImage!.jpegData(compressionQuality: 0.01)
        
        guard imageData != nil else {
            return ""
        }
        
        let path = "images/\(UUID().uuidString).jpg" // name change here
        let fileRef = storageRef.child(path)
        
        _ = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            if error == nil && metadata != nil {
                
                let db = Firestore.firestore()
                db.collection("Images").document().setData([
                    "url":path
                ]) { error in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.retrievedImages.append(self.selectedImage!)
                            imagename = path
                        }
                    }
                }
            }
        }
       return path
    }
    
    
    func retrievePhotos() {
        
        let db = Firestore.firestore()
        db.collection("Images").addSnapshotListener { snapshot, error in
            if error == nil && snapshot != nil {
                var paths = [String]()
                
                for doc in snapshot!.documents {
                    
                    paths.append(doc["url"] as? String ?? "")
                    
                }
                
                for path in paths {
                    
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if error == nil && data != nil{
                            if let image = UIImage(data: data!) {
                                DispatchQueue.main.async {
                                    if let index = self.retrievedImages.firstIndex(of: image) {
                                        self.retrievedImages[index] = image
                                    } else {
                                        self.retrievedImages.append(image)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

class imageManager: ObservableObject {
    
    @Published var selectedImage: UIImage?
        @Published var imageName: String = ""
        @Published var bandwidth = 0
        
        let userDefaults = UserDefaults.standard
        
        func getImage(fileName: String, completion: @escaping (UIImage?) -> Void) {
            // Check if the image exists in UserDefaults
            if let imageData = userDefaults.data(forKey: fileName), let image = UIImage(data: imageData) {
                completion(image)
            } else {
                // If not, fetch it from Firebase
                getImageFromStorage(fileName: fileName) { [weak self] image in
                    if let image = image {
                        // Cache the fetched image in UserDefaults
                        self?.cacheImageInUserDefaults(image: image, fileName: fileName)
                        print(self?.userDefaults.data(forKey: fileName) ?? "")
                        completion(image)
                    } else {
                        completion(nil)
                        print("Error fetching image from Firebase")
                    }
                }
            }
        }
        
        func getImageFromStorage(fileName: String, completion: @escaping (UIImage?) -> Void) {
            let storageRef = Storage.storage().reference()
            let fileRef = storageRef.child(fileName)
            fileRef.getData(maxSize: 1024 * 1024 * 10) { data, error in
                if error == nil, let imageData = data, let image = UIImage(data: imageData) {
                    completion(image)
                } else {
                    print("Error fetching image from Firebase: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                }
            }
        }
        
        func cacheImageInUserDefaults(image: UIImage, fileName: String) {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                userDefaults.set(imageData, forKey: fileName)
            }
        }
    
    func uploadPhoto(file: UIImage) -> String{
        let storageRef = Storage.storage().reference()
        
        let maxsize = 1024 * 300 // 150kb
        let imageData = file.jpegData(compressionQuality: 0.3)
        
        guard imageData != nil else {
            return ""
        }
        
        let path = "images/\(UUID().uuidString).jpg" // name change here
        let fileRef = storageRef.child(path)
        
        _ = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
        }
       return path
    }
    
    func deleteImage(imageFileName: String, completion: @escaping (Error?) -> Void) {
            let storageRef = Storage.storage().reference()
            let fileRef = storageRef.child(imageFileName)
            
            fileRef.delete { error in
                if let error = error {
                    print("Error deleting image: \(error.localizedDescription)")
                    completion(error)
                } else {
                    print("Image deleted successfully")
                    completion(nil)
                }
            }
        }
    
    
    func jpegDataWithMaxFileSize(image: UIImage, maxSizeInBytes: Int) -> Data? {
        var compression: CGFloat = 1.0
        var imageData = image.jpegData(compressionQuality: compression)

        while let data = imageData, data.count > maxSizeInBytes, compression > 0.0 {
            compression -= 0.1
            imageData = image.jpegData(compressionQuality: compression)
        }

        return imageData
    }

    
    
}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(imagename: "6E2D725C-53C2-41AF-85B3-C994B03F63F9.jpg")
    }
}
