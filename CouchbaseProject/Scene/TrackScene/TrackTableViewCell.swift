//
//  TrackTableViewCell.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/21/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit


class TrackTableViewCell: UITableViewCell,ConfigurableCell {

    @IBOutlet weak var trackTitle: UILabel!
    
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
        return "TrackTableViewCell"
    }
    
    func configure(_ item: TrackViewModel, at indexPath: IndexPath) {
        //        dataTitleLabel.text = item
        trackTitle.text = "TrackTableViewCell"
    }
}
