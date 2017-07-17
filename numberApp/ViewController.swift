//
//  ViewController.swift
//  numberApp
//
//  Created by Mac on 6/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

// fix segue thing
// fix detail View thing
// make app beautiful
//push

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let dataManager = DataManager()
    let arrayOfTypes = ["trivia", "math", "date", "year"]
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet weak var goButton: UIButton!
    
    var results: String!
    
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var numberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.numberTextField.delegate = self
        self.typePicker.delegate = self
        self.typePicker.dataSource = self
        
        goButton.layer.cornerRadius = 10
      
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.white
        pickerLabel.text = arrayOfTypes[row]
         pickerLabel.font = UIFont(name: "Futura", size: 20)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func getTriviaText(number: String, type: String, completion: @escaping (String) -> Void)  {
        dataManager.numberDataForNumberAndType(number: number, type: type) { (response, error) in
            if let text = response?["text"] {
                let textAsString = "\(text!)"
                completion(textAsString)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! detailViewController
        if segue.identifier == "segue" {
            detailViewController.preResults = self.results
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayOfTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = arrayOfTypes[row]
        return title
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLayoutSubviews() {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: numberTextField.frame.size.height - width, width: numberTextField.frame.size.width, height: numberTextField.frame.size.height)
        
        border.borderWidth = width
        
        numberTextField.layer.addSublayer(border)
        numberTextField.layer.masksToBounds = true
        
    }
    
    @IBAction func goButton(_ sender: Any) {
        let selectedValue = arrayOfTypes[typePicker.selectedRow(inComponent: 0)]
        let numberText = numberTextField.text
        
        dataManager.checkIfValidURL(number: numberText!, type: selectedValue) { (success) in
            if success == true {
                self.getTriviaText(number: numberText!, type: selectedValue) { (textAsString) in
                    DispatchQueue.main.async {
                        self.resultsLabel.text = textAsString
                    }
                }
            } else if success == false {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Invalid Number!!!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                    self.resultsLabel.text = "Error"
                }
            }
        }

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

