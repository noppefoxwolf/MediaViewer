//
//  DismissTransitionViewProviding.swift
//
//
//  Created by Elazar Yifrach on 07/08/2024.
//

import Foundation
import UIKit

@MainActor
public protocol DismissTransitionViewProviding {
    var viewForDismissTransition: UIView? { get }
}
