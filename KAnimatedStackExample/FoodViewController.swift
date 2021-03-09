//
//  FoodViewController.swift
//  KAnimatedStackExample
//
//  Created by Kishore S on 09/03/21.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    
    private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = .clear
        self.contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
        ])
    }
}

class FoodCell: UITableViewCell {
    private(set) lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textColor = .systemPink
        return label
    }()
    
    private(set) lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.addTarget(self, action: #selector(self.stepped(_:)), for: .valueChanged)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.selectionStyle = .none
        switch reuseIdentifier {
        case "soup":
            self.iconView.image = UIImage(named: "soup")
            self.label.text = "Soup"
        case "burger":
            self.iconView.image = UIImage(named: "burger")
            self.label.text = "Burger"
        default:
            self.iconView.image = UIImage(named: "fish")
            self.label.text = "Fish"
        }
        
        self.contentView.addSubview(iconView)
        self.contentView.addSubview(label)
        self.contentView.addSubview(stepper)
        self.contentView.addSubview(countLabel)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            iconView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            iconView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            iconView.widthAnchor.constraint(equalToConstant: 60),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            
            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: countLabel.leadingAnchor, constant: -10),

            countLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -10),

            stepper.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            stepper.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
        ])
    }
    
    @objc func stepped(_ sender: UIStepper) {
        countLabel.text = "\(Int(stepper.value))"
    }
}

class FoodViewController: UITableViewController {

    private var values: [Int: Double] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    private func configureView() {
        self.tableView.separatorStyle = .none
        self.tableView.register(FoodCell.self, forCellReuseIdentifier: "soup")
        self.tableView.register(FoodCell.self, forCellReuseIdentifier: "burger")
        self.tableView.register(FoodCell.self, forCellReuseIdentifier: "fish")
        self.tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "soup", for: indexPath)
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "burger", for: indexPath)
        default:
            return tableView.dequeueReusableCell(withIdentifier: "fish", for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        if let header = header as? HeaderView {
            header.label.text = "Order Items"
        }
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}
