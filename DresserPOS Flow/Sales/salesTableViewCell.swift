//
//  salesTableViewCell.swift
//  DresserPOS Flow
//
//  Created by Unique Consulting Firm on 16/12/2024.
//

import UIKit

class salesTableViewCell: UITableViewCell {

   
    @IBOutlet weak var namelb: UILabel!
    @IBOutlet weak var contactlb: UILabel!
    @IBOutlet weak var genderlb: UILabel!
    @IBOutlet weak var amountlb: UILabel!
    @IBOutlet weak var imagesign: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
