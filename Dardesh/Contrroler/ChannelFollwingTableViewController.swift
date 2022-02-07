//
//  ChannelFollwingTableViewController.swift
//  Dardesh
//
//  Created by Abdelnasser on 02/11/2021.
//

import UIKit

protocol ChannelFollowTabelViewControllerDelegete {
    func didClickFollow()
}

class ChannelFollwingTableViewController: UITableViewController {
    
    //MARK: - Vars
    
    var channel:Channel!
    var delegete : ChannelFollowTabelViewControllerDelegete?
    
    //MARK: - OutLit
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var aboutTextField: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        showChannelData()
        configureRightBarButton()
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
    }

    
    //MARK: - Show Channel Data
    
    func showChannelData (){
        
        self.title = channel.name
        nameLabel.text = channel.name
        aboutTextField.text = channel.aboutChannel
        memberLabel.text = "\(channel.memberIds.count) members"
        
        if channel.avatarLink != nil{
            FileStorage.downloadImage(imageUrl: channel.avatarLink) { (avatarImage) in
                DispatchQueue.main.async {
                    self.avatarImageView.image = avatarImage != nil ? avatarImage?.circleMasked : UIImage(named: "icon")
                }
            }
        }else{
            self.avatarImageView.image = UIImage(named: "icon")
        }
    }

    
    //MARK: - Rigth Button Item
    
    private func configureRightBarButton(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(followChannel))
        
    }
    
    @objc func followChannel(){
        channel.memberIds.append(User.currentId)
        FChannelListener.shared.saveChannel(channel)
        delegete?.didClickFollow()
        self.navigationController?.popViewController(animated: true)
    }
}
