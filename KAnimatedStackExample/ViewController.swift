//
//  ViewController.swift
//  KAnimatedStackExample
//
//  Created by Kishore S on 08/03/21.
//

import UIKit
import KAnimatedStack

class ViewController: UIViewController {
    
    private lazy var stackView: StackView = {
        let view = StackView(delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
}


extension ViewController: StackViewDelegate {
    var sourceViewController: UIViewController {
        return self
    }
    
    func numberOfItems(in stackView: StackView) -> Int {
        return 3
    }
    
    func controller(forIndex index: Int, stackView: StackView) -> UIViewController? {
        
        switch index {
        case 0:
            return FoodViewController()
        case 1:
            return FoodViewController()
        default:
            return FoodViewController()
        }
    }
    
    func inactiveView(forIndex index: Int, stackView: StackView) -> UIView {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        switch index {
        case 0:
            label.text = "3 items in basket"
        case 1:
            label.text = "Shipping to home"
        default:
            label.text = "Paying by ABCD bank"
        }
        
        return label
    }
    
    func collapsedTitle(forIndex index: Int, stackView: StackView) -> String {
        switch index {
        case 0:
            return "Order items"
        case 1:
            return "Shipping Address"
        default:
            return "Payment"
        }
    }
    
    func properties(forIndex index: Int, stackView: StackView) -> StackCard.Properties {
        var properties = StackCard.Properties()
        properties.backgroundColor = .secondarySystemBackground
        return properties

    }
}
