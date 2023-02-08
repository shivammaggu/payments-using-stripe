//
//  CourseCheckoutViewModel.swift
//  payments with stripe
//
//  Created by Shivam Maggu on 01/02/23.
//

import Foundation
import Stripe

// Handles all non UI related activities for CourseCheckoutViewController

class CourseCheckoutViewModel {
    
    private let apiClient: IApiClient
    private var paymentIntentClientSecret: String?
    private var customer: PaymentSheet.CustomerConfiguration?
    
    init(apiClient: IApiClient) {
        self.apiClient = apiClient
    }
    
    // Creates a payment intent for the customer and fetches the important keys and id's for processing a payment
    
    func fetchPaymentIntent(completion: @escaping ((Bool, String?) -> Void)) {
        
        // This could be the details for the item that the customer wants to buy
        
        let cartContent: [String: Any] = ["items": [["id": UUID().uuidString]]]
        
        self.apiClient.createPaymentIntent(cartContent: cartContent) { [weak self] (data, error) in
            
            guard let self = self else { return }
            
            guard error == nil else {
                print(error.debugDescription)
                completion(false, error.debugDescription)
                return
            }
            
            guard
                let customerId = data?.customerId as? String,
                let customerEphemeralKeySecret = data?.ephemeralKey as? String,
                let paymentIntentClientSecret = data?.paymentIntent as? String,
                let publishableKey = data?.publishableKey as? String
            else {
                let error = "Error fetching required data"
                print(error)
                completion(false, error)
                return
            }
            
            print("Created Payment Intent")
            
            self.setPublishableKey(publishableKey: publishableKey)
            self.paymentIntentClientSecret = paymentIntentClientSecret
            self.customer = .init(id: customerId,
                                  ephemeralKeySecret: customerEphemeralKeySecret)
            completion(true, nil)
        }
    }
    
    // Sets the Publishable key to Stripe SDK
    // Not required if key is already added to AppDelegate
    
    private func setPublishableKey(publishableKey: String) {
        STPAPIClient.shared.publishableKey = publishableKey
    }
    
    // Method to retrieve the customer object
    
    func getCustomer() -> PaymentSheet.CustomerConfiguration? {
        return self.customer
    }
    
    // Method to retrieve the secret key of payment intent
    // This key will be used to process payments
    
    func getPaymentIntentClientSecret() -> String? {
        return self.paymentIntentClientSecret
    }
}
