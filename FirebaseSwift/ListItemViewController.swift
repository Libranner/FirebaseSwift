//
//  ListItemViewController.swift
//  FirebaseSwift
//
//  Created by Libranner Leonel Santos Espinal on 6/26/17.
//  Copyright © 2017 swiftdo. All rights reserved.
//

import UIKit
import Firebase
import FirebasePerformance

class ListItemViewController: UIViewController {

    var ref: DatabaseReference!
    var username = "Anonymus"

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemTextView: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        if let user = Auth.auth().currentUser {
            nameLabel.text = user.displayName
            username = user.displayName ?? "Anonymus"
            if let photo_url = user.photoURL {
                if let data = try? Data(contentsOf: photo_url) {
                    profileImageView.image = UIImage.init(data: data)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        let trace = Performance.startTrace(name: "test trace")
        itemTextView.resignFirstResponder()
        if let text = self.itemTextView.text, !text.isEmpty {
            let data = ["text" : text, "user_name" : username]
            sendData(data)
        }
        trace?.stop()
    }

    func sendData(_ data: [String: String]){
        ref.child("list").childByAutoId().setValue(data)
        itemTextView.text = ""
    }
}
