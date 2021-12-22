//
//  File.swift
//  
//
//  Created by Ashley Bailey on 19/12/2021.
//

import Foundation

import SquareInAppPaymentsSDK
import SquareBuyerVerificationSDK
import SwiftUI

public class SQIP {

	class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
		
		if let nav = base as? UINavigationController {
			return getTopViewController(base: nav.visibleViewController)
			
		} else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
			return getTopViewController(base: selected)
			
		} else if let presented = base?.presentedViewController {
			return getTopViewController(base: presented)
		}
		return base
		
	}
	
	class func keyWindowPresentedController(base: UIApplication? = UIApplication.shared) -> UIViewController {
		var viewController = base?.keyWindow?.rootViewController
		
		if let presentedController = viewController as? UITabBarController {
			viewController = presentedController.selectedViewController
		}
		
		while let presentedController = viewController?.presentedViewController {
			if let presentedController = presentedController as? UITabBarController {
				viewController = presentedController.selectedViewController
			} else {
				viewController = presentedController
			}
		}
		
		return viewController!
	}
	
	class func presentInKeyWindow(controller: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
		DispatchQueue.main.async {
			UIApplication.shared.keyWindow?.rootViewController?
				.present(controller, animated: animated, completion: completion)
		}
	}
	
	class func presentInKeyWindowPresentedController(controller: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
		DispatchQueue.main.async {
			keyWindowPresentedController().present(controller, animated: animated, completion: completion)
		}
	}
	
	class func SQIPCardBrandToSwiftUI(_ brand: SQIPCardBrand) -> SQIPCardBrandSwiftUI {
		switch brand {
			case .otherBrand:
				return .otherBrand
			case .visa:
				return .visa
			case .mastercard:
				return .mastercard
			case .americanExpress:
				return .americanExpress
			case .discover:
				return .discover
			case .discoverDiners:
				return .discoverDiners
			case .JCB:
				return .JCB
			case .chinaUnionPay:
				return .chinaUnionPay
			case .squareGiftCard:
				return .squareGiftCard
		}
	}
	
	class func SQIPCardBrandSwiftUIToText(_ brand: SQIPCardBrandSwiftUI) -> String {
		switch brand {
			case .otherBrand:
				return "Card"
			case .visa:
				return "Visa"
			case .mastercard:
				return "Mastercard"
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
	
	@available(iOS 13.0, *)
	class func SQIPCardBrandSwiftUIToImage(_ brand: SQIPCardBrandSwiftUI) -> Image {
		switch brand {
			case .otherBrand:
				return Image("otherBrand")
			case .visa:
				return Image("visa")
			case .mastercard:
				return Image("mastercard")
			case .americanExpress:
				return Image("americanExpress")
			case .discover:
				return Image("discover")
			case .discoverDiners:
				return Image("discoverDiners")
			case .JCB:
				return Image("JCB")
			case .chinaUnionPay:
				return Image("chinaUnionPay")
			case .squareGiftCard:
				return Image("squareGiftCard")
			case .applePay:
				return Image("applePay")
		}
	}
	
}
