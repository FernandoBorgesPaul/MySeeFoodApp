//
//  ViewController.swift
//  SeeFood
//
//  Created by Fernando Borges Paul on 08/07/18.
//  Copyright © 2018 Fernando Borges Paul. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()   // He creado un objeto de la clase ImagePickerController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self              // Se ha declarado este controller como el delegate del imagePicker.
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /* Se hace aquí un Optional Binding ya que se necesita transformar el userPickedImage
         que esta declarado como un Any? debido al info[] usando el as? se convierte al tipo UIImage
         y el optional binding hace que sea seguro hacer el cambio de tipo.
         */
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = userPickedImage
            
        /*ciimage es el formato que se necesita para que el framework de Vision pueda trabajar con la imagen
             que fue capturada por el usario. Se usa un guard para hacerlo màs seguro en el momento de transformarlo
             sino se logra cambiar el tipo. Entonces se dispara un fatal error. */
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("No se pudo convertir a una UIimage en una CIImage")
            }
            
            detect(image: ciimage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

    /* La función detecte importante para poder Core ML necesita identificar la imagen que */
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreMLModel failed.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Model fallo en procesar image")
            }
            
            print(result)
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try! handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    

}

