//
//  ViewController.swift
//  PickingImages
//
//  Created by MacbookPRV on 08/01/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//

import Foundation
import UIKit






class EditorView: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    
    @IBOutlet weak var appToolbar: UIToolbar!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextFiled: UITextField!
    @IBOutlet weak var bottomTextFiled: UITextField!
    
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName:UIColor.blackColor(),
        NSForegroundColorAttributeName:UIColor.whiteColor(),
        NSFontAttributeName:UIFont(name:"HelveticaNeue-CondensedBlack", size: 35)!,
        NSStrokeWidthAttributeName:-2.0]
    
    
    //MARK: view controller methode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        MemeAttrib(topTextFiled, defaultText: "TOP")
        MemeAttrib(bottomTextFiled, defaultText: "BOTTOM")
        shareButton.enabled = false
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        subscibeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
        
    }
    
    
    //MARK: textfield Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        
        if topTextFiled.isFirstResponder()  && textField.text == "TOP" {
            textField.text = ""
        }
        
        if bottomTextFiled.isFirstResponder()  && textField.text == "BOTTOM" {
           textField.text = ""
        }
        
        
    }
    
    
    //MARK: Image Picker Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        
        imagePickerView.image = image
        imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
        
        shareButton.enabled = true
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    //MARK: Action IB Button
    
    
    @IBAction func actionCancel(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func albumAction(sender: AnyObject) {
        
       imageFromCamera(false)
        
    }
    
    
    @IBAction func cameraAction(sender: AnyObject) {
        
        imageFromCamera(true)
        
    }
    
    
    
    @IBAction func shareAction(sender: AnyObject) {
        
        
        let activitiesVC = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        
        activitiesVC.popoverPresentationController?.barButtonItem = shareButton
        presentViewController(activitiesVC, animated: true, completion: ({
            
            //create the meme
            let meme = VideoMod(textTop: self.topTextFiled.text!, textBottom: self.bottomTextFiled.text!, imageOrigin: self.imagePickerView.image!, memedImage: self.generateMemedImage())
            
            //save meme
            let sentmemes = SentMemes.singleton
            if let _ = sentmemes.memeArray {
                sentmemes.memeArray.append(meme)
            }
            else {
                sentmemes.memeArray=[meme]
            }
            
            
        }))
        
        
    }
    
    

    func imageFromCamera(camera:Bool) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if camera {
             imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
       
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    //MARK: MemeMe function
    
    
    func MemeAttrib (textfield:UITextField, defaultText:String) -> UITextField {
        
        
        
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = NSTextAlignment.Center
        textfield.borderStyle = UITextBorderStyle.None
        textfield.text = defaultText
        textfield.delegate = self
        
        return textfield
    }
    
    
    func generateMemedImage()->UIImage {
        
        //Hide toolbar and navbar
        appToolbar.hidden = true
    
        
        //Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedimage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        appToolbar.hidden = false
       
        
        return memedimage
    }
    
    
    //MARK: keyboard function
    
    
    func  subscibeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    func keyboardWillShow(notification:NSNotification) {
        
        if bottomTextFiled.isFirstResponder() {
            let result = -1 * getkeyboardHeight(notification)
            view.frame.origin.y = result
        }
        
    }
    
    
    func keyboardWillHide(notification:NSNotification) {
        
        if bottomTextFiled.isFirstResponder() {
            view.frame.origin.y = 0
        }
        
        
    }
    
    func getkeyboardHeight(notification:NSNotification)->CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
        
    }
    
    
    
    
    
    
}

