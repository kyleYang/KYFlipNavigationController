//
//  TableViewCell.swift
//  KYFlipNavigationController
//
//  Created by Kyle on 2017/6/20.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    let iconView = UIImageView(frame: CGRect.zero)
    let labelView = UILabel(frame: CGRect.zero)



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let views = ["iconView":self.iconView,"labelView":labelView] as [String : Any]

        self.iconView.translatesAutoresizingMaskIntoConstraints = false
        self.labelView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.iconView)
        self.contentView.addSubview(self.labelView)

        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-20-[iconView]-50-[labelView]", options:.alignAllCenterY, metrics: nil, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[iconView]-10-|", options:NSLayoutFormatOptions(), metrics: nil, views: views))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
