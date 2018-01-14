//
//  dataListViewController.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/11/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import UIKit

/// Create the concrete class of datasource..add additional properties to customise the collection/tableview.
///specify the cell that is to be used and the data type here it is string.
class ArrayDataSource: TableArrayDataSource<String, ListTableViewCell> {
    
    //Additional properties for further modification
//    var cellActionDelegate:actionAbleCellDelegate?
    
//    override func modifyOrUpdate(cell:inout TestTableViewCell) {
//        cell.delegate = cellActionDelegate
//    }
}

class DataListViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    
    let arrayData = ["AAA","BBB","CCC","DDD"]
    var arrayDataSource:ArrayDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        arrayDataSource = ArrayDataSource(tableView: listTableView, array: arrayData)
        
        //similarly other block can be defined for action in cell like edit on cell
        arrayDataSource?.tableItemSelectionHandler = { index in
            print("cell selected")
        }
        //this functionality was added on top of the basic generic collection type view generation and cell selection
        // this enables to take action on event like button action inside the cell.
//        arrayDataSource?.cellActionDelegate = self
        //to handle some action on cell...like button action in cell
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150))
        headerView.backgroundColor = UIColor.red
        self.listTableView.tableHeaderView = headerView
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
