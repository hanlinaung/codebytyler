//
//  ViewController.swift
//  coreMLCameraDemo
//
//  Created by Tyler Sai on 11/23/18.
//  Copyright © 2018 Tyler Sai. All rights reserved.
//

import UIKit
import AVKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lbClassified: UILabel!
    
    @IBOutlet weak var btCamera: UIButton!
    
    @IBOutlet weak var btPhoto: UIButton!
    
    @IBOutlet weak var btSave: UIBarButtonItem!
    
    var model = MobileNet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func btCameraAction(_ sender: UIButton) {
        print("Hello Camera")
        //check whether camera is available or not and open camera
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        
        }
    }
    
    
    @IBAction func btPhotoAction(_ sender: UIButton) {
        print("Hello Photo")
        
     
        
       //check whether photo library is allowrd or not and open photo library
       
          //  print("it is workinggggggg..............................")
            if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
                
                
            }
        
    }
    
    

    
    @IBAction func btSaveAction(_ sender: UIBarButtonItem) {
       // UIImageWriteToSavedPhotosAlbum(imgView.image! , nil, nil, nil)
       // var imageDataa = UIImage.jpegData(self.imgView.image!)
        //var compressedJPGImage =
        UIImageWriteToSavedPhotosAlbum(imgView.image!, nil, nil, nil)
        let alertController = UIAlertController.init(title: "Success", message: "Photo Saved!", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
       
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        //set image to the imageView
        imgView.image = pickedImage
        self.dismiss(animated: true, completion: nil)
        
        print("Hello ml working.......")
        
        //resizing image to 224 x 224 pixel
       /* let rect = CGRect(x: 0, y: 0, width: 224, height: 224)
        imgView.image?.drawAsPattern(in: rect)
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()*/
       
        let newImg = imgView.image?.scaleImage(toSize: CGSize.init(width: 112 , height: 112))
 
       // let newImg = resizedImage(newSize: CGSize.init(width: 224, height: 224))
         print("Hello ml working.......1")
        //making prediction
        if let imageToAnalyse = newImg{
             print("Hello ml working.......15")
            if let sceneLabelString = sceneLabel(forImage: imageToAnalyse) {
                lbClassified.text = sceneLabelString
            }
        }
        
    }
    
    

    func sceneLabel (forImage image:UIImage) -> String? {
         print("Hello ml working.......22")
    if let pixelBuffer = ImageProcessor.pixelBuffer(forImage: image.cgImage!) {
        guard let scene = try? model.prediction(image: pixelBuffer) else {fatalError("Unexpected runtime error")}
        return scene.classLabel
        
    }
    
    return nil
}

    
   
    
}
extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}
