//
//  PayeeTableViewCell.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import UIKit

protocol PayeeCellViewDelegate : AnyObject {
    func deletePayer(at: PayeeTableViewCell)
}
    
class PayeeTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPayeeName: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    weak var payeeCellViewDelegate: PayeeCellViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteItemButtonTapped(_ sender: Any) {
        payeeCellViewDelegate?.deletePayer(at: self)
    }

}
