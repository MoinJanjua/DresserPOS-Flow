//
//  DashboardViewController.swift
//  DresserPOS Flow
//
//  Created by Unique Consulting Firm on 15/12/2024.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var totalsalesLb: UILabel!
    @IBOutlet weak var todayssalesLb: UILabel!

  
    var orderDetails: [ordersBooking] = []
    var type = [String]()
    var Imgs: [UIImage] = [UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "4")!]

    override func viewDidLoad() {
        super.viewDidLoad()
   
        type =  ["Client Records","Order Records","Sales Overview","Settings"]
        
        CollectionView.dataSource = self
        CollectionView.delegate = self
        CollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchOrdersDetails()
    }
    
    
    func fetchOrdersDetails()
    {
        if let savedData = UserDefaults.standard.array(forKey: "bookingRecord") as? [Data] {
            let decoder = JSONDecoder()
            orderDetails = savedData.compactMap { data in
                do {
                    let productsData = try decoder.decode(ordersBooking.self, from: data)
                    print("productsData",productsData)
                    return productsData
                } catch {
                    print("Error decoding product: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        
        updateOrderStatistics()
    }
    
    func updateOrderStatistics() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: currentDate)

        // Initialize counters
        var totalSales: Double = 0
        var todaySales: Double = 0
        var currentOrderCount = 0
        var completedOrderCount = 0

        for order in orderDetails {
            // Add to total sales (amount + advance) regardless of order status
            totalSales += Double(order.amount)
            
            if order.date == todayString {
                // Add today's sales (amount + advance) for today's bookings
                todaySales += Double(order.amount)
            }

        }

        // Update labels
        totalsalesLb.text = String(format: "%.2f", totalSales)
        todayssalesLb.text = String(format: "%.2f", todaySales)
       
    }

   
}
extension DashboardViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return type.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dashboardCollectionViewCell
    
        cell.Label.text = type [indexPath.item]
        cell.images.image? =  Imgs [indexPath.item]
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let spacing: CGFloat = 10
        let availableWidth = collectionViewWidth - (spacing * 3)
        let width = availableWidth / 2
        return CGSize(width: width + 3, height: width + 14)
      // return CGSize(width: wallpaperCollectionView.frame.size.width , height: wallpaperCollectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5) // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0
        {
          let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
          let newViewController = storyBoard.instantiateViewController(withIdentifier: "CustomerHistoryViewController") as! CustomerHistoryViewController
          newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
          newViewController.modalTransitionStyle = .crossDissolve
          self.present(newViewController, animated: true, completion: nil)
        }
//        
        if indexPath.row == 1
        {

            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "OrderHistoryViewController") as! OrderHistoryViewController
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
          
        }
        if indexPath.row == 2
           {
               let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: "SalesViewController") as! SalesViewController
               newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
               newViewController.modalTransitionStyle = .crossDissolve
               self.present(newViewController, animated: true, completion: nil)
           }

        if indexPath.row == 3
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        }
   
       

    }
}
