//
//  AddMovieViewController.swift
//  Insta_IMDB
//
//  Created by Asser on 5/20/20.
//  Copyright © 2020 Asser. All rights reserved.
//

import UIKit

//To apply deleagte pattern
protocol AddMovie {
    func addData(movie : Movie,poster : UIImage)
}

class AddMovieViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var overviewTextField: UITextField!
    
    var delegate : AddMovie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker()
    }
    
    func datePicker(){
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        dateTextField.inputView = picker
        picker.addTarget(self, action: #selector(dateFormatter(picker:)), for: .valueChanged)
    }
    
    @IBAction func addMovieClicked(_ sender: Any) {
        if dateTextField.text!.count < 1 {
            showAlert(message: "Please choose valid date")
        }else if titleTextField.text!.count < 3 {
            showAlert(message: "Please enter a valid title")
        }else if overviewTextField.text!.count < 10 {
            showAlert(message: "Description should consist of at least 10 chatacters")
        }
        else{
        delegate?.addData(movie: Movie(title: titleTextField.text!, poster: "", date: dateTextField.text!, description: overviewTextField.text!),poster: imageView.image!)
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
            }
        
        }
    }
    
    func showAlert(message : String){
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func attachImageClicked(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    //Dismiss Date Picker
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func dateFormatter(picker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = formatter.string(from: picker.date)
    }
    
}

extension AddMovieViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //Set image from gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            imageView.image = image
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
