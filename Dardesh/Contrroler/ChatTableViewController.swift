//
//  ChatTableViewController.swift
//  Dardesh
//
//  Created by Abdelnasser on 06/10/2021.
//

import UIKit

class ChatTableViewController: UITableViewController {

    var allChatRooms:[ChatRoom] = []
    var filterChatRooms:[ChatRoom] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        downloadChatRooms()

        
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        definesPresentationContext = true
        self.searchController.searchResultsUpdater = self
       
    }
    
    //MARK: - Action
    
    @IBAction func composeBtn(_ sender: UIBarButtonItem) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "userView")as! UserTableViewController

        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  searchController.isActive ? filterChatRooms.count : allChatRooms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as!ChatRoomTableViewCell
        
//        let chatRoom = ChatRoom(id: "123", chatRoomId: "123", senderId: "123", senderName: "Mohamed", receiverName: "Ali", receiverId: "123", data: Date(), memberIds: [""], lastMassege: "Hello Ali i mis you  to meet you", unreadCounter: 1, avatarLink: "")

        cell.configerCell(chatRoom:searchController.isActive ?filterChatRooms[indexPath.row] : allChatRooms[indexPath.row])

        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatRoomObject = searchController.isActive ? filterChatRooms[indexPath.row]:allChatRooms[indexPath.row]
        
        goToMSG(chatRoom:chatRoomObject)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let chatRoom = searchController.isActive ? filterChatRooms[indexPath.row] : allChatRooms[indexPath.row]
            
            FChatRoomLisntener.shared.deleteChatRoom(chatRoom)
            
            searchController.isActive ? self.filterChatRooms.remove(at: indexPath.row):allChatRooms.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    
    private func downloadChatRooms(){
        FChatRoomLisntener.shared.downloadChatRoom { (allFBChatRooms) in
            self.allChatRooms = allFBChatRooms
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    func goToMSG(chatRoom:ChatRoom){
        
        //TODO:- to make sure that both users have chatRooms
        
        restartChat(chatRoomId: chatRoom.chatRoomId, memberIds: chatRoom.memberIds)
        
        let privateMSGView = MSGViewController(chatId: chatRoom.chatRoomId, recipientId: chatRoom.receiverId, recipientName: chatRoom.receiverName)
        
        navigationController?.pushViewController(privateMSGView, animated: true)
    }
    

}


extension ChatTableViewController :UISearchResultsUpdating{
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterChatRooms = allChatRooms.filter({ (chatRoom) -> Bool in
            return chatRoom.receiverName.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        tableView.reloadData()
    }
    
    
}
