//
//  ErrorPreviewItemViewController.swift
//
//
//  Created by Elazar Yifrach on 14/08/2024.
//

import Foundation
import UIKit

@MainActor
public final class ErrorPreviewItemViewController: UIViewController {
    private let label = UILabel()
    
    public init(message: String) {
        super.init(nibName: nil, bundle: nil)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
}
