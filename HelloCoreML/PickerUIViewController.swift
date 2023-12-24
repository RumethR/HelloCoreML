//
//  PickerUIViewController.swift
//  HelloCoreML
//
//  Created by Tihara Jayawickrama on 2023-12-24.
//

import Foundation
import SwiftUI
import PhotosUI
import UIKit

struct PickerUIViewController : UIViewControllerRepresentable {
    
    @Binding var pickedImage : UIImage?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> PickerCoordinator {
        PickerCoordinator(picker: self)
    }
    
    class PickerCoordinator : NSObject , PHPickerViewControllerDelegate{
        
        let picker : PickerUIViewController
        
        init(picker: PickerUIViewController) {
            self.picker = picker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self){
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        self.picker.pickedImage = image as? UIImage
                    }
                }
            }
            
        }
    }
    
}

