//
//  ChooseActivityTypeViewController.swift
//  CoordinatorExample
//
//  Created by Maria Holubieva on 3/31/19.
//  Copyright © 2019 Maria Holubieva. All rights reserved.
//

import UIKit

class ChooseActivityTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var onSelected: ((_ type: String) -> Void)?
    var onShowAppointmentsList: (() -> Void)?
    var data: [String] = []

    private weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Choose activity"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Appointments List", style: .done, target: self, action: #selector(onNeedToShowAppointmentsList))
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
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

    @objc func onNeedToShowAppointmentsList() {
        onShowAppointmentsList?()
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
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedActivity = data[indexPath.row]
        onSelected?(selectedActivity)
    }
}
