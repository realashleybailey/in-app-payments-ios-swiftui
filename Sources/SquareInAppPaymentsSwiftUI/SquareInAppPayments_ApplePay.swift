//
//  File.swift
//
//
//  Created by Ashley Bailey on 19/12/2021.
//

import PassKit
import SwiftUI
import Foundation

import SquareInAppPaymentsSDK


extension SQIP {
	@available(iOS 14.0, *)
	public class applePay {
		
		static var applePayHandler = ApplePayHandler()
		
		@available(iOSApplicationExtension, unavailable)
		public static func present(paymentRequest: PKPaymentRequest, completion: @escaping (SQIPCardDetails) -> PKPaymentAuthorizationStatus) {
			self.applePayHandler.create(paymentRequest: paymentRequest, completion: completion)
		}
		
		public static func dismiss() {
			self.applePayHandler.delete()
		}
		
		public struct button: View {
			
			var action: () -> Void
			
			public init(action: @escaping () -> Void) {
				self.action = action
			}
			
			public var body: some View {
				Representable(action: action)
					.frame(minWidth: 100, maxWidth: 400)
					.frame(height: 45)
					.frame(maxWidth: .infinity)
					.accessibility(label: Text("Buy with Apple Pay", comment: "Accessibility label for Buy with Apple Pay button"))
			}
		}
		
		struct Representable: UIViewRepresentable {
			
			var action: () -> Void
			
			class Coordinator: NSObject {
				var action: () -> Void
				var button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .automatic)
				
				init(action: @escaping () -> Void) {
					self.action = action
					super.init()
					button.addTarget(self, action: #selector(callback(_:)), for: .touchUpInside)
				}
				
				@objc
				func callback(_ sender: Any) {
					action()
				}
			}
			
			func makeCoordinator() -> Coordinator {
				Coordinator(action: action)
			}
			
			func makeUIView(context: Context) -> UIView {
				context.coordinator.button
			}
			
			func updateUIView(_ rootView: UIView, context: Context) {
				context.coordinator.action = action
			}
		}
		
		
	}
}

@available(iOS 14.0, *)
class ApplePayHandler: NSObject {
	
	fileprivate var applePayResult: Result<[Error]> = Result.canceled
	
	enum Result<T> {
		case success
		case failure(T)
		case canceled
	}
	
	var paymentController: PKPaymentAuthorizationController?
	
	var paymentRequest: PKPaymentRequest?
	var completionHandler: ((SQIPCardDetails) -> PKPaymentAuthorizationStatus)?
	
	public func create(paymentRequest: PKPaymentRequest?, completion: ((SQIPCardDetails) -> PKPaymentAuthorizationStatus)?) {

		self.paymentRequest = paymentRequest
		self.completionHandler = completion

		self.paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest!)

		paymentController?.delegate = self
		paymentController?.present(completion: { presented in
			if presented {
				NSLog("Presented payment controller")
			} else {
				NSLog("Failed to present payment controller")
			}
		})
	}
	
	public func delete() {
		paymentController?.dismiss()
	}
}

@available(iOS 14.0, *)
extension ApplePayHandler: PKPaymentAuthorizationControllerDelegate {
	
	func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
		
		let nonce = SQIPApplePayNonceRequest(payment: payment)
		
		nonce.perform { [weak self] cardDetails, error in
			
			guard let strongSelf = self else {
				NSLog("Apple Pay: Strong self failed")
				
				completion(.failure)
				return
			}
			
			if error != nil {
				NSLog(error?.localizedDescription ?? "Apple Pay: Failed with errors")
				
				let errors = [error].compactMap { $0 }
				strongSelf.applePayResult = Result.failure(errors)
				
				completion(.failure)
			}
			
			if cardDetails == nil {
				NSLog("Apple Pay: Card details missing")
				
				let errors = NSError(domain: "", code: 0, userInfo: ["Apple Pay Failed": "Card details missing"])
				strongSelf.applePayResult = Result.failure([errors])
				
				completion(.failure)
			}
			
			strongSelf.applePayResult = Result.success
			completion(strongSelf.completionHandler!(cardDetails!))
		}
	}
	
	func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
		controller.dismiss {
			NSLog("done")
		}
	}
}
