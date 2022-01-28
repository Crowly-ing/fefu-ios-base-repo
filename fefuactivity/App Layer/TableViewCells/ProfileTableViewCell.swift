//
//  ProfileTableViewCell.swift
//  fefuactivity
//
//  Created by soFuckingHot on 26.01.2022.
//

import UIKit

struct innerProfileModel {
    let rowName: String
    let rowData: String
}

class ProfileTableViewCell: UITableViewCell {

    
    @IBOutlet weak var rowName: UILabel!
    @IBOutlet weak var rowData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(_ model: innerProfileModel) {
        self.rowName.text = model.rowName
        self.rowData.text = model.rowData
    }
    
}
