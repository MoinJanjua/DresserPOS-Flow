import UIKit

class SalesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var allbtn: UIButton!
    @IBOutlet weak var commpletedbtn: UIButton!
    @IBOutlet weak var pendingbtn: UIButton!
    
    var datasource: [ordersBooking] = []
    var filteredDatasource: [ordersBooking] = []
    var selectedRceord: ordersBooking?
    var ID = String()
    var customer_record = [customerRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.dataSource = self
        TableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let savedData = UserDefaults.standard.array(forKey: "bookingRecord") as? [Data] {
            let decoder = JSONDecoder()
            datasource = savedData.compactMap { data in
                do {
                    let productsData = try decoder.decode(ordersBooking.self, from: data)
                    return productsData
                } catch {
                    print("Error decoding product: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        filteredDatasource = datasource // Default to show all records
        updateUI()
        getCustomerrecord()
    }
    
    func getCustomerrecord() {
        if let savedData = UserDefaults.standard.array(forKey: "customerRecord") as? [Data] {
            let decoder = JSONDecoder()
            customer_record = savedData.compactMap { data in
                do {
                    let productsData = try decoder.decode(customerRecord.self, from: data)
                    return productsData
                } catch {
                    print("Error decoding product: \(error.localizedDescription)")
                    return nil
                }
            }
        }

        for cust_rec in customer_record {
            let matchingRecords = datasource.enumerated().filter { $0.element.referenceId == cust_rec.id }
            for (index, _) in matchingRecords {
                datasource[index].gender = cust_rec.gender
                datasource[index].contact = cust_rec.contact
            }
        }
        filteredDatasource = datasource
        TableView.reloadData()
    }
    
    func updateUI() {
        noDataLabel.text = "No Sales Found"
        if filteredDatasource.isEmpty {
            TableView.isHidden = true
            noDataLabel.isHidden = false
        } else {
            TableView.isHidden = false
            noDataLabel.isHidden = true
        }
        TableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDatasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! salesTableViewCell
        let rec = filteredDatasource[indexPath.item]
        cell.namelb.text = rec.Name
        cell.contactlb.text = rec.date
        cell.genderlb.text = "Gender : \(rec.gender)"
        cell.amountlb.text = "Amount Paid: \(rec.amount)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    // MARK: - Helper Functions for Filtering
    func filterWeeklyRecords() {
        let calendar = Calendar.current
        let today = Date()
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: today)!
        
        filteredDatasource = datasource.filter { record in
            if let recordDate = getDate(from: record.date) {
                return recordDate >= oneWeekAgo && recordDate <= today
            }
            return false
        }
        updateUI()
    }
    
    func filterMonthlyRecords() {
        let calendar = Calendar.current
        let today = Date()
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: today)!
        
        filteredDatasource = datasource.filter { record in
            if let recordDate = getDate(from: record.date) {
                return recordDate >= oneMonthAgo && recordDate <= today
            }
            return false
        }
        updateUI()
    }
    
    func getDate(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }
    
    // MARK: - Button Actions
    @IBAction func allButton(_ sender: Any) {
        allbtn.backgroundColor = .systemBlue
        commpletedbtn.backgroundColor = .white
        pendingbtn.backgroundColor = .white
        
        filteredDatasource = datasource
        updateUI()
    }
    
    @IBAction func weeklyButton(_ sender: Any) {
        allbtn.backgroundColor = .white
        commpletedbtn.backgroundColor = .systemBlue
        pendingbtn.backgroundColor = .white
        
        filterWeeklyRecords()
    }
    
    @IBAction func monthlyButton(_ sender: Any) {
        allbtn.backgroundColor = .white
        commpletedbtn.backgroundColor = .white
        pendingbtn.backgroundColor = .systemBlue
        
        filterMonthlyRecords()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
