//
//  MassageCell.swift
//  Flash Chat iOS13
//
//  Created by Zaghloul on 31/07/2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

class MassageCell: UITableViewCell {

    @IBOutlet weak var ViewMassage: UIView!
    @IBOutlet weak var LabelMassage: UILabel!
    @IBOutlet weak var rightImageMassage: UIImageView!
    @IBOutlet weak var liftImageMessage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ViewMassage.layer.cornerRadius = ViewMassage.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
