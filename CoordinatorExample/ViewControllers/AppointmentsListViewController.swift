//
//  AppointmentsListViewController.swift
//  CoordinatorExample
//
//  Created by Maria Holubieva on 3/31/19.
//  Copyright © 2019 Maria Holubieva. All rights reserved.
//

import UIKit

class AppointmentsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var data: [Appointment] = []

    private weak var tableView: UITableView!
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Appointments List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onClose))
        setupTableView()
    }

    //MARK: - Private

    private func setupTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
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

    @objc func onClose() {
        dismiss(animated: true, completion: nil)
    }

    //MARK: - UITableViewDelegate, UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!

        let appointment = data[indexPath.row]
        let str = NSMutableAttributedString(string: appointment.trainerName, attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        str.append(NSAttributedString(string: "\n\(appointment.activityType.rawValue), \(appointment.subcategory.rawValue)", attributes: [.font: UIFont.systemFont(ofSize: 15)]))
        str.append(NSAttributedString(string: "\n\(dateFormatter.string(from: appointment.date))", attributes: [.font: UIFont.italicSystemFont(ofSize: 16)]))

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.attributedText = str
        return cell
    }

}
