//
//  UUResponder+Extension.swift
//  tip-calculator
//
//  Created by Dhiman Ranjit on 19/02/23.
//

import UIKit


extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
