//
//  AddChannelTableViewController.swift
//  Dardesh
//
//  Created by Abdelnasser on 31/10/2021.
//

import UIKit
import Gallery
import ProgressHUD

class AddChannelTableViewController: UITableViewController {
    
    //MARK: - var
    
    var channelId = UUID().uuidString
    var gallery : GalleryController!
    var avatarLink = ""
    var tapGesture = UITapGestureRecognizer()
    
    var channelToEdit:Channel?
    
    //MARK: - outLit
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var aboutTextView: UITextView!
    
    //MARK: - Action
    
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
        
        if nameTextField.text != ""{
            saveChannel()
        }else{
            ProgressHUD.showError("Channel name is required")
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        navigationItem.largeTitleDisplayMode = .never
        
        configureGestures()
        configerLeftBarButton()
        
        if channelToEdit != nil{
            configureEditingView()
        }

    }
    
    
    @objc func avatarImageTap(){
        showGallery()
    }
    
    @objc func backButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureGestures(){
        
        tapGesture.addTarget(self, action: #selector(avatarImageTap))
        avatarImage.isUserInteractionEnabled = true
        avatarImage.addGestureRecognizer(tapGesture)
    }

    private func configerLeftBarButton(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonPressed))
    }
    
    
    
    //MARK: - Gallery
    
    private func showGallery(){
        self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [.imageTab,.cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        self.present(gallery, animated: true, completion: nil)
    }
    
    
    //MARK: - Avatar
    
    private func uploadeAvatarImage(_ image:UIImage){
        
        let fileDirectoryt = "Avatar/" + "_\(channelId)" + ".jpg"
        
        FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.7)!as NSData, fileName: self.channelId)
        FileStorage.uploadImage(image, directory: fileDirectoryt) { (avatarLink) in
            self.avatarLink = avatarLink ?? ""
        }
        
    }
    
    
    //MARK: - save Channel
    
    private func saveChannel(){
        let channel = Channel(id: channelId, name: nameTextField.text!, adminId: User.currentId, memberIds: [User.currentId], avatarLink: avatarLink, aboutChannel: aboutTextView.text)
        
        FChannelListener.shared.saveChannel(channel)
        
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - configure edit View
    
    private func configureEditingView(){
        
        self.nameTextField.text = channelToEdit!.name
        self.channelId = channelToEdit!.id
        self.aboutTextView.text = channelToEdit!.aboutChannel
        self.avatarLink = channelToEdit!.avatarLink
        self.title = "Editing Channel"
        
        if channelToEdit?.avatarLink != nil{
            FileStorage.downloadImage(imageUrl: channelToEdit!.avatarLink) { (avatarImage) in
                DispatchQueue.main.async {
                    self.avatarImage.image = avatarImage?.circleMasked
                }
            }
        }else{
            self.avatarImage.image = UIImage(named: "icon")
        }
    }
    
}



extension AddChannelTableViewController:GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count>0{
            images.first?.resolve{ (icon) in
                if icon != nil{
                    self.uploadeAvatarImage(icon!)
                    self.avatarImage.image = icon!.circleMasked
                    
                }else{
                    ProgressHUD.showError("Could not select image")
                }
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
  
    
}
