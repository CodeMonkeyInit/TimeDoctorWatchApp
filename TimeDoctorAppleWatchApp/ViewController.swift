//
//  ViewController.swift
//  TimeDoctorAppleWatchApp
//
//  Created by Денис Кулиев on 14.08.2018.
//  Copyright © 2018 Денис Кулиев. All rights reserved.
//

import UIKit


extension String {
    var isEmptyOrWhiteSpace: Bool {
        if(self.isEmpty){
            return true;
        }
        
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var accessTokenTextField: UITextField!
    
    @IBOutlet weak var hoursToWorkField: UITextField!
    
    let userDefaults = UserDefaults.standard
    
    let hoursToWorkName = "HoursToWork"
    let accessTokenName = "AccessToken"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a
        
        let hoursToWork =  userDefaults.integer(forKey: hoursToWorkName)
        let accessToken = userDefaults.string(forKey: accessTokenName)
        
        accessTokenTextField.text = accessToken
        hoursToWorkField.text = String.init(hoursToWork)
        
        accessTokenTextField.addTarget(self, action: #selector(ViewController.accessTokenValueChanged(_:)), for: .editingChanged)
        hoursToWorkField.addTarget(self, action: #selector(ViewController.hoursToWorkValueChanged(_:)), for: .editingChanged)
    }
    
    func updateTextFieldValueInUserDefaults(key: String, textField: UITextField){
        guard let text = textField.text else {
            return
        }
        
        if(!text.trimmingCharacters(in: .whitespaces).isEmpty){
            return
        }
        
        userDefaults.set(text, forKey: key)
    }
    
    @objc func hoursToWorkValueChanged(_ textField: UITextField){
        updateTextFieldValueInUserDefaults(key: self.hoursToWorkName, textField: textField)
    }
    
    @objc func accessTokenValueChanged(_ textField: UITextField){
        updateTextFieldValueInUserDefaults(key: self.accessTokenName, textField: textField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

