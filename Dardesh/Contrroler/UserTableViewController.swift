//
//  UserTableViewController.swift
//  Dardesh
//
//  Created by Abdelnasser on 03/10/2021.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var allUser:[User] = []
    
    var filteredUser :[User] = []
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
      // allUser = [User.currentUser!]
        
      // createDummyUsers()

        downLoadAllUserFromFireStore()


        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        definesPresentationContext = true
        self.searchController.searchResultsUpdater = self


        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl
    }
    
    
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if self.refreshControl!.isRefreshing{
            self.downLoadAllUserFromFireStore()
            self.refreshControl!.endRefreshing()
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "Color TabelView")
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return searchController.isActive ? filteredUser.count : allUser.count
     
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as!UserTableViewCell
      
        let user = searchController.isActive ? filteredUser[indexPath.row]: allUser[indexPath.row]
        cell.configureCell(user: user)

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = searchController.isActive ? filteredUser[indexPath.row]:allUser[indexPath.row]
        
        showUserProfile(user)
        
    }
    
    
    //MARK: - Download AllUser From FireStore


    private func downLoadAllUserFromFireStore(){
        FUserListner.shared.downloadAllUsersFromFireStore { (allUsers) in
            self.allUser = allUsers
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }


    //MARK: - Navagation Controller

    private func showUserProfile(_ user:User){
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Profil")as!ProfilTableViewController
        vc.user = user
        
        navigationController?.pushViewController(vc, animated: true)

        
    }

    
    
    

}


extension UserTableViewController :UISearchResultsUpdating{
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredUser = allUser.filter({ (user) -> Bool in
            return user.username.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        tableView.reloadData()
    }
    
    
}
