//
//  ViewController.swift
//  MemeMe
//
//  Created by Ghada Al on 17/02/1440 AH.
//  Copyright © 1440 ghadaalone. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UITextFieldDelegate {

   
    @IBOutlet weak var imagePickerView: UIImageView!
    
    
    @IBOutlet weak var topTextField1: UITextField!
    

    @IBOutlet weak var bottomTextField2: UITextField!
    
    @IBOutlet weak var navBar1: UINavigationBar!
    
    
    @IBOutlet weak var toolBar1: UIToolbar!
    
    @IBOutlet weak var disableCamera: UIBarButtonItem!
    
    @IBOutlet weak var disableShareButton: UIBarButtonItem!
    
    @IBOutlet weak var disableCancelButton: UIBarButtonItem!
   
    // set thr style for top textfield and bottom textfield
    let memeTextAttributes:[NSAttributedString.Key: Any] = [
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue) : UIColor.black,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -2.0
        
        
    ]
    
    
    
    override func viewDidLoad() {
       self.topTextField1.delegate = self
        self.bottomTextField2.delegate = self
        topTextField1.text = "TOP"
        bottomTextField2.text = "BOTTOM"
        contentmode()
       
       topTextField1.defaultTextAttributes = memeTextAttributes
        bottomTextField2.defaultTextAttributes = memeTextAttributes
        topTextField1.backgroundColor = UIColor.clear
        bottomTextField2.backgroundColor = UIColor.clear
        topTextField1.textAlignment = .center
        bottomTextField2.textAlignment = .center
    disableShareButton.isEnabled = false
        disableCancelButton.isEnabled = false
       
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
         disableCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    // subscribe for keyboard
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(keyboardWillShow),
        name: UIResponder.keyboardWillShowNotification, object: nil)
        
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(keyboardWillHide),
        name: UIResponder.keyboardWillHideNotification, object: nil)
        
       
        
    }
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // function to keyboard show on the screen
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField2.isFirstResponder{
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    }
    
    // set height for keyboard to show up and write in the bottom textfield
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    
    @objc func keyboardWillHide(_ notification:Notification) {
     
        view.frame.origin.y = 0
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Figure out what the new text will be, if we return true
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        return true;
    }
    
    //hide the keyboard if the user press return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == topTextField1)      &&  (topTextField1.text == "TOP") {
            topTextField1.text = ""
           
            textField.becomeFirstResponder()
        }
     
        
       
        if(textField == bottomTextField2)  && (bottomTextField2.text == "BOTTOM"){
            bottomTextField2.text = ""
            textField.becomeFirstResponder()
        }
      
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if(textField == topTextField1)      &&  (topTextField1.text == "") {
            topTextField1.text = "TOP"
            textField.resignFirstResponder()
           
        }
        
        if(textField == bottomTextField2)  && (bottomTextField2.text == ""){
            bottomTextField2.text = "BOTTOM"
            textField.resignFirstResponder()
           
        }
    }
 

    @IBAction func pickAnImage(_ sender: Any) {
        let pickerImageController = UIImagePickerController()
        pickerImageController.delegate = self
        pickerImageController.sourceType = .photoLibrary
        pickerImageController.allowsEditing = true
        
        
        present(pickerImageController, animated: true, completion: nil)
        
    }
    // let the user take a photo by using camera button
    @IBAction func pickAnImagecamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let pickercamera = UIImagePickerController()
            pickercamera.delegate = self
            pickercamera.sourceType = UIImagePickerController.SourceType.camera
            present(pickercamera, animated: true, completion: nil)
            
        }
        else{
          // i put this code to check if the code work or no
            print("not available")
        }
    }
    
    
     func imagePickerController(_ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
           disableCancelButton.isEnabled = true
            disableShareButton.isEnabled = true
           
        }
        else {
           
        }
        dismiss(animated: true, completion: nil)
        
        
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    // after i finished the meme image i can shared
    @IBAction func shareButton(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {(activity,completed, items, error) in
            if completed
            {self.save(memeImage: memedImage) }}
        
        present(activityViewController, animated: true, completion: nil)
  
    }
    
    
    
    
    
    
        struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memeImage: UIImage
        
    }
    
    
    //function for save the meme image
    func save(memeImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: topTextField1.text!, bottomText: bottomTextField2.text!, originalImage: imagePickerView.image!, memeImage: memeImage)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navigation bar
        
      self.navBar1.isHidden = true
        self.toolBar1.isHidden = true
      
      
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        
        // Show toolbar and navigation bar
      
       
       
        self.toolBar1.isHidden = false
       self.navBar1.isHidden = false
        
        return memedImage
    }

    @IBAction func cancelButton(_ sender: Any) {
       topTextField1.text = "TOP"
        bottomTextField2.text = "BOTTOM"
        imagePickerView.image = nil
        disableShareButton.isEnabled = false
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //here for two textfield and imageview
    func contentmode() {
         imagePickerView.contentMode = .scaleAspectFit
         topTextField1.contentMode = .scaleAspectFit
       
         bottomTextField2.contentMode = .scaleAspectFit
    }
    
    
    
    
    
    
    
}

