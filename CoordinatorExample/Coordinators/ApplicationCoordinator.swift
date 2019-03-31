//
//  ApplicationCoordinator.swift
//  CoordinatorExample
//
//  Created by Maria Holubieva on 3/31/19.
//  Copyright © 2019 Maria Holubieva. All rights reserved.
//

import Foundation
import UIKit

class ApplicationCoordinator: BaseCoordinator, Coordinator {

    var onFinish: (() -> Void)?

    private unowned let window: UIWindow
    private let navigationController: UINavigationController
    private let appointmentsManager = AppointmentManager()

    init(with window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        startChooseActivityFlow()
    }

    //MARK: - Private

    private func startChooseActivityFlow() {
        let chooseActivityCoordinator = ChooseActivityTypeCoordinator(with: navigationController, appointmentsManager: appointmentsManager)
        chooseActivityCoordinator.onFinish = {
            [weak self, weak weakCoordinator = chooseActivityCoordinator] in
            self?.removeDependency(weakCoordinator)
        }
        addDependency(chooseActivityCoordinator)
        chooseActivityCoordinator.start()
    }
    
}

