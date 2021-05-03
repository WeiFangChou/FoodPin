//
//  MapViewController.swift
//  FoodPin
//
//  Created by WeiFangChou on 2021/4/27.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    @IBOutlet var MapView: MKMapView!
    
    var restaurant = RestaurantMO()
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .label
        

            let geoCoder = CLGeocoder()
            //取得位置
        geoCoder.geocodeAddressString(restaurant.location ?? "", completionHandler:{placemarks, error in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                if let placemarks = placemarks{
                    let placemark = placemarks[0]
                    //取得第一個地點標記
                    
                    let annotaion = MKPointAnnotation()
                    annotaion.title = self.restaurant.name
                    annotaion.subtitle = self.restaurant.type
                    
                    if let location = placemark.location{
                        annotaion.coordinate = location.coordinate
                        //顯示標記
                        self.MapView.showAnnotations([annotaion], animated: true)
                        self.MapView.selectAnnotation(annotaion, animated: true)
                        //移至標記位置
                    }
                }
            })
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyMaker"
        if annotation.isKind(of: MKUserLocation.self){
            return nil
        }
        var annotationView: MKMarkerAnnotationView? = MapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView?.glyphText = NSLocalizedString("I'm here", comment: "I'm here")
        annotationView?.markerTintColor = UIColor.orange
        
        return annotationView
    }
    
    
}
