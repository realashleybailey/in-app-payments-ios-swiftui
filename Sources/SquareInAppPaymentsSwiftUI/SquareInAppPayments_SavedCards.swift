//
//  File.swift
//
//
//  Created by Ashley Bailey on 19/12/2021.
//

import SwiftUI
import Foundation

import SquareInAppPaymentsSDK
import SquareBuyerVerificationSDK

extension SQIP {

	@available(iOS 14.0, *)
	public class savedCards {
		
		public static func present(theme: SQIPTheme? = SQIPTheme(), cards: [SQIPCardDetailsSwiftUI], selected: SQIPCardDetailsSwiftUI? = nil, addCardCompletion: @escaping (SQIPCardDetails, SQIPBuyerVerifiedDetails?, @escaping (Error?) -> Void) -> Void, addCardVerifyBuyer: SQIPVerifyBuyerSwiftUI?, completion: @escaping ((SQIPCardDetailsSwiftUI) -> Void), style: UIUserInterfaceStyle = .unspecified) {

			var current: SQIPCardDetailsSwiftUI = SQIPCardDetailsSwiftUI(id: "applePay", cardBrand: .applePay, last4: "0000")

			if (selected != nil) {
				current = selected!
			}

			let rootCard = SavedCardsView(cards: cards, selected: current, completion: completion, addCard_Completion: addCardCompletion, addCard_VerifyBuyer: addCardVerifyBuyer)

			let rootController = UIHostingController(rootView: rootCard)
			rootController.view.backgroundColor = .white

			let navigationController = UINavigationController(rootViewController: rootController)
			navigationController.modalPresentationStyle = .overFullScreen

			presentInKeyWindow(controller: navigationController, animated: true)
		}

		public static func dismiss() {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				getTopViewController()?.dismiss(animated: true)
			}
		}

		public struct button: View {

			@Environment(\.colorScheme) private var colorScheme

			@Binding var cards: [SQIPCardDetailsSwiftUI]
			@Binding var selectedCard: SQIPCardDetailsSwiftUI?

			var addCard_Completion: (SQIPCardDetails, SQIPBuyerVerifiedDetails?, @escaping (Error?) -> Void) -> Void
			var addCard_VerifyBuyer: SQIPVerifyBuyerSwiftUI?

			@State private var animate: Bool = true
			@State private var textTrans: Bool = true

			private let defaultMessage = "Select a Card"
			private let imagesize = 45
			private let timer = Timer.publish(every: 6, on: .current, in: .common).autoconnect()

			public init(cards: Binding<[SQIPCardDetailsSwiftUI]>, selected: Binding<SQIPCardDetailsSwiftUI?>, addCardCompletion: @escaping (SQIPCardDetails, SQIPBuyerVerifiedDetails?, @escaping (Error?) -> Void) -> Void, addCardVerifyBuyer: SQIPVerifyBuyerSwiftUI?) {

				self._cards = cards
				self._selectedCard = selected

				self.addCard_Completion = addCardCompletion
				self.addCard_VerifyBuyer = addCardVerifyBuyer
			}

			public var body: some View {
				Button(action: selectCard) {
					if selectedCard != nil {
						HStack {

							SQIPCardBrandSwiftUIToImage(selectedCard!.cardBrand)
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(width: CGFloat(imagesize), height: CGFloat(imagesize - 16))
								.overlay(RoundedRectangle(cornerRadius: 4).stroke(selectedCard?.cardBrand == .applePay ? Color.gray : Color.clear, lineWidth: 2))
								.cornerRadius(4)

							Spacer()

							if textTrans {
								if selectedCard?.cardBrand != .squareGiftCard && selectedCard?.cardBrand != .applePay {
									Text(SQIPCardBrandSwiftUIToText(selectedCard!.cardBrand) + "  " + String(selectedCard!.last4))
										.foregroundColor(colorScheme == .light ? .black : .white)
								}

								if selectedCard?.cardBrand == .applePay {
									Text("Apple Pay")
										.foregroundColor(colorScheme == .light ? .black : .white)
								}

								if selectedCard?.cardBrand == .squareGiftCard {
									Text("Gift Card")
										.foregroundColor(colorScheme == .light ? .black : .white)
								}
							} else {
								Text(defaultMessage)
									.foregroundColor(colorScheme == .light ? .black : .white)
							}

							Spacer()
						}
							.padding()
							.frame(height: 55)
							.background(colorScheme == .light ? Color.white : Color.black)
							.cornerRadius(4)
							.shadow(color: colorScheme == .light ? Color.black.opacity(0.06) : Color.clear, radius: 5, x: 5, y: 5)
							.overlay(RoundedRectangle(cornerRadius: 4).stroke(colorScheme == .dark ? Color.white : Color.clear, lineWidth: 1))
							.font(.system(size: 17, weight: .semibold))
							.onReceive(timer) { _ in
							if self.animate {
								withAnimation(.easeInOut(duration: 0.7)) {
									self.textTrans = !self.textTrans
								}
							}
						}

					} else {
						HStack {

							Image("otherBrand")
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(width: CGFloat(imagesize), height: CGFloat(imagesize - 16))
								.cornerRadius(4)

							Spacer()

							Text(defaultMessage)
								.foregroundColor(colorScheme == .light ? .black : .white)

							Spacer()
						}
							.padding()
							.frame(height: 55)
							.background(colorScheme == .light ? Color.white : Color.black)
							.cornerRadius(4)
							.shadow(color: colorScheme == .light ? Color.black.opacity(0.06) : Color.clear, radius: 5, x: 5, y: 5)
							.overlay(RoundedRectangle(cornerRadius: 4).stroke(colorScheme == .dark ? Color.white : Color.clear, lineWidth: 1))
							.font(.system(size: 17, weight: .semibold))
					}
				}
				.frame(minWidth: 100, maxWidth: 400)
				.frame(height: 55)
				.frame(maxWidth: .infinity)
				.accessibility(label: Text("Select a card", comment: "Accessibility label for select a card button"))
			}

			func selectCard() {

				let theme = SQIPTheme()
				theme.saveButtonTitle = "Add Card"

				savedCards.present(theme: theme, cards: self.cards, selected: self.selectedCard, addCardCompletion: self.addCard_Completion, addCardVerifyBuyer: self.addCard_VerifyBuyer) { newCard in
					self.selectedCard = newCard
					self.animate = false
				}
			}
		}

		private class ScrollViewBounce {
			init() {
				UIScrollView.appearance().bounces = false
			}

			deinit {
				UIScrollView.appearance().bounces = true
			}
		}
		private struct SavedCardsAlert: Identifiable {
			var id: String
			var name: String
			var text: String
		}

		@available(iOS 14.0, *)
		private struct SavedCardsView: View {

			@Namespace private var animation

			@State private var cards: [SQIPCardDetailsSwiftUI]
			@State private var selected: SQIPCardDetailsSwiftUI?

			@State private var isPresented: Bool = false
			@State private var alert: SavedCardsAlert?

			var completion: (SQIPCardDetailsSwiftUI) -> Void
			var addCard_Completion: (SQIPCardDetails, SQIPBuyerVerifiedDetails?, @escaping (Error?) -> Void) -> Void
			var addCard_VerifyBuyer: SQIPVerifyBuyerSwiftUI?

			init(cards: [SQIPCardDetailsSwiftUI], selected: SQIPCardDetailsSwiftUI, completion: @escaping (SQIPCardDetailsSwiftUI) -> Void, addCard_Completion: @escaping (SQIPCardDetails, SQIPBuyerVerifiedDetails?, @escaping (Error?) -> Void) -> Void, addCard_VerifyBuyer: SQIPVerifyBuyerSwiftUI?) {

				self.cards = cards
				self.selected = selected

				self.completion = completion
				self.addCard_Completion = addCard_Completion
				self.addCard_VerifyBuyer = addCard_VerifyBuyer
			}

			let scrollView = ScrollViewBounce()

			var body: some View {
				VStack {
					VStack(alignment: .leading, spacing: 45) {

						header

						ScrollView(.vertical, showsIndicators: false) {
							VStack(alignment: .leading, spacing: 2) {

								ForEach(cards, id: \.id) { card in
									SavedCardViewListItem(selected: self.$selected, id: card.id, cardType: card.cardBrand, last4: card.last4, animation: animation)

									Divider()
								}

								SavedCardViewListItem(selected: self.$selected, id: "applePay", cardType: .applePay, last4: "0000", animation: animation)

								Divider()

								HStack(alignment: .center) {
									Button(action: addCard) { addCardBtn }
								}.padding(.top, 30).frame(maxWidth: .infinity)

							}
						}

						Spacer()

					}
						.padding()
						.padding()
						.frame(maxWidth: .infinity)
						.padding(.top, 100)
				}
					.frame(maxHeight: UIScreen.main.bounds.height)
					.ignoresSafeArea(.keyboard)
					.ignoresSafeArea()
					.navigationBarTitleDisplayMode(.inline)
					.navigationBarItems(leading: Button(action: selectCard) { Text("Done") })
					.alert(item: $alert) { alert in
					Alert(title: Text(alert.name), message: Text(alert.text), dismissButton: .cancel())
				}
			}

			var header: some View {
				VStack(alignment: .leading, spacing: 2) {
					Text("Cards")
						.font(.system(size: 52, weight: .semibold))

					Text("You have \(self.cards.count) cards on file")
						.font(.system(size: 19, weight: .regular))
						.foregroundColor(.gray)
				}
			}

			var addCardBtn: some View {
				HStack(spacing: 4) {
					Image(systemName: "plus")
						.font(.system(size: 22, weight: .semibold))
					Text("Add Card")
						.font(.system(size: 17, weight: .regular))
				}.foregroundColor(.black)
			}

			func addCard() {
				let vc = UIHostingController(rootView: SavedCards_AddCardView(success: addCard_Success, canceled: addCard_Canceled, addCard_Completion: addCard_Completion, addCard_VerifyBuyer: addCard_VerifyBuyer))

				getTopViewController()?.navigationController?.pushViewController(vc, animated: true)
			}

			func addCard_Success(card: SQIPCardDetails) {
				getTopViewController()?.navigationController?.popViewController(animated: true)

				let id: String = card.nonce
				let brand: SQIPCardBrandSwiftUI = SQIPCardBrandToSwiftUI(card.card.brand)
				let last4: String = String(card.card.lastFourDigits)

				let newCard = SQIPCardDetailsSwiftUI(id: id, cardBrand: brand, last4: last4)
				self.cards.append(newCard)
				self.selected = newCard
			}

			func addCard_Canceled(card: SQIPCardDetails) {

			}

			func selectCard() {
				if self.selected != nil {
					savedCards.dismiss()
					self.completion(self.selected!)
					return
				}

				self.alert = SavedCardsAlert(id: UUID().uuidString, name: "Select a card", text: "Please select a card first")
			}
		}

		@available(iOS 14.0, *)
		private struct SavedCardViewListItem: View {

			@Binding var selected: SQIPCardDetailsSwiftUI?

			var id: String
			var cardType: SQIPCardBrandSwiftUI
			var last4: String

			let animation: Namespace.ID

			var body: some View {
				Button(action: { withAnimation { self.selected = SQIPCardDetailsSwiftUI(id: self.id, cardBrand: self.cardType, last4: self.last4) } }) {
					HStack {

						Image(SQIPCardBrandToText(cardType))
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: 50, height: 34)
							.overlay(RoundedRectangle(cornerRadius: 4).stroke(cardType == .applePay ? Color.gray : Color.clear, lineWidth: 2))
							.cornerRadius(4)
							.padding(.trailing, 10)

						if cardType == .squareGiftCard {
							Text("Gift Card")
								.foregroundColor(.black)
						}

						if cardType == .applePay {
							Text("Apple Pay")
								.foregroundColor(.black)
						}

						if cardType != .squareGiftCard && cardType != .applePay {
							(Text(SQIPCardBrandToHumanReadableText(cardType)) + Text("  •••• ") + Text(String(last4)))
								.foregroundColor(.black)
						}

						Spacer()

						if (self.selected != nil) {
							if (self.id == self.selected?.id) {
								withAnimation(.easeOut(duration: 0.2).delay(0)) {
									SavedCardViewListItemCheckBox
										.matchedGeometryEffect(id: "checkmark", in: animation)
								}
							}
						}

					}
						.padding(.vertical)
				}
			}

			var SavedCardViewListItemCheckBox: some View {
				Image(systemName: "checkmark.circle")
					.foregroundColor(.gray)
					.font(.system(size: 25, weight: .light))
			}
		}

		@available(iOS 14.0, *)
		struct SavedCards_AddCardView: View {

			var success: (SQIPCardDetails) -> Void
			var canceled: (SQIPCardDetails) -> Void

			var addCard_Completion: (SQIPCardDetails, SQIPBuyerVerifiedDetails?, @escaping (Error?) -> Void) -> Void
			var addCard_VerifyBuyer: SQIPVerifyBuyerSwiftUI?

			var body: some View {
				SavedCards_AddCard(success: success, canceled: canceled, addCard_Completion: addCard_Completion, addCard_VerifyBuyer: addCard_VerifyBuyer)
					.frame(maxHeight: UIScreen.main.bounds.height)
					.ignoresSafeArea(.keyboard)
					.ignoresSafeArea()
			}

		}

		@available(iOS 14.0, *)
		struct SavedCards_AddCard: UIViewControllerRepresentable {

			var success: (SQIPCardDetails) -> Void
			var canceled: (SQIPCardDetails) -> Void

			var addCard_Completion: (SQIPCardDetails, SQIPBuyerVerifiedDetails?, @escaping (Error?) -> Void) -> Void
			var addCard_VerifyBuyer: SQIPVerifyBuyerSwiftUI?

			class coordinator: SQIPCardEntryViewControllerDelegate {

				var parent: SavedCards_AddCard
				private var card: SQIPCardDetails?

				init(_ parent: SavedCards_AddCard) {
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

					if (self.parent.addCard_VerifyBuyer != nil) {

						let theme = SQIPTheme()
						theme.saveButtonTitle = "Add Card"

						let params = makeVerificationParameters(
							contact: self.parent.addCard_VerifyBuyer!.contact,
							paymentSourceID: cardDetails.nonce,
							buyerAction: .store(),
							locationID: self.parent.addCard_VerifyBuyer!.locationID
						)

						SQIPBuyerVerificationSDK.shared.verify(with: params, theme: theme, viewController: cardEntryViewController) { (details) in
							self.parent.addCard_Completion(self.card!, details) { response in
								completionHandler(response)
							}
						} failure: { error in
							completionHandler(error)
						}

					} else {
						self.parent.addCard_Completion(cardDetails, nil) { response in
							completionHandler(response)
						}
					}
				}

				func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didCompleteWith status: SQIPCardEntryCompletionStatus) {
					switch status {
					case .canceled:
						parent.canceled(self.card!)
						return
					case .success:
						parent.success(self.card!)
						return
					}
				}
			}

			func makeCoordinator() -> coordinator {
				coordinator(self)
			}

			func makeUIViewController(context: Context) -> SQIPCardEntryViewController {
				let ce = self.makeCardEntryViewController()
				ce.delegate = context.coordinator
				return ce
			}

			func updateUIViewController(_ uiViewController: SQIPCardEntryViewController, context: Context) {

			}

			func makeCardEntryViewController() -> SQIPCardEntryViewController {
				let theme = SQIPTheme()
				theme.saveButtonTitle = "Add Card"

				return SQIPCardEntryViewController(theme: theme)
			}
		}
	}
}
