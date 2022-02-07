//
//  ProfilTableViewController.swift
//  Dardesh
//
//  Created by Abdelnasser on 05/10/2021.
//

import UIKit

class ProfilTableViewController: UITableViewController {
    
    
    var user : User?
    
    //MARK: - Outlit
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        setup()
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "Color TabelView")
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 5.0
    }
    
    
    // MARK: - Table view data source

   

    private func setup(){
        if user != nil{
            self.title = user?.username
            userNameLabel.text = user?.username
            statusLabel.text = user?.status
            
            if user!.avatarLink != ""{
                FileStorage.downloadImage(imageUrl: user!.avatarLink) { [self] (avatarImage) in
                    self.avatarImageView.image = avatarImage?.circleMasked
                }
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let chatId = startChat(sender: User.currentUser!, receiver: user!)
            
            let privateMSGView = MSGViewController(chatId: chatId, recipientId: user!.id, recipientName: user!.username)
            
            navigationController?.pushViewController(privateMSGView, animated: true)
        }
    }

}
