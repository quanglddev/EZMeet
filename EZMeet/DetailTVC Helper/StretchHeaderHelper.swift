//
//  StretchHeaderHelper.swift
//  EZMeet
//
//  Created by QUANG on 7/30/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit

struct StretchyHeader2 {
    let headerHeight: CGFloat = 277
    
    let headerCut: CGFloat = 0
}

extension DetailTVC {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNewView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func updateView() {
        tableView.backgroundColor = .white
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.addSubview(headerView)
        
        newHeaderLayer = CAShapeLayer()
        newHeaderLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = newHeaderLayer
        
        let newHeight = StretchyHeader2().headerHeight - StretchyHeader2().headerCut / 2
        
        tableView.contentInset = UIEdgeInsets(top: newHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -newHeight)
        setNewView()
    }
    
    func setNewView() {
        let newHeight = StretchyHeader2().headerHeight - StretchyHeader2().headerCut / 2
        var getHeaderFrame = CGRect(x: 0, y: -newHeight, width: tableView.bounds.width, height: StretchyHeader2().headerHeight)
        
        if tableView.contentOffset.y < newHeight {
            getHeaderFrame.origin.y = tableView.contentOffset.y
            getHeaderFrame.size.height = -tableView.contentOffset.y + StretchyHeader2().headerCut / 2
            
        }
        
        headerView.frame = getHeaderFrame
        let cutDirection = UIBezierPath()
        cutDirection.move(to: CGPoint(x: 0, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeaderFrame.width, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeaderFrame.width, y: getHeaderFrame.height))
        cutDirection.addLine(to: CGPoint(x: 0, y: getHeaderFrame.height - StretchyHeader2().headerCut))
        newHeaderLayer.path = cutDirection.cgPath
    }
    
}
