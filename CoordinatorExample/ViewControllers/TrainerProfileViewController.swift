//
//  TrainerProfileViewController.swift
//  CoordinatorExample
//
//  Created by Maria Holubieva on 3/31/19.
//  Copyright © 2019 Maria Holubieva. All rights reserved.
//

import Foundation
import UIKit

struct TrainerProfileArgs {
    let name: String
    let activity: ActivityType
    let subcategory: SubcategoryType
}

class TrainerProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private enum TableViewItem {
        case bold(String)
        case regular(String)
        case date(Date)
    }

    var onCreateAppointmnet: ((_ date: Date) -> Void)?
    var args: TrainerProfileArgs?

    private var data: [TableViewItem] = []
    private weak var tableView: UITableView!
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
        return dateFormatter
    }()
    private var chooseDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let args = args {
            data = [ .bold(args.name), .regular("\(args.activity.rawValue), \(args.subcategory.rawValue)"), .date(chooseDate) ]
        }
        navigationItem.title = "Trainer Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create Appointment", style: .done, target: self, action: #selector(onNeedCreateAppointment))

        setupTableView()
    }

    override var inputAccessoryView: UIView? {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .dateAndTime
        datePicker.date = chooseDate
        datePicker.addTarget(self, action: #selector(onDateChanged(_:)), for: .valueChanged)

        return datePicker
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    //MARK: - Private

    private func setupTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

        self.tableView = tableView
    }

    @objc func onNeedCreateAppointment() {
        onCreateAppointmnet?(chooseDate)
    }

    @objc func onDateChanged(_ sender: UIDatePicker) {
        chooseDate = sender.date

        if let dateIndex = data.firstIndex(where: { (item: TrainerProfileViewController.TableViewItem) -> Bool in
            switch item {
            case .date(_):     return true
            default:        return false
            } }) {

            data[dateIndex] = .date(chooseDate)
            tableView.reloadRows(at: [IndexPath(row: dateIndex, section: 0)], with: .none)
        }
    }

    //MARK: - UITableViewDelegate, UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        switch data[indexPath.row] {

        case .bold(let text):
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            cell.textLabel?.text = text
            cell.selectionStyle = .none

        case .regular(let text):
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.textLabel?.text = text
            cell.selectionStyle = .none

        case .date(let date):
            cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 16)
            cell.textLabel?.text = "\(dateFormatter.string(from: date)) (editable)"
            cell.selectionStyle = .blue
        }

        return cell
    }

}
