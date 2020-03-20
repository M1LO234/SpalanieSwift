//
//  DataCell.swift
//  Spalanie
//
//  Created by Milosz Wrzesien on 15/03/2020.
//  Copyright © 2020 Milosz Wrzesien. All rights reserved.
//

import UIKit

class DataCell: UITableViewCell {

    @IBOutlet weak var DataLabel: UILabel!
    @IBOutlet weak var StacjaLabel: UILabel!
    @IBOutlet weak var cenaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
