//
//  DetailViewController.swift
//  project2
//
//  Created by 최한여울 on 2019. 6. 22..
//  Copyright © 2019년 최한여울. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var textName: UILabel!
    @IBOutlet weak var textDate: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textDescription: UITextView!
    
    var selectedData: foodrecipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let recipeData = selectedData else {
            return
        }
        textName.text = recipeData.name
        textDate.text = recipeData.date
        textDescription.text = recipeData.descript
        var imageName = recipeData.imageName
        
        if (imageName != "") {
            let urlString = "http://condi.swu.ac.kr/student/T15/recipe/"
            imageName = urlString + imageName
            let url = URL(string: imageName)!
            if let imageData = try? Data(contentsOf: url) {
                imageView.image = UIImage(data: imageData)  
            }
        }
    }
    
    @IBAction func deleteInfo(_ sender: UIBarButtonItem) {
        let alert=UIAlertController(title:"정말 삭제 하시겠습니까?", message: "",preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .cancel, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/T15/recipe/deleteFavorite.php"
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            guard let foodno = self.selectedData?.food else { return }
            let restString: String = "food=" + foodno
            request.httpBody = restString.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return }
                guard let receivedData = responseData else { return }
                if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
            }
            task.resume()
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
