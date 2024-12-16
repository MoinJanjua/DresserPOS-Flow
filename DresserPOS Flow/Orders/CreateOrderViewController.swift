//
//  CreateOrderViewController.swift
//  DresserPOS Flow
//
//  Created by Unique Consulting Firm on 15/12/2024.
//

import UIKit

class CreateOrderViewController: UIViewController {

    @IBOutlet weak var nameTF: DropDown!
    @IBOutlet weak var DateTF: UIDatePicker!
    @IBOutlet weak var dressTypeTF: DropDown!
    @IBOutlet weak var serviceTypeTF: DropDown!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var discountTF: UITextField!
    
    var customerRecords: [customerRecord] = [] // To store fetched records
    var bookingRecords: [ordersBooking] = [] // To store fetched records
    var selectedRceord: ordersBooking?
    var selectedRecordID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRecords()
        setupNameDropdown()
       
        if !(selectedRecordID?.isEmpty ?? false)
        {
           
            nameTF.text = selectedRceord?.Name
            amountTF.text = "\(selectedRceord?.amount ?? 0)"
            discountTF.text = "\(selectedRceord?.discount ?? 0)"
            dressTypeTF.text = selectedRceord?.dressingtype
            serviceTypeTF.text = selectedRceord?.otherservice
            
            if let bookingDateString = selectedRceord?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust this to match your date format
                if let bookingDate = dateFormatter.date(from: bookingDateString) {
                    DateTF.date = bookingDate
                } else {
                    print("Invalid date format")
                }
            } else {
                print("bookingdate is nil")
            }


        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard()
    {
       view.endEditing(true)
    }
    // Fetch records from UserDefaults
    func fetchRecords() {
        if let savedData = UserDefaults.standard.array(forKey: "customerRecord") as? [Data] {
            let decoder = JSONDecoder()
            customerRecords = savedData.compactMap { data in
                do {
                    return try decoder.decode(customerRecord.self, from: data)
                } catch {
                    print("Error decoding record: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }
    
    // Setup dropdown for name selection
    func setupNameDropdown() {
        nameTF.optionArray = customerRecords.map { $0.Name } // Populate dropdown with names
        nameTF.didSelect { [weak self] selectedName, index, _ in
            guard let self = self else { return }
            let selectedRecord = self.customerRecords[index]
            self.selectedRecordID = selectedRecord.id
            nameTF.text = selectedName
            // self.updateFields(with: selectedRecord)
        }
        dressTypeTF.optionArray = ["Haircut","Beard Cut/Trim","Hair Coloring","Highlights","Straightening","Hair Styling","Shaving","Kids","Haircut","Scalp Treatment"]
        dressTypeTF.didSelect { [weak self] selectedName, index, _ in
            self?.dressTypeTF.text = selectedName
        }
        
        serviceTypeTF.optionArray = [
            "Head Massage",
            "Neck and Shoulder Massage",
            "Facial (Basic Cleanup)",
            "Facial (Brightening/Anti-Aging)",
            "Eyebrow Threading",
            "Eyebrow Waxing",
            "Full Face Waxing",
            "Manicure",
            "Pedicure",
            "Hair Spa"
        ]
        serviceTypeTF.didSelect { [weak self] selectedName, index, _ in
            self?.serviceTypeTF.text = selectedName
        }
        
    }
    
    
    @IBAction func SaveButton(_ sender: Any) {
        let refId = generateCustomerId() // Generate a unique ID for the new record
        
        let amount = Int(amountTF.text ?? "0")
        let discount = Int(discountTF.text ?? "0") ?? 0
        // Create a new booking record from the form inputs
        let newRecord = ordersBooking(
            id: "\(refId)",
            Name: nameTF.text ?? "",
            date: DateTF.date.toString(),
            dressingtype: dressTypeTF.text ?? "",
            otherservice: serviceTypeTF.text ?? "",
            referenceId: selectedRecordID ?? "\(refId)", // Use existing referenceId or new refId
            amount: amount ?? 0,
            discount:discount,
            gender: "",
            contact: ""
            
        )
        
        // Retrieve existing booking records from UserDefaults
        var orders = UserDefaults.standard.object(forKey: "bookingRecord") as? [Data] ?? []
        
        // Update if a record with the same ID exists, otherwise append as new
        if let selectedID = selectedRecordID,
           let recordIndex = orders.firstIndex(where: {
               let decoder = JSONDecoder()
               guard let existingRecord = try? decoder.decode(ordersBooking.self, from: $0) else { return false }
               return existingRecord.id == selectedID
           }) {
            // Update the existing record
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(newRecord)
                orders[recordIndex] = data
                print("Record updated successfully.")
            } catch {
                print("Error encoding record: \(error.localizedDescription)")
            }
        } else {
            // Append as a new record
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(newRecord)
                orders.append(data)
                print("New record created successfully.")
            } catch {
                print("Error encoding record: \(error.localizedDescription)")
            }
        }
        UserDefaults.standard.set(orders, forKey: "bookingRecord")
        clearTextFields()
        showAlert(title: "Success", message: "The orders record has been successfully saved.")

    }

    func saveCreateSaleDetail(_ order: ordersBooking)
    {
        var orders = UserDefaults.standard.object(forKey: "bookingRecord") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(order)
            orders.append(data)
            UserDefaults.standard.set(orders, forKey: "bookingRecord")
            clearTextFields()
            
        } catch {
            print("Error encoding medication: \(error.localizedDescription)")
        }
        showAlert(title: "Success", message: "The order record has been successfully saved.")
        
    }
    
    func clearTextFields()
    {
        nameTF.text = ""
        dressTypeTF.text = ""
        serviceTypeTF.text = ""
        amountTF.text = ""
        discountTF.text = ""
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}


