//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by WeiFangChou on 2021/4/26.
//

import UIKit
import CoreData

class RestaurantDetailViewController: UIViewController {

    @IBOutlet var restaurantDetailTableView:UITableView!
    @IBOutlet var restaurandHeaderView:RestaurantDetailHeaderView!
    var restaurant = RestaurantMO()
    
    //MARK: - ViewControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.hidesBarsOnSwipe = false
        
        restaurantDetailTableView.cellLayoutMarginsFollowReadableWidth = true
        
        restaurantDetailTableView.delegate = self
        restaurantDetailTableView.dataSource = self
        restaurantDetailTableView.separatorStyle = .none
        restaurandHeaderView.nameLabel.text = restaurant.name
        restaurandHeaderView.typeLabel.text = restaurant.type
        restaurandHeaderView.typeLabel.layer.cornerRadius = 15
        restaurandHeaderView.typeLabel.layer.masksToBounds = true
        restaurandHeaderView.heartImageView.isHidden = restaurant.isVisited ? false : true
        restaurandHeaderView.heartImageView.image = UIImage(systemName: "heart.fill")?.withTintColor(.red)
        if let restaurantImage = restaurant.image{
            restaurandHeaderView.headerImageVIew.image = UIImage(data: restaurantImage as Data)
        }
        if let restaurantRating = restaurant.rating{
            restaurandHeaderView.ratingImageView.image = UIImage(named: restaurantRating)
        }
        
        
        restaurantDetailTableView.contentInsetAdjustmentBehavior = .never
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMaps"{
            let desinationController = segue.destination as! MapViewController
            desinationController.restaurant = restaurant
        }else if segue.identifier == "showReview"{
            let desinationController = segue.destination as! ReviewViewController
            desinationController.restaurant = restaurant
        }
    }
    @IBAction func rateRestaurant(segue:UIStoryboardSegue){
        dismiss(animated: true, completion: {
            
            if let rating = segue.identifier{
                self.restaurant.rating = rating
                self.restaurandHeaderView.ratingImageView.image = UIImage(named: rating)
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                    appDelegate.saveContext()
                }
                let scaleTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.restaurandHeaderView.ratingImageView.transform = scaleTransform
                self.restaurandHeaderView.ratingImageView.alpha = 0
                
                UIView.animate(withDuration: 0.4,delay: 0,usingSpringWithDamping: 0.3 ,initialSpringVelocity: 0.7,options: [] , animations: {
                    self.restaurandHeaderView.ratingImageView.transform = .identity
                    self.restaurandHeaderView.ratingImageView.alpha = 1.0
                },completion: nil)
            }
        })
    }

    // MARK: - Navigation
}
extension RestaurantDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            //Phone
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: restaurantDetailiconCell.self), for: indexPath) as! restaurantDetailiconCell
            cell.restaurantLabel.text = restaurant.phone
            cell.restaurantIconImage.image = UIImage(systemName: "phone")?.withTintColor(.gray,renderingMode: .alwaysOriginal)
            return cell
        case 1:
            //Location
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: restaurantDetailiconCell.self), for: indexPath) as! restaurantDetailiconCell
            cell.restaurantLabel.text = restaurant.location
            
            cell.restaurantIconImage.image = UIImage(systemName: "location")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            return cell
        case 2:
            //Description
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: restaurantDetailDescriptionCell.self), for: indexPath) as! restaurantDetailDescriptionCell
            cell.restaurantDetailDescriptionLabel.text = restaurant.summary
            cell.restaurantDetailDescriptionImage.image = UIImage(systemName: "note.text")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            
            return cell
        case 3:
            //Maps Label
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: restaurantDetailiconCell.self), for: indexPath) as! restaurantDetailiconCell
            cell.restaurantLabel.text = NSLocalizedString("HOW TO GET THERE ?", comment: "HOW TO GET THERE ?")
            cell.restaurantIconImage.image = UIImage(systemName: "map.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            
            return cell
        case 4:
            //MapsKit
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapsCell.self), for: indexPath) as! RestaurantDetailMapsCell
            if let restaurantLocation = restaurant.location{
                cell.configure(location: restaurantLocation)
            }
            
            return cell
        default:
            //Default
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: restaurantDetailDescriptionCell.self), for: indexPath) as! restaurantDetailDescriptionCell
            cell.restaurantDetailDescriptionLabel.text = NSLocalizedString("Error ,Failed get data....", comment: "Error ,Failed get data....")
            cell.restaurantDetailDescriptionImage.image = UIImage(systemName: "xmark.octagon.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
//            fatalError("Failed to instantiate the table view cell for detail view Controller")
            return cell
        }
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
}
