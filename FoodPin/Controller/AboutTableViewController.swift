//
//  AboutTableViewController.swift
//  FoodPin
//
//  Created by WeiFangChou on 2021/5/1.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    var sectionTitle = [NSLocalizedString("Feedback",comment: "Feedback"),NSLocalizedString("Follow Us",comment: "Follow Us")]
    var sectionContent = [[(image: "store",text:NSLocalizedString("Rate us on App Store",comment: "Rate us on App Store"),link:"https://www.apple.com"),
                           (image: "chat",text:NSLocalizedString("Tell us your feedback",comment: "Tell us your feedback"),link:"https://weifangchou.github.io")],
                          [(image: "twitter",text:NSLocalizedString("Twitter",comment: "Twitter"),link:"https://twitter.com/"),
                           (image: "facebook",text:NSLocalizedString("Facebook",comment: "Facebook"),link:"https://www.facebook.com"),
                           (image: "instagram",text:NSLocalizedString("Instagram",comment:"Instagram") ,link:"https://www.instagram.com/chouweifang")]]
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "FiraSans-Medium", size: 40.0){
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 255, green: 80, blue: 60), NSAttributedString.Key.font: customFont]
        }
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionTitle.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionContent[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell",for: indexPath) as! AboutTableViewCell
        let cellData = sectionContent[indexPath.section][indexPath.row]
        cell.aboutLabel.text = cellData.text
        cell.aboutImage.image = UIImage(named: cellData.image)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = sectionContent[indexPath.section][indexPath.row].link
        switch indexPath.section {
        //Leave us Feedback區塊
        case 0:
            if indexPath.row == 0{
                if let url = URL(string: link){
                    UIApplication.shared.openURL(url)
                }
            }else if indexPath.row == 1{
                performSegue(withIdentifier: "showWebView", sender: self)
            }
        case 1:
            if let url = URL(string: link) {
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebView" {
            if let destinationController = segue.destination as? WebViewController,let indexPath = tableView.indexPathForSelectedRow{
                destinationController.targetURL = sectionContent[indexPath.section][indexPath.row].link
            }
        }
    }
    

}
