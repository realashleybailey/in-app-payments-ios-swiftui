---
permalink: /example/cardpay/
layout: default
---

<nav class="navbar navbar-expand-lg navbar-light">
  <div class="collapse navbar-collapse">
    <div class="navbar-nav">
        <a class="nav-item nav-link btn" style="background-color: rgb(0 0 0 / 8%); border-color: rgb(0 0 0 / 20%);" href="../../usage/cardpay">
            <span style="margin-right: 5px; margin-left: 5px;"><i class="fas fa-arrow-left" style="margin-right: 5px;"></i> Back</span>
        </a>
    </div>
  </div>
</nav>

# Card Pay Example Application

> <strong>Do not copy and paste</strong><br>
> You should not copy and paste this, please use this as a visual representation for how to structure your implementation.

````

import SwiftUI
import SquareInAppPaymentsSwiftUI

import SquareBuyerVerificationSDK
import SquareInAppPaymentsSDK

struct ContentView: View {

	var body: some View {
            VStack {
                Button("Test Card Pay", action: cardPayAction)
            }
	}

	func cardPayAction() {

            let locationID = "M4F2GDAB4LD2H"
            
            let contact = SQIPContact()
            contact.givenName = "John"
            contact.familyName = "Doe"
            contact.email = "johndoe@example.com"
            contact.addressLines = ["London Eye","Riverside Walk"]
            contact.city = "London"
            contact.country = "UK"
            contact.postalCode = "SE1 7"
            contact.phone = "8001234567"

            let money = SQIPMoney(amount: 100, currency: .GBP)          
            let buyer = SQIPVerifyBuyerSwiftUI(locationID, contact, money)

            SQIP.cardPay.present(verifyBuyer: buyer, completion: cardsPayProccessCard)

	}

	func cardsPayProccessCard(card: SQIPCardDetails, verify: SQIPBuyerVerifiedDetails?, completionHandler: @escaping (Error?) -> Void) {

            let cardToken = card.nonce
            let verifyToken = verify?.verificationToken

            let httpBody = [
                "cardToken": cardToken,
                "verifyToken": verifyToken
            ]

            var request         = URLRequest(url: "https://example.com/api/pay")
            request.httpMethod  = "POST"
            request.httpBody    = httpBody

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                
                    // Return NSError to completionHandler() to deny transaction
                    let error = NSError(domain: "", code: 0, userInfo: ["Transaction Error": "We could not proccess your transaction"])
                    completionHandler(error)

                    return
                }

                // Return nil to completionHandler() to indicate successful transaction
                completionHandler(nil)

                return
            }

	}

}

````