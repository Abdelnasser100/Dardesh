//
//  ChatRoomTableViewCell.swift
//  Dardesh
//
//  Created by Abdelnasser on 06/10/2021.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var avtarLinkImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastMassegeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var unreadCounterView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        unreadCounterView.layer.cornerRadius = unreadCounterView.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configerCell(chatRoom:ChatRoom){
        userNameLabel.text = chatRoom.receiverName
        userNameLabel.minimumScaleFactor = 0.9
        
        lastMassegeLabel.text = chatRoom.lastMassege
        lastMassegeLabel.minimumScaleFactor = 2
        lastMassegeLabel.minimumScaleFactor = 0.9
        
        dateLabel.text = timeElapsed(chatRoom.date ?? Date())
        
        
        if chatRoom.unreadCounter != 0{
            self.dateLabel.text = "\(chatRoom.unreadCounter)"
            //self.unreadCounterView.isHidden = false
        }else{
            self.unreadCounterView.isHidden = true
        }
        
        
        if chatRoom.avatarLink != ""{
            FileStorage.downloadImage(imageUrl: chatRoom.avatarLink) { (avatarImage) in
                DispatchQueue.main.async {
                    self.avtarLinkImageView.image = avatarImage?.circleMasked
                }
               
            }
        }
        
    }
    
    

}
