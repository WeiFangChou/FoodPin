//
//  RestaurantDetailMapsCell.swift
//  FoodPin
//
//  Created by WeiFangChou on 2021/4/27.
//

import UIKit
import MapKit

class RestaurantDetailMapsCell: UITableViewCell {

    @IBOutlet var restaurantDetailMapKitView: MKMapView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
    }
    func configure(location: String){
        let geoCoder = CLGeocoder()
        //取得位置
        geoCoder.geocodeAddressString(location, completionHandler:{placemarks, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let placemarks = placemarks{
                let placemark = placemarks[0]
                //取得第一個地點標記
                
                let annotaion = MKPointAnnotation()
                
                if let location = placemark.location{
                    annotaion.coordinate = location.coordinate
                    //顯示標記
                    self.restaurantDetailMapKitView.addAnnotation(annotaion)
                    
                    let region = MKCoordinateRegion(center: annotaion.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                    //縮放程度 250ｍ半徑
                    self.restaurantDetailMapKitView.setRegion(region, animated: true)
                    //移至標記位置
                }
            }
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
