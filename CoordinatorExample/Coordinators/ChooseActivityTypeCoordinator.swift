//
//  ChooseActivityTypeCoordinator.swift
//  CoordinatorExample
//
//  Created by Maria Holubieva on 3/31/19.
//  Copyright © 2019 Maria Holubieva. All rights reserved.
//

import Foundation
import UIKit

class ChooseActivityTypeCoordinator: BaseCoordinator, Coordinator {

    var onFinish: (() -> Void)?

    private unowned let navigationController: UINavigationController
    private unowned let appointmentsManager: AppointmentManager

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
        vc.data = ActivityType.all().map({ $0.rawValue })
        vc.onSelected = { [weak self] (activity: String) in
            guard let activityType = ActivityType(rawValue: activity) else {
                fatalError("Unknown activity type")
            }
            switch activityType {
            case .gym:          self?.startGymActivityFlow()
            case .group:        self?.startGroupActivityFlow()
            case .any:          self?.startAnyActivityFlow()
            }
        }
        vc.onShowAppointmentsList = { [weak self] in
            self?.showAppointmentsListScreen()
        }

        navigationController.pushViewController(vc, animated: false)
    }

    private func startGymActivityFlow() {
        let gymCoordinator = GymActivityCoordinator(with: navigationController,
                                                            appointmentsManager: appointmentsManager)
        gymCoordinator.onFinish = {
            [weak self, weak weakCoordinator = gymCoordinator] in
            self?.removeDependency(weakCoordinator)
            self?.navigationController.popToRootViewController(animated: true)
        }
        addDependency(gymCoordinator)
        gymCoordinator.start()
    }

    private func startGroupActivityFlow() {
        let groupCoordinator = GroupActivityCoordinator(with: navigationController, appointmentsManager: appointmentsManager)
        groupCoordinator.onFinish = {
            [weak self, weak weakCoordinator = groupCoordinator] in
            self?.removeDependency(weakCoordinator)
            self?.navigationController.popToRootViewController(animated: true)
        }
        addDependency(groupCoordinator)
        groupCoordinator.start()
    }

    private func startAnyActivityFlow() {
        let anyCoordinator = AnyActivityCoordinator(with: navigationController, appointmentsManager: appointmentsManager)
        anyCoordinator.onFinish = {
            [weak self, weak weakCoordinator = anyCoordinator] in
            self?.removeDependency(weakCoordinator)
            self?.navigationController.popToRootViewController(animated: true)
        }
        addDependency(anyCoordinator)
        anyCoordinator.start()
    }

    private func showAppointmentsListScreen() {
        let vc = AppointmentsListViewController()
        vc.data = appointmentsManager.appointmentsList
        navigationController.topViewController?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}
