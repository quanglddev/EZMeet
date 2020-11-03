//
//  RefreshHelper.swift
//  EZMeet
//
//  Created by QUANG on 7/28/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit

//MARK: Properties
var customView: UIView!
var labelsArray: Array<UILabel> = []

var isAnimating = false

var currentColorIndex = 0

var currentLabelIndex = 0

var timer: Timer!

extension ViewController {
    
    //MARK: Function
    /*
    func initialRefreshCapability() {
        
        //refreshControl = UIRefreshControl()
        //pollTableView.addSubview(refreshControl)
        
        loadCustomRefreshContents()
    }
    
    func loadCustomRefreshContents() {
        let refreshContents = Bundle.main.loadNibNamed("RefreshContents", owner: self, options: nil)
        customView = refreshContents?[0] as! UIView
        customView.frame = refreshControl.bounds
        
        for i in 0..<customView.subviews.count {
            labelsArray.append(customView.viewWithTag(i + 1) as! UILabel)
        }
        
        refreshControl.addSubview(customView)
    }
    
    func animateRefreshStep1() {
        isAnimating = true
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            labelsArray[currentLabelIndex].transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
            labelsArray[currentLabelIndex].textColor = self.getNextColor()
            
        }, completion: { (finished) -> Void in
            
            UIView.animate(withDuration: 0.05, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                labelsArray[currentLabelIndex].transform = CGAffineTransform.identity
                labelsArray[currentLabelIndex].textColor = UIColor.white
                
            }, completion: { (finished) -> Void in
                currentLabelIndex += 1
                
                if currentLabelIndex < labelsArray.count {
                    self.animateRefreshStep1()
                }
                else {
                    self.animateRefreshStep2()
                }
            })
        })
    }
    
    func animateRefreshStep2() {
        UIView.animate(withDuration: 0.35, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            labelsArray[0].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            labelsArray[1].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            labelsArray[2].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            labelsArray[3].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            labelsArray[4].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            labelsArray[5].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            labelsArray[6].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            
        }, completion: { (finished) -> Void in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                labelsArray[0].transform = CGAffineTransform.identity
                labelsArray[1].transform = CGAffineTransform.identity
                labelsArray[2].transform = CGAffineTransform.identity
                labelsArray[3].transform = CGAffineTransform.identity
                labelsArray[4].transform = CGAffineTransform.identity
                labelsArray[5].transform = CGAffineTransform.identity
                labelsArray[6].transform = CGAffineTransform.identity
                
            }, completion: { (finished) -> Void in
                if self.refreshControl.isRefreshing {
                    currentLabelIndex = 0
                    self.animateRefreshStep1()
                }
                else {
                    isAnimating = false
                    currentLabelIndex = 0
                    for i in 0..<labelsArray.count {
                        labelsArray[i].textColor = UIColor.white
                        labelsArray[i].transform = CGAffineTransform.identity
                    }
                }
            })
        })
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            if !isAnimating {
                animateRefreshStep1()
            }
        }
    }
    
    func getNextColor() -> UIColor {
        var colorsArray: Array<UIColor> = [UIColor.magenta, UIColor.brown, UIColor.yellow, UIColor.red, UIColor.green, UIColor.blue, UIColor.orange]
        
        if currentColorIndex == colorsArray.count {
            currentColorIndex = 0
        }
        
        let returnColor = colorsArray[currentColorIndex]
        currentColorIndex += 1
        
        return returnColor
    }
    
    func doSomething() {
        shouldRefresh = true
        
        if (user) != nil && shouldRefresh {
            shouldRefresh = false
            self.getJoinedRoomsFromFirebase()
        }
    }
    
    func endOfWork() {
        //refreshControl.endRefreshing()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        /*if refreshControl.isRefreshing {
            if !isAnimating {
                doSomething()
                animateRefreshStep1()
            }
        }*/
    }*/
}
