//
//  ViewController.swift
//  Dardesh
//
//  Created by Abdelnasser on 28/09/2021.
//

import UIKit
import  ProgressHUD

class LoginViewController: UIViewController {

    var isLogin:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundTap()

        emailLabel.text = ""
        passwordLabel.text = ""
        confermpasswordLabel.text = ""
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confermPasswordTextField.delegate = self
       
    }
    
//MARK: - OutLet
    
    @IBOutlet weak var regesterLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confermpasswordLabel: UILabel!
    @IBOutlet weak var haveAnAccountLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confermPasswordTextField: UITextField!
    
    @IBOutlet weak var regesterBtnOutlet: UIButton!
    @IBOutlet weak var resendEmailOutlet: UIButton!
    @IBOutlet weak var LoginBtnOutlet: UIButton!
    @IBOutlet weak var forgetPasswordOutlet: UIButton!
    
    
    
    @IBAction func forgerPasswordBtn(_ sender: UIButton) {
        if isDatainputFor(mode: "forgetPassword"){
            print("All data input correct")
            
            forgetPassword()
            
        }else{
            ProgressHUD.showError("all field are requird")
            
        }
        
    }
    
    
    @IBAction func resendEmailBtn(_ sender: UIButton) {

        resendVerificationEmail()
    }
    
    
    //MARK: - Regester
    
    @IBAction func registerBtn(_ sender: UIButton) {
        
        if isDatainputFor(mode: isLogin ? "login" : "register"){
             isLogin ? loginUser() :regesterUser()
            
         
        }else{
           ProgressHUD.showError("All field are required")
        }
        
        
    }
    
    
    //MARK: - Login
    
    @IBAction func loginBtn(_ sender: UIButton) {
        
        updateUiMode(mode: isLogin)
        
    }
    
    
    private func updateUiMode(mode:Bool){
        
        if !mode{
            regesterLabel.text = "Log In"
            confermpasswordLabel.isHidden = true
            confermPasswordTextField.isHidden = true
            regesterBtnOutlet.setTitle("Log In", for: .normal)
            LoginBtnOutlet.setTitle("Regester", for: .normal)
            resendEmailOutlet.isHidden = true
            haveAnAccountLabel.text = "New here?"
            forgetPasswordOutlet.isHidden = false
            
        }else{
            regesterLabel.text = "Regester"
            confermpasswordLabel.isHidden = false
            confermPasswordTextField.isHidden = false
            regesterBtnOutlet.setTitle("Regester", for: .normal)
            LoginBtnOutlet.setTitle("Log In", for: .normal)
            resendEmailOutlet.isHidden = false
            haveAnAccountLabel.text = "have an account ?"
            forgetPasswordOutlet.isHidden = false
            
        }
        isLogin.toggle()
    }
    
    
    //MARK: - Utilities
    
    private func isDatainputFor(mode:String) ->Bool{
        
        switch mode {
        case "login":
            return emailTextField.text != "" && passwordTextField.text != ""
        case "register":
            return emailTextField.text != "" && passwordTextField.text != "" && confermPasswordTextField.text != ""
        case "forgetPassword":
            return emailTextField.text != ""
        default:
            return false
        }
    }
    
    
    //MARK: - tap Qesture Recognized
    
    private func setupBackgroundTap(){
        
        let tapQesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapQesture)
    }
    @objc func hideKeyboard(){
        view.endEditing(false)
    }
    
    
    //MARK: - Regester User
    
    private func regesterUser(){
        if passwordTextField.text! == confermPasswordTextField.text!{
            FUserListner.shared.regesterUserwith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
                if error == nil {
                    ProgressHUD.showSuccess("verifiction email send,please verfy your email and confirm the regester" )
                }else{
                    ProgressHUD.showError(error!.localizedDescription)
                }
            }
        }
    }
    
    
    //MARK: - Resend Email Verification
    
    private func resendVerificationEmail(){
        FUserListner.shared.resendVerificationEmailWith(email: emailTextField.text!) { (error) in
            if error == nil{
                ProgressHUD.showSuccess("Verfication email send succesfuly")
            }else{
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    //MARK: - login User
    
    private func loginUser(){
        
        FUserListner.shared.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            if error == nil{
                if isEmailVerified{
                    
                    self.goToApp()
                    
                }else{
                    ProgressHUD.showFailed("Please check your email and verfiy your regestretion")
                }
            }else{
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    
    //MARK: - Navagation
    
    private func goToApp(){
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "tabBar")as! UITabBarController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Forget Password
    
    private func forgetPassword(){
        FUserListner.shared.resetPasswordFor(email: emailTextField.text!) { (error) in
            if error == nil{
                ProgressHUD.showSuccess("Reset password email has been send")
            }else{
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
}

extension LoginViewController:UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        emailLabel.text = emailTextField.hasText ? "Email" : ""
        passwordLabel.text = passwordTextField.hasText ? "Password" : ""
        confermpasswordLabel.text = confermPasswordTextField.hasText ? "Conferm Password" : ""
    }
    
}
