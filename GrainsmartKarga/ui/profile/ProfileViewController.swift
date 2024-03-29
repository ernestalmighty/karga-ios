//
//  ProfileViewController.swift
//  GrainsmartKarga
//
//  Created by user on 17/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields
import GooglePlaces
import RealmSwift

class ProfileViewController: UIViewController, UITextFieldDelegate, GMSAutocompleteViewControllerDelegate {
    
    @IBOutlet weak var nameTextField: MDCTextField!
    @IBOutlet weak var contactTextField: MDCTextField!
    @IBOutlet weak var deliveryInstructionTextField: MDCTextField!
    @IBOutlet weak var addressLine2TextField: MDCTextField!
    @IBOutlet weak var addressLine1TextField: MDCTextField!
    
    var nameTextController: MDCTextInputControllerFilled!
    var contactTextController: MDCTextInputControllerFilled!
    var addressLine1TextController: MDCTextInputControllerFilled!
    var addressLine2TextController: MDCTextInputControllerFilled!
    var deliveryInstructionTextController: MDCTextInputControllerFilled!
    
    var locationCoordinate: CLLocationCoordinate2D?
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        
        let rightButtonItem = UIBarButtonItem.init(
              title: "Save",
              style: .done,
              target: self,
              action: #selector(saveButtonAction(sender:))
        )

        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        self.addressLine1TextField.delegate = self

        self.nameTextController = MDCTextInputControllerFilled(textInput: nameTextField)
        self.contactTextController = MDCTextInputControllerFilled(textInput: contactTextField)
        self.addressLine1TextController = MDCTextInputControllerFilled(textInput: addressLine1TextField)
        self.addressLine2TextController = MDCTextInputControllerFilled(textInput: addressLine2TextField)
        self.deliveryInstructionTextController = MDCTextInputControllerFilled(textInput: deliveryInstructionTextField)
        
        self.nameTextField.textColor = UIColor(named: "color_text")
        self.nameTextController.activeColor = UIColor(named: "color_app")
        self.nameTextController.inlinePlaceholderColor = UIColor(named: "color_placeholder")
        self.nameTextController.floatingPlaceholderActiveColor = UIColor(named: "color_text")
        self.nameTextController.floatingPlaceholderNormalColor = UIColor(named: "color_text")
        
        self.contactTextField.textColor = UIColor(named: "color_text")
        self.contactTextController.activeColor = UIColor(named: "color_app")
        self.contactTextController.inlinePlaceholderColor = UIColor(named: "color_placeholder")
        self.contactTextController.floatingPlaceholderActiveColor = UIColor(named: "color_text")
        self.contactTextController.floatingPlaceholderNormalColor = UIColor(named: "color_text")
        
        self.addressLine1TextField.textColor = UIColor(named: "color_text")
        self.addressLine1TextController.activeColor = UIColor(named: "color_app")
        self.addressLine1TextController.inlinePlaceholderColor = UIColor(named: "color_placeholder")
        self.addressLine1TextController.floatingPlaceholderActiveColor = UIColor(named: "color_text")
        self.addressLine1TextController.floatingPlaceholderNormalColor = UIColor(named: "color_text")
        
        self.addressLine2TextField.textColor = UIColor(named: "color_text")
        self.addressLine2TextController.activeColor = UIColor(named: "color_app")
        self.addressLine2TextController.inlinePlaceholderColor = UIColor(named: "color_placeholder")
        self.addressLine2TextController.floatingPlaceholderActiveColor = UIColor(named: "color_text")
        self.addressLine2TextController.floatingPlaceholderNormalColor = UIColor(named: "color_text")
        
        self.deliveryInstructionTextField.textColor = UIColor(named: "color_text")
        self.deliveryInstructionTextController.activeColor = UIColor(named: "color_app")
        self.deliveryInstructionTextController.inlinePlaceholderColor = UIColor(named: "color_placeholder")
        self.deliveryInstructionTextController.floatingPlaceholderActiveColor = UIColor(named: "color_text")
        self.deliveryInstructionTextController.floatingPlaceholderNormalColor = UIColor(named: "color_text")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let profile = realm.objects(Profile.self).first
        
        if(profile != nil) {
            nameTextField.text = profile?.name
            contactTextField.text = profile?.contact
            addressLine1TextField.text = profile?.addressLine1
            addressLine2TextField.text = profile?.addressLine2
            deliveryInstructionTextField.text = profile?.instructions
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Test")
        
        var userAddress: [String] = []
        
        for addressComponent in place.addressComponents! {
            userAddress.append(String(addressComponent.name))
        }
        
        addressLine1TextField.text = userAddress.joined(separator: ", ")
        addressLine2TextField.text = place.name
        
        self.locationCoordinate = place.coordinate
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Test")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Test")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonAction(sender: UIBarButtonItem) {
        var isValid = true
        
        if(nameTextField.text!.isEmpty) {
            isValid = false
            self.nameTextController.setErrorText("Please provide your name.", errorAccessibilityValue: nil)
        }
        
        if(addressLine1TextField.text!.isEmpty) {
            isValid = false
            self.addressLine1TextController.setErrorText("Please provide your address.", errorAccessibilityValue: nil)
        }
        
        if(addressLine2TextField.text!.isEmpty) {
            isValid = false
            self.addressLine2TextController.setErrorText("Please provide your detailed address.", errorAccessibilityValue: nil)
        }
        
        if(contactTextField.text!.isEmpty) {
            isValid = false
            self.contactTextController.setErrorText("Please provide your contact", errorAccessibilityValue: nil)
        }
        
        if(!isValid) {
            return
        } else {
            let profile = Profile()
            profile.name = nameTextField.text!
            profile.contact = contactTextField.text!
            profile.addressLine1 = addressLine1TextField.text!
            profile.addressLine2 = addressLine2TextField.text!
            profile.instructions = deliveryInstructionTextField.text!
            profile.addressLat = Double(locationCoordinate?.latitude ?? 0.0)
            profile.addressLon = Double(locationCoordinate?.longitude ?? 0.0)
            
            try! realm.write {
                realm.add(profile, update: .modified)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func onAddressTapped(_ sender: Any) {
        print("Test")
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.primaryTextColor = UIColor.gray
        autocompleteController.primaryTextHighlightColor = UIColor.black
        autocompleteController.secondaryTextColor = .gray
        
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue | UInt(GMSPlaceField.addressComponents.rawValue)))!
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.countries = ["PH"]
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension ProfileViewController {

    func initializeHideKeyboard(){
       //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(
           target: self,
           action: #selector(dismissMyKeyboard))
       
       //Add this tap gesture recognizer to the parent view
       view.addGestureRecognizer(tap)
   }
   
   @objc func dismissMyKeyboard(){
       //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
       //In short- Dismiss the active keyboard.
       view.endEditing(true)
   }

}
