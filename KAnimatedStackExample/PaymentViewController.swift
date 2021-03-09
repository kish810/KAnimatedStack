//
//  PaymentViewController.swift
//  KAnimatedStackExample
//
//  Created by Kishore S on 09/03/21.
//

import UIKit

class PaymentCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        switch reuseIdentifier {
        case "abcd":
            self.textLabel?.text = "ABCD bank"
            self.detailTextLabel?.text = "xxxx-xxxx-xxxx-1234"
            
        case "efgh":
            self.textLabel?.text = "EFGH bank"
            self.detailTextLabel?.text = "xxxx-xxxx-xxxx-5678"
        default:
            self.textLabel?.text = "HDBC bank"
            self.detailTextLabel?.text = "xxxx-xxxx-xxxx-1289"
        }
        
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor.systemPink.withAlphaComponent(0.2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PaymentViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    private func configureView() {
        self.tableView.separatorStyle = .none
        self.tableView.register(PaymentCell.self, forCellReuseIdentifier: "abcd")
        self.tableView.register(PaymentCell.self, forCellReuseIdentifier: "efgh")
        self.tableView.register(PaymentCell.self, forCellReuseIdentifier: "hdbc")
        self.tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        
        self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)

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
            let cell = tableView.dequeueReusableCell(withIdentifier: "abcd", for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "efgh", for: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "hdbc", for: indexPath)
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
            header.label.text = "Payment"
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
