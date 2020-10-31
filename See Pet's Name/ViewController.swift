//
//  ViewController.swift
//  See Pet's Name
//
//  Created by Tonoy Rahman on 2020-10-31.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
   
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage)  else {
                
                fatalError("we could not conver UIImage into CIImage")
            }
            
            detect(image: ciimage )
        }
        
        imagePicker.dismiss(animated: true , completion: nil)
        
    }
    
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: PetAnimalsMLModel().model)   else {
            
            fatalError("Loading CoreML Model failed.")
        }
        
        let request = VNCoreMLRequest(model:  model) { (request, error) in
            
            guard  let results = request.results as? [VNClassificationObservation] else {
                
                fatalError("Model failed to process image")
            }
            
            if let firstResult = results.first {
                
                if firstResult.identifier.contains("Cat") {
                    self.navigationItem.title = "Pet animal: Cat"
                }
                else if firstResult.identifier.contains("Cow") {
                    self.navigationItem.title = "Pet animal: Cow"
                }
                else if firstResult.identifier.contains("Dog") {
                    self.navigationItem.title = "Pet animal: Dog"
                }
                else if firstResult.identifier.contains("Goat") {
                    self.navigationItem.title = "Pet animal: Goat"
                }
                else if firstResult.identifier.contains("Goose") {
                    self.navigationItem.title = "Pet animal: Goose"
                }
                else if firstResult.identifier.contains("Horse") {
                    self.navigationItem.title = "Pet animal: Horse"
                }
                else if firstResult.identifier.contains("Mice") {
                    self.navigationItem.title = "Pet animal: Mice"
                }
                else if firstResult.identifier.contains("Rabbit") {
                    self.navigationItem.title = "Pet animal: Rabbit"
                }
                
                
                else {
                    
                    self.navigationItem.title = "Sorry it's not in list of food items we will add soon"
                }
            }
            
            
        }
        
        
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
           try handler.perform([request])
        }
        catch {
            
            print(error)
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

