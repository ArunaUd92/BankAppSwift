//
//  PayeeTableViewCell.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import UIKit

// Protocol to delegate the delete action of a payee cell
protocol PayeeCellViewDelegate: AnyObject {
    func deletePayer(at cell: PayeeTableViewCell)
}

// Custom table view cell class for displaying payee information
class PayeeTableViewCell: UITableViewCell {

    // Outlets for label and delete button
    @IBOutlet weak var lblPayeeName: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    // Delegate variable to communicate with the parent view
    weak var payeeCellViewDelegate: PayeeCellViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Additional setup after loading the view
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // Action for delete button tap
    @IBAction func deleteItemButtonTapped(_ sender: Any) {
        // Inform the delegate that the delete button was tapped for this cell
        payeeCellViewDelegate?.deletePayer(at: self)
    }
}
