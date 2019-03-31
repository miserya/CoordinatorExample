//
//  AnyActivityCoordinator.swift
//  CoordinatorExample
//
//  Created by Maria Holubieva on 3/31/19.
//  Copyright © 2019 Maria Holubieva. All rights reserved.
//

import Foundation
import UIKit

struct AnyActivityStateStorage {
    let activity: ActivityType = .any
    var subcategory: SubcategoryType?
    var trainerName: String?
    var date: Date?
}

class AnyActivityCoordinator: BaseCoordinator, Coordinator {

    var onFinish: (() -> Void)?

    private unowned let navigationController: UINavigationController
    private unowned let appointmentsManager: AppointmentManager
    private var stateStorage = AnyActivityStateStorage()

    init(with navigationController: UINavigationController, appointmentsManager: AppointmentManager) {
        self.navigationController = navigationController
        self.appointmentsManager = appointmentsManager
    }

    func start() {
        guard let subcategory = stateStorage.activity.getSubcategories().randomElement(),
            let trainer = subcategory.getTrainers().randomElement() else {
                fatalError("Empty activity type data!")
        }

        stateStorage.subcategory = subcategory
        stateStorage.trainerName = trainer
        stateStorage.date = Date()
        createAppointment()
    }

    //MARK: - Private

    private func createAppointment() {
        guard let subcategory = stateStorage.subcategory else {
            fatalError("No choosed subcategory!")
        }
        guard let trainerName = stateStorage.trainerName else {
            fatalError("No choosed trainer!")
        }
        guard let date = stateStorage.date else {
            fatalError("No choosed date!")
        }

        let appointment = Appointment(activityType: stateStorage.activity, subcategory: subcategory, trainerName: trainerName, date: date)
        self.appointmentsManager.save(appointment)

        let alert = UIAlertController(title: "Appointment created!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_) in
            self?.onFinish?()
        }))

        navigationController.topViewController?.present(alert, animated: true, completion: nil)
    }

}
