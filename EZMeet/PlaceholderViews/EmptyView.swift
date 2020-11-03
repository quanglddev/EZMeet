//
//  EmptyView.swift
//  Example
//
//  Created by Alexander Schuch on 29/08/14.
//  Copyright (c) 2014 Alexander Schuch. All rights reserved.
//

import UIKit

class EmptyView: BasicPlaceholderView {
	
	let label = UILabel()
    let button = UIButton()

	override func setupView() {
		super.setupView()
		
		backgroundColor = UIColor.clear
        
        button.setTitle("Create New", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(createNewRoom), for: .touchUpInside)
        centerView.addSubview(button)
        
        let btnviews = ["button": button]
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-[button]-|", options: .alignAllCenterY, metrics: nil, views: btnviews)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[button]-|", options: .alignAllCenterX, metrics: nil, views: btnviews)

		centerView.addConstraints(hConstraints)
		centerView.addConstraints(vConstraints)
	}
	
    @objc func createNewRoom() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: UINavigationController = storyboard.instantiateViewController(withIdentifier: newMeetingVCID) as! UINavigationController
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(controller, animated: true, completion: nil)
        }
//        self.window?.rootViewController?.present(controller, animated: true, completion: nil)
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController

        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }

        return topMostViewController
    }
}
