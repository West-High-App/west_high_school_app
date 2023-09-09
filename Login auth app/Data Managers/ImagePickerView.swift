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
                    print(imagetoshow)
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
                        print(imagetoshow)
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
        
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        
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
                            print("UPDATED TO PATH: \(path)")
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
        db.collection("Images").getDocuments { snapshot, error in
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

class imageManager: ObservableObject {
    
    @State var selectedImage: UIImage?
    @State var imagetoshow: UIImage?
    @State var imagename: String = ""
    
    func getImageFromStorage(fileName: String, completion: @escaping (UIImage?) -> Void) {
        
            let storageRef = Storage.storage().reference()
            let fileRef = storageRef.child(fileName)
            fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if error == nil, let imageData = data {
                    if let image = UIImage(data: imageData) {
                        completion(image)
                    } else {
                        completion(nil)
                    }
                } else {
                    print("ERROR")
                    print(error!.localizedDescription)
                    completion(nil)
                }
            }
        }
    
    func uploadPhoto(file: UIImage) -> String{
        
        let storageRef = Storage.storage().reference()
        
        let imageData = file.jpegData(compressionQuality: 0.8)
        
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
    
    
}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(imagename: "6E2D725C-53C2-41AF-85B3-C994B03F63F9.jpg")
    }
}
