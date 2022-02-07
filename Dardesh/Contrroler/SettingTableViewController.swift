//
//  SettingTableViewController.swift
//  Dardesh
//
//  Created by Abdelnasser on 01/10/2021.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    
    //MARK: - OutLit
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        
        showInfo()
        
    }

    //MARK: - Action
    
    @IBAction func tellFriendBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func termsAndCondetionBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func logOutBtn(_ sender: UIButton) {
        
        FUserListner.shared.logOutCurrentUser { (error) in
            if error == nil{
                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Login")
                DispatchQueue.main.async {
                    login.modalPresentationStyle = .fullScreen
                    self.present(login, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    
    //MARK: - tabelView Delgete
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "Color TabelView")
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 10.0
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
          performSegue(withIdentifier: "segueEditProfil", sender: self)
        }
    }
    
    //MARK: - Updata UI
   
   private func showInfo(){
    if let user = User.currentUser{
        userNameLabel.text = user.username
        statusLabel.text = user.status
         
        appVersionLabel.text = "App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
        if user.avatarLink != ""{
            FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
                self.avatarImage.image = avatarImage?.circleMasked
            }
        }
    }
        
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
