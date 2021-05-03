//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by WeiFangChou on 2021/5/1.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {
    
    var restaruants : [CKRecord] = []
    var spinner = UIActivityIndicatorView()
    private var imageCache = NSCache<CKRecord.ID, NSURL>()
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.style = UIActivityIndicatorView.Style.medium
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .white
        refreshControl?.tintColor = .gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: .valueChanged)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 150.0),spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        spinner.startAnimating()
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let customFont = UIFont(name: "FiraSans-Medium", size: 40.0){
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 255, green: 80, blue: 60), NSAttributedString.Key.font: customFont]
        }
        fetchRecordsFromCloud()


    }
    
    @objc func fetchRecordsFromCloud() {
        restaruants.removeAll()
        tableView.reloadData()
        //使用便利型API取得資料
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name","type","location","phone","description"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = {(record) -> Void in
            self.restaruants.append(record)
        }
        queryOperation.queryCompletionBlock = {(cursor, error) -> Void in
            if let error = error {
                print("Failed to get data from iCloud - \(error.localizedDescription)")
                return
            }
            print("Successfully retrieve the data from iCloud")
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
                if let refreshControl = self.refreshControl {
                    if refreshControl.isRefreshing{
                        refreshControl.endRefreshing()
                    }
                }
            }

        }
        publicDatabase.add(queryOperation)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaruants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell" ,for: indexPath) as! DiscoverTableViewCell
        
        let restaurant = restaruants[indexPath.row]
        cell.restaurantNameLabel.text = restaurant.object(forKey: "name") as? String
        cell.restaurantTypeLabel.text = restaurant.object(forKey: "type") as? String
        cell.restaurantphoneLabel.text = restaurant.object(forKey: "phone") as? String
        cell.restaurantLocationLabel.text = restaurant.object(forKey: "location") as? String
        cell.restaurantTextView.text = restaurant.object(forKey: "description") as? String
        
        cell.restaurantImage?.image = UIImage(named: "photo")
        
        if let imageFileURL = imageCache.object(forKey: restaurant.recordID) {
            print("Get image from cache")
            if let imageData = try? Data.init(contentsOf: imageFileURL as URL){
                cell.restaurantImage?.image = UIImage(data: imageData)
            }
        }else{
            let publicDatabase = CKContainer.default().publicCloudDatabase
            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
            fetchRecordsImageOperation.desiredKeys = ["image"]
            fetchRecordsImageOperation.queuePriority = .veryHigh
            
            fetchRecordsImageOperation.perRecordCompletionBlock = {(record, recordID ,error) -> Void in
                if let error = error {
                    print("Failed to get restaurant image: \(error.localizedDescription)")
                    return
                }
                if let restaurantRecord = record, let image = restaurantRecord.object(forKey: "image"), let imageAsset = image as? CKAsset {
                    if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                        DispatchQueue.main.async {
                            cell.restaurantImage?.image = UIImage(data: imageData)
                            cell.setNeedsLayout()
                        }
                        self.imageCache.setObject(imageAsset.fileURL! as NSURL, forKey: restaurant.recordID)
                    }
                    
                }
                
                
            }
            publicDatabase.add(fetchRecordsImageOperation)
        }
        
        
       
        return cell
    }


}
