//
//  MemberTableViewCell.swift
//  MemberManager
//
//  Created by Administrator on 11/21/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAgeSex: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    
    
    
    var member: Members? {
        didSet {
            if let name = member?.name {
                labelName.text = name
            }
            if let age = member?.age, let sex = member?.sex {
                labelAgeSex.text = "Age: \(String(age)) Sex: \(sex)"
            }
            if let detail = member?.detail {
                labelDetail.text = detail
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
