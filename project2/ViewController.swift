//
//  ViewController.swift
//  project2
//
//  Created by 최한여울 on 2019. 6. 21..
//  Copyright © 2019년 최한여울. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var UserID: UITextField!
    @IBOutlet weak var UserPassword: UITextField!
    @IBOutlet weak var labelStatus: UILabel!
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.UserID {
            textField.resignFirstResponder()
            self.UserPassword.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginPressed() {
        if UserID.text == "" {
            labelStatus.text = "ID를 입력하세요"; return;
        }
        if UserPassword.text == "" {
            labelStatus.text = "비밀번호를 입력하세요"; return;
        }
         let urlString: String = "http://condi.swu.ac.kr/student/T15/login/loginUser.php"
        
        guard let requestURL = URL(string: urlString) else {
            return
        }
        self.labelStatus.text = " "
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + UserID.text! + "&password=" + UserPassword.text!
        
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            
            do {
                let response = response as! HTTPURLResponse
                if !(200...299 ~= response.statusCode) {
                    print ("HTTP Error!")
                    return
                }
                guard let jsonData = try
                    JSONSerialization.jsonObject(with: receivedData, options:.allowFragments) as? [String: Any]
                    else {
                        print("JSON Serialization Error!")
                        return
                }
                guard let success = jsonData["success"] as? String else {
                    print("Error: PHP failure(success)")
                    return
                }
                if success == "YES" {
                    if let name = jsonData["name"] as? String {
                        DispatchQueue.main.async {
                            self.labelStatus.text = name + "님 안녕하세요?"
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.ID = self.UserID.text
                            appDelegate.userName = name
                            
                            self.performSegue(withIdentifier: "toLoginSuccess", sender: self)
                        }
                    }
                } else {
                    if let errMessage = jsonData["error"] as? String {
                        DispatchQueue.main.async {
                            self.labelStatus.text = errMessage  }
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
}

