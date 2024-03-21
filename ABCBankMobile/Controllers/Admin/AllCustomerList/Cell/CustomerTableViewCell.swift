//
//  CustomerTableViewCell.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 17/01/2024.
//

import UIKit

protocol CustomerCellViewDelegate: AnyObject {
    func deleteCustomer(at cell: CustomerTableViewCell)
    func editCustomer(at cell: CustomerTableViewCell)
}

class CustomerTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblCustomerEmail: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    weak var customerCellViewDelegate: CustomerCellViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteItemButtonTapped(_ sender: Any) {
        // Inform the delegate that the delete button was tapped for this cell
        customerCellViewDelegate?.deleteCustomer(at: self)
    }
    
    @IBAction func editItemButtonTapped(_ sender: Any) {
        // Inform the delegate that the delete button was tapped for this cell
        customerCellViewDelegate?.editCustomer(at: self)
    }

}
