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
        return 2
    }
    
    func controller(forIndex index: Int, stackView: StackView) -> UIViewController? {
        let controller = UITableViewController()
        controller.view.backgroundColor = .secondarySystemBackground
        return controller
    }
    
    func inactiveView(forIndex index: Int, stackView: StackView) -> UIView {
        let label = UILabel()
        label.text = "Hello \(index)"
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }
    
    func collapsedTitle(forIndex index: Int, stackView: StackView) -> String {
        return "Collapsed \(index)"
    }
    
    func properties(forIndex index: Int, stackView: StackView) -> StackCard.Properties {
        var properties = StackCard.Properties()
        properties.backgroundColor = .secondarySystemBackground
        return properties

    }
}
