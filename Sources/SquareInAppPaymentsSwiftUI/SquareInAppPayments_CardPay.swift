//
//  SquareInAppPayments.swift
//  AshleysParty
//
//  Created by Ashley Bailey on 15/12/2021.
//

import SwiftUI
import Foundation

import SquareInAppPaymentsSDK
import SquareBuyerVerificationSDK

extension SQIP {
	@available(iOS 14.0, *)
	public class cardPay {

		public var defaultTheme: SQIPTheme {
			let theme = SQIPTheme()
			theme.errorColor = .red
			theme.tintColor = UIColor(red: 0.9580881, green: 0.10593573, blue: 0.3403331637, alpha: 1)
			theme.keyboardAppearance = .light
			theme.messageColor = UIColor(red: 0.9580881, green: 0.10593573, blue: 0.3403331637, alpha: 1)
			theme.saveButtonTitle = "Pay"

			return theme
		}

		@available(iOSApplicationExtension, unavailable)
		public static func present(theme: SQIPTheme = SQIPTheme(), verifyBuyer: SQIPVerifyBuyerSwiftUI?, completion: @escaping (SQIPCardDetails, SQIPBuyerVerifiedDetails?, @escaping (Error?) -> Void) -> Void, style: UIUserInterfaceStyle = .unspecified) {
			
			let rootCard = CardEntry(theme: theme, verifyBuyer: verifyBuyer, completion: completion)

			let controller = UIHostingController(rootView: rootCard)
			controller.modalPresentationStyle = .overFullScreen
			controller.overrideUserInterfaceStyle = style

			UIApplication.shared.windows.first?.rootViewController?.present(controller, animated: true)
		}

		@available(iOSApplicationExtension, unavailable)
		public static func dismiss() {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
			}
		}

		private struct CardEntry: View {

			var theme: SQIPTheme

			var verifyBuyer: SQIPVerifyBuyerSwiftUI?
			var completion: (SQIPCardDetails, SQIPBuyerVerifiedDetails?, @escaping (Error?) -> Void) -> Void

			var body: some View {
				NavigationView {
						CardEntryModule(theme: theme, verifyBuyer: verifyBuyer, completion: completion)
							.frame(maxHeight: UIScreen.main.bounds.height)
							.ignoresSafeArea(.keyboard)
							.ignoresSafeArea()
							.navigationBarTitleDisplayMode(.inline)
							.navigationBarItems(leading: Button(action: {
							cardPay.dismiss()
						}) { Text("Cancel") })
				}
			}
		}

		private struct CardEntryModule: UIViewControllerRepresentable {

			var theme: SQIPTheme

			var verifyBuyer: SQIPVerifyBuyerSwiftUI?
			var completion: (SQIPCardDetails, SQIPBuyerVerifiedDetails?, @escaping (Error?) -> Void) -> Void

			func makeCoordinator() -> CardEntryHandler {
				CardEntryHandler(self)
			}

			func makeUIViewController(context: Context) -> SQIPCardEntryViewController {
				let ce = self.makeCardEntryViewController()
				ce.delegate = context.coordinator
				return ce
			}

			func updateUIViewController(_ uiViewController: SQIPCardEntryViewController, context: Context) {

			}

			func makeCardEntryViewController() -> SQIPCardEntryViewController {
				return SQIPCardEntryViewController(theme: theme)
			}
		}

		private class CardEntryHandler: NSObject, SQIPCardEntryViewControllerDelegate, UINavigationControllerDelegate {

			var parent: CardEntryModule
			private var card: SQIPCardDetails?

			init(_ parent: CardEntryModule) {
				self.parent = parent
				self.card = nil
			}

			func makeVerificationParameters(contact: SQIPContact, paymentSourceID: String, buyerAction: SQIPBuyerAction, locationID: String) -> SQIPVerificationParameters {
				return SQIPVerificationParameters(
					paymentSourceID: paymentSourceID,
					buyerAction: buyerAction,
					locationID: locationID,
					contact: contact
				)
			}

			func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didObtain cardDetails: SQIPCardDetails, completionHandler: @escaping (Error?) -> Void) {

				self.card = cardDetails

				if (self.parent.verifyBuyer != nil) {

					let params = makeVerificationParameters(
						contact: self.parent.verifyBuyer!.contact,
						paymentSourceID: cardDetails.nonce,
						buyerAction: .charge(self.parent.verifyBuyer!.money!),
						locationID: self.parent.verifyBuyer!.locationID
					)

					SQIPBuyerVerificationSDK.shared.verify(with: params, theme: self.parent.theme, viewController: cardEntryViewController) { (details) in
						self.parent.completion(self.card!, details) { response in
							completionHandler(response)
						}
					} failure: { error in
						completionHandler(error)
					}

				} else {
					self.parent.completion(cardDetails, nil) { response in
						completionHandler(response)
					}
				}
			}

			func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didCompleteWith status: SQIPCardEntryCompletionStatus) {
				switch status {
				case .canceled:
					cardPay.dismiss()
				case .success:
					cardPay.dismiss()
				}
			}
		}
	}
}
