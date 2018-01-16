//
//  AskTableViewCell.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/15/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit

class AskTableViewCell: UITableViewCell,ConfigurableCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- ConfigurableCell protocol
    //NOTE:-also set the identifier in the xib with same name
    //is this necessary..looks like works without putting the identifier in the xib.
    static var nibForCell: String {
        return "AskTableViewCell"
    }
    
    func configure(_ item: CBLQueryRow, at indexPath: IndexPath) {
        //        dataTitleLabel.text = item
        titleLabel.text = "AskTableViewCell"
    }
}
