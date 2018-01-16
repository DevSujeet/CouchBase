//
//  LoginViewController.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/9/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var usernameTextfeild: UITextField!{
        didSet{
            setLoginTextfield(textField: usernameTextfeild, withText: "Email")
            usernameTextfeild.text = "test@email.com"
        }
    }
    
    @IBOutlet weak var passwordTextfield: UITextField!{
        didSet{
            setLoginTextfield(textField: passwordTextfield, withText: "Password")
            passwordTextfield.text = "test"
            passwordTextfield.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.backgroundColor = UIColor.lightGray
            loginButton.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var forgotPasswordButton: UIButton!{
        didSet{
            
        }
    }
    
    //MARK:- IBOutlets
    private var loginService:AuthenticatorProtocol?
    
    private func setLoginTextfield(textField:UITextField, withText text:String){
        let placeHolderTextColor = UIColor.lightGray
        let placeHolderTextFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        let attributedString = NSAttributedString.init(text: text, color: placeHolderTextColor, font: placeHolderTextFont)
        textField.attributedPlaceholder = attributedString
        
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        var username = usernameTextfeild.text ?? ""
        username = username.trimmingCharacters(in: CharacterSet.whitespaces)
        
        var password = passwordTextfield.text ?? ""
        password = password.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if username.isEmpty || password.isEmpty {
            Ui.showMessageDialog(onController: self, withTitle: "Error",
                                 withMessage: "Username or password cannot be empty")
            return
        }
        
        loginService = AuthenticatorFactory().getAuthenticator(forType: .service)
        loginService!.delegate = self
        loginService!.authenticate(user: username, withPassword: password)
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppStyleGuide.loginScreenBGColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController:AuthenticatorDelegate {
    
    func didFinishAuthenticating(with status: Bool, withParams: [String : String]) {
        //move to next screen.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(withIdentifier: "loginNavController") as? UINavigationController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = mainController
    }
    
    
}
