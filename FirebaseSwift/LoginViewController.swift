//
//  LoginViewController.swift
//  FirebaseSwift
//
//  Created by Libranner Leonel Santos Espinal on 6/26/17.
//  Copyright © 2017 swiftdo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController, LoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        loginButton.delegate = self
        loginButton.center = view.center

        view.addSubview(loginButton)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AccessToken.current != nil {
            self.performSegue(withIdentifier: "showMain", sender: self)
        }
    }

    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("logged out")
    }

    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(_, _, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                Auth.auth().signIn(with: credential) { (user, error) in
                    print(user!)
                    self.performSegue(withIdentifier: "showMain", sender: self)
                }
        }
    }

}
