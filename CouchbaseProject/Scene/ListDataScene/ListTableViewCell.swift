//
//  ListTableViewCell.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/11/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell,ConfigurableCell {

    @IBOutlet weak var dataTitleLabel: UILabel!
    
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
        return "ListTableViewCell"
    }
    
    func configure(_ item: String, at indexPath: IndexPath) {
        dataTitleLabel.text = item
    }
    
}
