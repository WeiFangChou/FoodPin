//
//  WalkthroughViewController.swift
//  FoodPin
//
//  Created by WeiFangChou on 2021/4/30.
//

import UIKit

class WalkthroughViewController: UIViewController {
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton!{
        didSet{
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    @IBAction func nextButtonTapped(sender: UIButton) {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                walkthroughPageViewController?.forwardPage()
            case 2:
                UserDefaults.standard.setValue(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
        updateUI()
    }
    @IBOutlet var skipButton: UIButton!
    
    @IBAction func skipButtonTapped(sender: UIButton) {
        UserDefaults.standard.setValue(true, forKey: "hasViewedWalkthrough")
        creatQuckActions()
        dismiss(animated: true, completion: nil)
    }
    var walkthroughPageViewController: WalkthroughPageViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }
    
    func updateUI() {
    
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                nextButton.setTitle(NSLocalizedString("NEXT", comment: "NEXT"), for: .normal)
                skipButton.isHidden = false
            case 2:
                nextButton.setTitle(NSLocalizedString("GET STARTED", comment: "GET STARTED"), for: .normal)
                skipButton.isHidden = true
            default:
                break
            }
            pageControl.currentPage = index
        }
    
    }
    
    func creatQuckActions() {
        
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available{
            if let bundleIdentifier = Bundle.main.bundleIdentifier {
                let shortcutItem1 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenFavorites", localizedTitle: "Show Favorites",localizedSubtitle: nil,icon: UIApplicationShortcutIcon(templateImageName: "favorite-shortcut"),userInfo: nil)
                let shortcutItem2 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenDiscover", localizedTitle: "Discover Restaurants",localizedSubtitle: nil,icon: UIApplicationShortcutIcon(templateImageName: "favorite-shortcut"),userInfo: nil)
                let shortcutItem3 = UIApplicationShortcutItem(type: "\(bundleIdentifier).NewRestaurant", localizedTitle: "New Restaurant",localizedSubtitle: nil,icon: UIApplicationShortcutIcon(templateImageName: "favorite-shortcut"),userInfo: nil)
                UIApplication.shared.shortcutItems = [shortcutItem1,shortcutItem2,shortcutItem3]
            }
        }
        
    }
    
    
    



}

extension WalkthroughViewController: WalkthroughPageViewControllerDelegate {
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
}
