//
//  EditProfilTableViewController.swift
//  Dardesh
//
//  Created by Abdelnasser on 02/10/2021.
//

import UIKit
import Gallery
import ProgressHUD

class EditProfilTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    var gallary : GalleryController!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        showInfo()
        
        configerTextField()
    }
    
    
  
    //MARK: - OutLit
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    //MARK: - Action
    
    
    @IBAction func editProfilBtn(_ sender: UIButton) {
        
        showImageGallary()
    }
    
    
    //MARK: - TableView Delget
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "Color TabelView")
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 || section == 1 ? 0.0 : 30.0
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0{
            performSegue(withIdentifier: "settingToStatus", sender: nil)
        }
    }
    
    private func showInfo(){
     if let user = User.currentUser{
         userNameTextField.text = user.username
         statusLabel.text = user.status
          
         if user.avatarLink != ""{
            FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
                self.avatarImage.image = avatarImage?.circleMasked
            }
         }
     }
         
     }
    
    
    
    
    
    //MARK: - Gallary
    
    private func showImageGallary(){
        
        self.gallary = GalleryController()
        self.gallary.delegate = self
        
        Config.tabsToShow = [.imageTab,.cameraTab ]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        self.present(gallary, animated: true, completion: nil)
        
    }
    
    
    
    
    //MARK: - Configer Text Field
    
    private func configerTextField(){
        userNameTextField.delegate = self
        userNameTextField.clearButtonMode = .whileEditing
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField{
            if textField.text != ""{
                if var user = User.currentUser{
                    user.username = textField.text!
                    saveUserLocally(user)
                    FUserListner.shared.saveUserToFireStore(user)
                }
            }
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    private func uploadAvatarImage(_ image:UIImage){
        let fileDirectory = "Avatars/" + "-\(User.currentId)" + ".jpg"
        
        FileStorage.uploadImage(image, directory: fileDirectory) { (avatarLink) in
            if var user = User.currentUser{
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FUserListner.shared.saveUserToFireStore(user)
            }
            
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.5)! as NSData, fileName: User.currentId)
        }
        
    }

}

extension EditProfilTableViewController:GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0{
            images.first?.resolve(completion: { (avatarImage) in
                if avatarImage != nil{
                    self.uploadAvatarImage(avatarImage!)
                    self.avatarImage.image = avatarImage
                }else{
                    ProgressHUD.showError("Could not select image")
                }
            })
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
