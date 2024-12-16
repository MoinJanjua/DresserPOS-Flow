//
//  WelcomeViewController.swift
//  DresserPOS Flow
//
//  Created by Unique Consulting Firm on 15/12/2024.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var startbtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorner(button: startbtn)
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func LetStartButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
       // self.tabBarController?.selectedIndex = 3
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }

}
