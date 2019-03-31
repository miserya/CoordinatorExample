//
//  GymActivityCoordinator.swift
//  CoordinatorExample
//
//  Created by Maria Holubieva on 3/31/19.
//  Copyright © 2019 Maria Holubieva. All rights reserved.
//

import Foundation
import UIKit

struct GymActivityStateStorage {
    let activity: ActivityType = .gym
    var subcategory: SubcategoryType?
    var trainerName: String?
    var date: Date?
}

class GymActivityCoordinator: BaseCoordinator, Coordinator {

    var onFinish: (() -> Void)?

    private unowned let navigationController: UINavigationController
    private unowned let appointmentsManager: AppointmentManager
    private var stateStorage = GymActivityStateStorage()

    init(with navigationController: UINavigationController, appointmentsManager: AppointmentManager) {
        self.navigationController = navigationController
        self.appointmentsManager = appointmentsManager
    }

    func start() {
        showChooseActivityTypeScreen()
    }

    //MARK: - Private

    private func showChooseActivityTypeScreen() {
        let vc = ChooseActivityTypeViewController()
        vc.data = stateStorage.activity.getSubcategories().map({ $0.rawValue })
        vc.onSelected = { [weak self] (activity: String) in
            guard let subcategory = SubcategoryType(rawValue: activity) else {
                fatalError("Unknown gym activity type")
            }
            self?.stateStorage.subcategory = subcategory
            self?.showChooseTrainerScreen(for: subcategory)
        }
        vc.onShowAppointmentsList = { [weak self] in
            self?.showAppointmentsListScreen()
        }

        navigationController.pushViewController(vc, animated: true)
    }

    private func showChooseTrainerScreen(for activityType: SubcategoryType) {
        let data = activityType.getTrainers()

        let vc = ChooseActivityTypeViewController()
        vc.data = data
        vc.onSelected = { [weak self] (trainerName: String) in
            self?.stateStorage.trainerName = trainerName
            self?.showTrainerProfile(with: trainerName)
        }
        vc.onShowAppointmentsList = { [weak self] in
            self?.showAppointmentsListScreen()
        }

        navigationController.pushViewController(vc, animated: true)
    }

    private func showAppointmentsListScreen() {
        let vc = AppointmentsListViewController()
        vc.data = appointmentsManager.appointmentsList
        navigationController.topViewController?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }

    private func showTrainerProfile(with name: String) {
        guard let subcategory = stateStorage.subcategory else {
            fatalError("No choosed subcategory!")
        }

        let vc = TrainerProfileViewController()
        vc.args = TrainerProfileArgs(name: name, activity: stateStorage.activity, subcategory: subcategory)
        vc.onCreateAppointmnet = { [weak self] (date: Date) in
            self?.stateStorage.date = date
            self?.createAppointment()
        }

        navigationController.pushViewController(vc, animated: true)
    }

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
