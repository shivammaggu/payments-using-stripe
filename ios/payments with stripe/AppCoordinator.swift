//
//  AppCoordinator.swift
//  payments with stripe
//
//  Created by Shivam Maggu on 31/01/23.
//

import Foundation
@_spi(STP) import Stripe

protocol ICoordinator {
    func start()
}

// Handles the flow of ViewControllers in the app

class AppCoordinator: ICoordinator {
    
    let rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    // Start point of the coordinator
    
    func start() {
        self.clearCustomerData()
        self.presentCheckoutController()
    }
    
    // Setup and display the checkout controller
    
    private func presentCheckoutController() {
        let apiClient = ApiClient()
        let viewModel = CourseCheckoutViewModel(apiClient: apiClient)
        let controller = CourseCheckoutViewController(viewModel: viewModel)
        
        controller.presentAddressVC = { [weak self, weak controller] in
            
            guard let self = self, let controller = controller else { return }
            
            self.presentAddressCollectionController(controller)
        }
        
        self.rootViewController.pushViewController(controller, animated: true)
    }
    
    // Setup and display the address sheet
    
    private func presentAddressCollectionController(_ controller: CourseCheckoutViewController) {
        let addressConfiguration = AddressViewController.Configuration(additionalFields: .init(name: .required,
                                                                                               phone: .required),
                                                                       allowedCountries: [],
                                                                       title: "Billing Address")
        let addressViewController = AddressViewController(configuration: addressConfiguration,
                                                          delegate: controller)
                
        let navigationController = UINavigationController(rootViewController: addressViewController)
        self.rootViewController.present(navigationController, animated: true)
    }
    
    // Resets all payment and user related cache
    // Should be called when user logs out of the app
    
    private func clearCustomerData() {
        PaymentSheet.resetCustomer()
    }
}
