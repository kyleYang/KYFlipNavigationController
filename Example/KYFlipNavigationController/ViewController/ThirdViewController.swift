//
//  ThirdViewController.swift
//  KYFlipNavigationController
//
//  Created by Kyle on 15/12/24.
//  Copyright © 2015年 xiaoluuu. All rights reserved.
//

import UIKit
import KYFlipNavigationController

class ThirdViewController: UIViewController {

    let tableView : UITableView = UITableView(frame: CGRect.zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()

        let backBarItem = UIBarButtonItem(image: UIImage(named:"lx_common_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(ThirdViewController.buttonTapped(sender:)))
        self.navigationItem.leftBarButtonItem = backBarItem

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)

        self.tableView.register(TableViewCell.self, forCellReuseIdentifier:"cell")

        let views = ["tableView":self.tableView]

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[tableView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))

    }

    func buttonTapped(sender: UIButton) {
        self.flipNavigationController?.popViewController(true)
    }
    
    
}


extension ThirdViewController : UITableViewDataSource,UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.iconView.image = UIImage(named: "cell_1")
        cell.labelView.text = "cell_\(indexPath.row)"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  viewController = ForthViewController(nibName: nil, bundle: nil)
        viewController.title = "cell_\(indexPath.row)"
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}


