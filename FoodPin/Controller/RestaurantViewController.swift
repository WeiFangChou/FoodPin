//
//  ViewController.swift
//  FoodPin
//
//  Created by WeiFangChou on 2021/4/26.
//

import UIKit
import CoreData


class RestaurantViewController: UIViewController ,NSFetchedResultsControllerDelegate{

    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    var restaurants: [RestaurantMO] = []
    var searchResults: [RestaurantMO] = []
    var restaurantIsVisited = Array(repeating: false, count: 21)
    var searchController: UISearchController!
    @IBOutlet var restaurantTableView: UITableView!
    @IBOutlet var emptyRestaurantImageView: UIView!
    //MARK: - Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do{
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects{
                    restaurants = fetchedObjects
                }
            }catch{
                print(error.localizedDescription)
            }
        }
        searchController = UISearchController(searchResultsController: nil)
        restaurantTableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Restaurant..."
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = UIColor(red: 231, green: 76, blue: 60)
        restaurantTableView.backgroundView = emptyRestaurantImageView
        restaurantTableView.backgroundView?.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "FiraSans-Medium", size: 40.0){
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 255, green: 80, blue: 60), NSAttributedString.Key.font: customFont]
        }
        navigationController?.hidesBarsOnSwipe = true
        restaurantTableView.cellLayoutMarginsFollowReadableWidth = true
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController{
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }
    
    func filterContent(for searchText: String) {
        searchResults = restaurants.filter({ (restaurant) -> Bool in
            if let name = restaurant.name,let location = restaurant.location{
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = restaurantTableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
                //True: 原陣列 False: 搜尋的陣列
                destinationController.hidesBottomBarWhenPushed = true
                //隱藏下方Tab bar
                
            }
        }
    }
    @IBAction func unwindToHome(segue:UIStoryboardSegue){
        dismiss(animated: true, completion: nil)
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //當NSFetchedResultController 準備開始處理內容變更時會被呼叫的
        restaurantTableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        restaurantTableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath{
                restaurantTableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath{
                restaurantTableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath{
                restaurantTableView.reloadRows(at: [indexPath], with: .fade)
                
            }
        default:
            restaurantTableView.reloadData()
        }
        if let fetchObjects = controller.fetchedObjects{
            restaurants = fetchObjects as! [RestaurantMO]
        }
    }

}
//MARK: - UITableViewDelegate/DataSource
extension RestaurantViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if restaurants.count > 0 {
            restaurantTableView.backgroundView?.isHidden = true
            restaurantTableView.separatorStyle = .singleLine
        }else{
            restaurantTableView.backgroundView?.isHidden = false
            restaurantTableView.separatorStyle = .none
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive{
            return searchResults.count
        }else{
            return restaurants.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath) as! RestaurantTableViewCell
        //判斷是從搜尋結果還是原來的陣列
        let restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        cell.nameLabel.text = restaurants[indexPath.row].name
        if let restaurantImage = self.restaurants[indexPath.row].image{
            cell.thumbnailImageView.image = UIImage(data: restaurantImage as Data)
        }
        
        cell.locationLabel.text = restaurants[indexPath.row].location
        cell.typeLabel.text = restaurants[indexPath.row].type
        cell.heartImageView.isHidden = !restaurants[indexPath.row].isVisited
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionMenu = UIAlertController(title: NSLocalizedString("What do you want to do?", comment: "What do you want to do?"), message: nil, preferredStyle: .actionSheet)

        let cancelAlert = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
        let callActionHandler = {(action:UIAlertAction!) -> Void in
            let alertMessage = UIAlertController(title: NSLocalizedString("Service Unavailable", comment: "Service Unavailable"), message: NSLocalizedString("Sorry, the call feature is not available yet. Please retry later.", comment: "Sorry, the call feature is not available yet. Please retry later."), preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
        let checkInTitle = self.restaurantIsVisited[indexPath.row] ? NSLocalizedString("Undo Check in", comment: "Undo Check in") : NSLocalizedString("Check in", comment: "Check in")
        let checkInAction = UIAlertAction(title: checkInTitle, style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath) as? RestaurantTableViewCell
            
            cell?.heartImageView.isHidden = self.restaurantIsVisited[indexPath.row]
            self.restaurantIsVisited[indexPath.row] = self.restaurantIsVisited[indexPath.row] ? false : true
        })
        let callAction = UIAlertAction(title: NSLocalizedString("Call :", comment: "Call :") + "123-000-\(indexPath.row)", style: .default, handler: callActionHandler)
        optionMenu.addAction(callAction)
        optionMenu.addAction(checkInAction)
        optionMenu.addAction(cancelAlert)

        //present(optionMenu, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        
        print("Total items : \(restaurants.count)")
        for nums in restaurants{
            print(nums)
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){(action, sourceView,completionHandler) in

            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDelete =  self.fetchResultController.object(at: indexPath)
                context.delete(restaurantToDelete)
                appDelegate.saveContext()
            }
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor(red: 204, green: 51, blue: 51)
        deleteAction.image = UIImage(systemName: "trash.fill")
        let shareAction = UIContextualAction(style: .normal, title: "Share"){(action , sourceView, completionHandler) in
            let defaultText = NSLocalizedString("Just checking in at ", comment: "Just checking in at ") + self.restaurants[indexPath.row].name!
            let activityController : UIActivityViewController
            if let restaurantImage = self.restaurants[indexPath.row].image,let imageToshare = UIImage(data: restaurantImage as Data){
                
                activityController = UIActivityViewController(activityItems: [defaultText,restaurantImage], applicationActivities: nil)
                
            }else{
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            if let popoverController = activityController.popoverPresentationController{
                if let cell = self.restaurantTableView.cellForRow(at: indexPath){
                    popoverController.sourceRect = cell.bounds
                    popoverController.sourceView = cell
                }
            }
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        shareAction.backgroundColor = UIColor(red: 255, green: 204, blue: 102)
        shareAction.image = UIImage(systemName: "square.and.arrow.up.fill")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkInAction = UIContextualAction(style: .normal, title: NSLocalizedString("Check in", comment: "Check in")){(action , sourceView ,completionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as? RestaurantTableViewCell
            self.restaurants[indexPath.row].isVisited = self.restaurants[indexPath.row].isVisited ? false : true
            cell?.heartImageView.isHidden = self.restaurants[indexPath.row].isVisited ? false : true
            completionHandler(true)
        }
        checkInAction.backgroundColor = UIColor(red: 107, green: 142, blue: 35)
        checkInAction.image = self.restaurantIsVisited[indexPath.row] ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkInAction])
        
        return swipeConfiguration
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive{
            return false
        }else{
            return true
        }
    }

}

//MARK: - UISearchResultsUpdating
extension RestaurantViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterContent(for: searchText)
            restaurantTableView.reloadData()
        }
    }
    
    
    
    
}
