//
//  ChannelTableViewCell.swift
//  Dardesh
//
//  Created by Abdelnasser on 30/10/2021.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {

    //MARK: - outLit
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var aboutChannel: UILabel!
    @IBOutlet weak var memberCounterLabel: UILabel!
    @IBOutlet weak var lastMessageDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configer (channel:Channel){
        
        channelName.text = channel.name
        aboutChannel.text = channel.aboutChannel
        memberCounterLabel.text = "\(channel.memberIds.count) members"
        lastMessageDateLabel.text = timeElapsed(channel.lastMessageDate ?? Date())
        
        if channel.avatarLink != ""{
            FileStorage.downloadImage(imageUrl: channel.avatarLink) { (avatarImage) in
                DispatchQueue.main.async {
                    self.avatarImageView.image = avatarImage != nil ? avatarImage?.circleMasked : UIImage(named: "icon")
                }
            }
        }else{
            self.avatarImageView.image = UIImage(named: "icon")
        }
    }
    
}
