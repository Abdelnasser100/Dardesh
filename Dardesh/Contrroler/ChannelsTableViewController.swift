//
//  ChannelsTableViewController.swift
//  Dardesh
//
//  Created by Abdelnasser on 30/10/2021.
//

import UIKit

class ChannelsTableViewController: UITableViewController {
    
    //MARK: - Vars
    
    var subscribedChannels :[Channel] = []
    var allChannels :[Channel] = []
    var myChannels :[Channel] = []
    
    //MARK: - OutLit
    
    @IBOutlet weak var channelSegmentOutlit: UISegmentedControl!
    
    
    //MARK: - Action
    
    @IBAction func chanelSegmentChange(_ sender: UISegmentedControl) {
        
        tableView.reloadData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        navigationItem.largeTitleDisplayMode = .always
        self.title = "Channel"
        
        downloadAllChannels()
        downloadUserChannels()
        downloadSubscribedChannels()
        
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if channelSegmentOutlit.selectedSegmentIndex == 0{
            return subscribedChannels.count
        }else if channelSegmentOutlit.selectedSegmentIndex == 1{
            return allChannels.count
        }else{
            return myChannels.count
        }
            
            }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! ChannelTableViewCell
        
        var channel = Channel()
        
        if channelSegmentOutlit.selectedSegmentIndex == 0{
            channel = subscribedChannels[indexPath.row]
        }else if channelSegmentOutlit.selectedSegmentIndex == 1{
            channel = allChannels[indexPath.row]
        }else{
            channel = myChannels[indexPath.row]
        }
        
        cell.configer(channel: channel)
        return cell
    }
    

    //MARK: - Download Channel
    
    private func downloadAllChannels(){
        
        FChannelListener.shared.downloadAllChannels { (allChannels) in
            self.allChannels = allChannels
            
            if self.channelSegmentOutlit.selectedSegmentIndex == 1{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    private func downloadSubscribedChannels(){
        
        FChannelListener.shared.downloadSubscribdeChannel { (subscribedChannels) in
            self.allChannels = subscribedChannels
            
            if self.channelSegmentOutlit.selectedSegmentIndex == 0{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func downloadUserChannels(){
        
        FChannelListener.shared.downloadAllChannels { (userChannels) in
            self.allChannels = userChannels
            
            if self.channelSegmentOutlit.selectedSegmentIndex == 2{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    //MARK: - UIScrollView Deleget
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl!.isRefreshing{
            self.downloadAllChannels()
            refreshControl?.endRefreshing()
        }
    }
    
    
    //MARK: - Delegete of tabelView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if channelSegmentOutlit.selectedSegmentIndex == 0{
            showChat(channel: subscribedChannels[indexPath.row])
        }else if channelSegmentOutlit.selectedSegmentIndex == 1{
            showFollowChannelView(channel: allChannels[indexPath.row])
        }else{
            showEditChannelView(channel: myChannels[indexPath.row])
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if channelSegmentOutlit.selectedSegmentIndex == 1 || channelSegmentOutlit.selectedSegmentIndex == 2{
            return false
        }else{
            return subscribedChannels[indexPath.row].adminId != User.currentId
        }
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            var channelToUnFollow = subscribedChannels[indexPath.row]
            subscribedChannels.remove(at: indexPath.row)
            
            if let index = channelToUnFollow.memberIds.firstIndex(of: User.currentId){
                channelToUnFollow.memberIds.remove(at: index)
            }
            
            FChannelListener.shared.saveChannel(channelToUnFollow)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    //MARK: - Navagation
    
    private func showEditChannelView(channel:Channel){
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "saveChannel")as! AddChannelTableViewController
        vc.channelToEdit = channel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func showFollowChannelView(channel:Channel){
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "channelFollow")as! ChannelFollwingTableViewController
        vc.channel = channel
        vc.delegete = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func showChat(channel:Channel){
        let vc = ChannelMessageViewController(channel: channel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension ChannelsTableViewController:ChannelFollowTabelViewControllerDelegete{
    func didClickFollow() {
        self.downloadAllChannels()
    }
    
    
}
