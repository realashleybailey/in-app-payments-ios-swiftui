//
//  File.swift
//  
//
//  Created by Ashley Bailey on 19/12/2021.
//

import Foundation

import SquareInAppPaymentsSDK
import SquareBuyerVerificationSDK


/// This struct is used to provide data needed to enable Verify Buyer in either the CardPay or SavedCards extension
///
/// ```
///  var contact = SQIPContact()
///  contact.firstName = "John"
///  contact.givenName = "Doe"
///  contact.city = "London"
///
///  SQIPVerifyBuyerSwiftUI("Square Location ID",
/// ```
/// - Warning: This is not an official Square Struct and was imported using the SquareInAppPaymentsSwiftUI package
///

public func SQIPCardBrandToText(_ brand: SQIPCardBrandSwiftUI) -> String {
	switch brand {
		case .otherBrand:
			return "otherBrand"
		case .visa:
			return "visa"
		case .mastercard:
			return "mastercard"
		case .americanExpress:
			return "americanExpress"
		case .discover:
			return "discover"
		case .discoverDiners:
			return "discoverDiners"
		case .JCB:
			return "JCB"
		case .chinaUnionPay:
			return "chinaUnionPay"
		case .squareGiftCard:
			return "squareGiftCard"
		case .applePay:
			return "applePay"
	}
}

public func SQIPCardBrandToHumanReadableText(_ brand: SQIPCardBrandSwiftUI) -> String {
	switch brand {
		case .otherBrand:
			return "Card"
		case .visa:
			return "Visa"
		case .mastercard:
			return "MasterCard"
		case .americanExpress:
			return "American Express"
		case .discover:
			return "Discover"
		case .discoverDiners:
			return "Discover Diners"
		case .JCB:
			return "JCB"
		case .chinaUnionPay:
			return "China Union Pay"
		case .squareGiftCard:
			return "Gift Card"
		case .applePay:
			return "Apple Pay"
	}
}

public struct SQIPVerifyBuyerSwiftUI {
	
	public init(_ locationID: String, _ contact: SQIPContact, _ money: SQIPMoney? = nil) {
		self.locationID = locationID
		self.contact = contact
		
		self.money = money
	}
	
	public let locationID: String
	public let contact: SQIPContact
	
	public let money: SQIPMoney?
}

public struct SQIPCardDetailsSwiftUI {
	
	public init(id: String, cardBrand: SQIPCardBrandSwiftUI, last4: String) {
		self.id = id
		self.cardBrand = cardBrand
		self.last4 = last4
	}
	
	public let id: String
	public let cardBrand: SQIPCardBrandSwiftUI
	public let last4: String
}

public enum SQIPCardBrandSwiftUI {
	case otherBrand
	case visa
	case mastercard
	case americanExpress
	case discover
	case discoverDiners
	case JCB
	case chinaUnionPay
	case squareGiftCard
	case applePay
}

public func SQIPCardBrandToSwiftUI(brand: SQIPCardBrand) -> SQIPCardBrandSwiftUI {
	return SQIP.SQIPCardBrandToSwiftUI(brand)
}

public func SQIPCardBrandSwiftUIToText(brand: SQIPCardBrandSwiftUI) -> String {
	return SQIP.SQIPCardBrandSwiftUIToText(brand)
}
