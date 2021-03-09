//
//  AddressViewController.swift
//  KAnimatedStackExample
//
//  Created by Kishore S on 09/03/21.
//

import UIKit

class AddressCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        switch reuseIdentifier {
        case "home":
            self.textLabel?.text = "Home"
            self.detailTextLabel?.text = "450, ABC flat,\nSample Street,\nSample Road,\nChennai - 600001"
        default:
            self.textLabel?.text = "Office"
            self.detailTextLabel?.text = "Sample Company Pvt. Ltd.,\nSample Road,\nChennai - 600001"
        }
        
        self.detailTextLabel?.numberOfLines = 0
        
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor.systemPink.withAlphaComponent(0.2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AddressViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    private func configureView() {
        self.tableView.separatorStyle = .none
        self.tableView.register(AddressCell.self, forCellReuseIdentifier: "home")
        self.tableView.register(AddressCell.self, forCellReuseIdentifier: "office")
        self.tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "home", for: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "office", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        if let header = header as? HeaderView {
            header.label.text = "Shipping Address"
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
