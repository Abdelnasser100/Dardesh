//
//  UserTableViewCell.swift
//  Dardesh
//
//  Created by Abdelnasser on 03/10/2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    //MARK: - OutLit
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(user:User){
        
        userNameLabel.text = user.username
        statusLabel.text = user.status
        
        if user.avatarLink != ""{
            FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
                self.avatarImage.image = avatarImage?.circleMasked
            }
        }else{
            self.avatarImage.image = UIImage(named: "icon")
        }
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
