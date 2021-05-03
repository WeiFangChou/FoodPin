//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by WeiFangChou on 2021/4/29.
//

import UIKit
import CoreData

class ReviewViewController: UIViewController {
    
    @IBOutlet var backgroundImage: UIImageView!
    var restaurant : RestaurantMO!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let restaurantImage = restaurant.image{
            backgroundImage.image = UIImage(data: restaurantImage as Data)
        }
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImage.addSubview(blurEffectView)
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)

        for rateButton in rateButtons{
            rateButton.transform = moveRightTransform
            rateButton.alpha = 0
        }
    }
    private func alphaAnimate() {
        UIView.animate(withDuration: 0.4,delay: 0.1,options: [],animations:{
            self.rateButtons[0].alpha = 1.0
        },completion: nil)
        UIView.animate(withDuration: 0.4,delay: 0.15,options: [],animations:{
            self.rateButtons[1].alpha = 1.0
        },completion: nil)
        UIView.animate(withDuration: 0.4,delay: 0.2,options: [],animations:{
            self.rateButtons[2].alpha = 1.0
        },completion: nil)
        UIView.animate(withDuration: 0.4,delay: 0.25,options: [],animations:{
            self.rateButtons[3].alpha = 1.0
        },completion: nil)
        UIView.animate(withDuration: 0.4,delay: 0.3,options: [],animations:{
            self.rateButtons[4].alpha = 1.0
        },completion: nil)
}
    private func slideinAnimate(){
        for rateButton in 0...4{
            UIView.animate(withDuration: 0.4,delay: 0.1 + (0.05 * Double(rateButton)),options: [],animations:{
                self.rateButtons[rateButton].alpha = 1.0
                self.rateButtons[rateButton].transform = .identity
            },completion: nil)
        }
}
    
    override func viewWillAppear(_ animated: Bool) {
        //alphaAnimate()
        slideinAnimate()
    }
    @IBAction func close(segue: UIStoryboardSegue){
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var rateButtons :[UIButton]!



}
