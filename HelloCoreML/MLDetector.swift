//
//  MLdit.swift
//  HelloCoreML
//
//  Created by Code Studio  on 2023-12-24.
//

import Foundation
import CoreML
import  SwiftUI
import Vision
import VideoToolbox

class  MLDitector : ObservableObject{
    
    @Published var identifier : String = ""
    @Published var selectedImage : UIImage?
    @Published var modifiedImage : UIImage?
    
    lazy var classificationRequest : VNCoreMLRequest = {
        
        do{
            
            let config = MLModelConfiguration()
            config.computeUnits = .all
            let model = try VNCoreMLModel(for: MNISTClassifier(configuration: config).model)
            
            let request = VNCoreMLRequest(model: model) {[weak self] response, error in
                
                guard let self = self else{return}
                self.checkResults(response: response)
                
            }
            
            return request
            
        }catch{
            
            fatalError("Unable to load the model")
            
        }
        
    }()
    
    func runMLPipeline(){
        DispatchQueue.global(qos: .userInitiated).async {
//            guard let image = UIImage(named: "") else {return}
            guard let image = self.selectedImage else {return}
            
            if let convertedImage = self.scaleAndConvertToGray(image: image){
                guard let ciImage = CIImage(image: convertedImage) else {return}
                
                let handler = VNImageRequestHandler(ciImage: ciImage)
                
                do{
                    try handler.perform([self.classificationRequest])
                    
                }catch{
                    print("Unable to perform the ML task")
                    
                }

            }

        }
        
    }
    
    func scaleAndConvertToGray(image: UIImage) -> UIImage? {
            let newSize = CGSize(width: 28, height: 28)

            UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
            defer {
                UIGraphicsEndImageContext()
            }

            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }

            // Flip the coordinate system to match UIKit's
            context.translateBy(x: 0, y: newSize.height)
            context.scaleBy(x: 1.0, y: -1.0)

            // Draw the image in the new size
            context.draw(image.cgImage!, in: CGRect(origin: .zero, size: newSize))

            return UIGraphicsGetImageFromCurrentImageContext()
        }

    
    func checkResults(response : VNRequest){
        
        DispatchQueue.main.async {
            guard let  result = response.results else {return}
            
           let classification = result as! [VNClassificationObservation]
           let description = classification.prefix(5).filter({
                $0.confidence > 0.5
            })
            
            if let identifier = description.first?.identifier{
                self.identifier = identifier
            
//            let imageResult = result as? [VNPixelBufferObservation]
//            guard let imageBuffer = imageResult else {return }
//            guard let resultImage = imageBuffer.first else {return}
//
//            var outputImage : CGImage?
//            VTCreateCGImageFromCVPixelBuffer(resultImage.pixelBuffer, options: nil, imageOut: &outputImage)
//
//            if let finalImage = outputImage{
//                self.modifiedImage = UIImage(cgImage: finalImage)
            
            }
        }
        
    }
    
}
