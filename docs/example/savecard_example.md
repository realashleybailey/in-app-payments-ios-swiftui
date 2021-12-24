---
permalink: /example/savedcards/
layout: default
---

<nav class="navbar navbar-expand-lg navbar-light">
  <div class="collapse navbar-collapse">
    <div class="navbar-nav">
        <a class="nav-item nav-link btn" style="background-color: rgb(0 0 0 / 8%); border-color: rgb(0 0 0 / 20%);" href="../../usage/savedcards">
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

    @State var cards: [SQIPCardDetailsSwiftUI] = []
    @State var selectedCard: SQIPCardDetailsSwiftUI? = nil

    var body: some View {

        VStack {

            Button("Saved Cards", action: savedCardsAction)

        }.onAppear(perform: loadCards)

	}

    func loadCards() {

       let cardArray = [
         SQIPCardDetailsSwiftUI(id: "ccof:U0bYCStJsGZgd0aW2s1T", cardBrand: .visa, last4: "4231"),
         SQIPCardDetailsSwiftUI(id: "ccof:LddaVqyH3qTJu7xWm3pP", cardBrand: .mastercard, last4: "4564"),
         SQIPCardDetailsSwiftUI(id: "ccof:ApKDGqzAht9PWaQSoSrG", cardBrand: .discover, last4: "9675"),
         SQIPCardDetailsSwiftUI(id: "ccof:oUTdqYcvT3gqpUAlxGBG", cardBrand: .discoverDiners, last4: "4262"),
         SQIPCardDetailsSwiftUI(id: "ccof:63IhTdqxiPWl3LVoqMdE", cardBrand: .JCB, last4: "7686"),
         SQIPCardDetailsSwiftUI(id: "ccof:fqLfOPESCaUkuINFL7y7", cardBrand: .americanExpress, last4: "6784"),
         SQIPCardDetailsSwiftUI(id: "ccof:sx0ep48oO9HXY344X3OJ", cardBrand: .chinaUnionPay, last4: "6546"),
         SQIPCardDetailsSwiftUI(id: "ccof:CN0sL2l9Oxx8BZ17o2Nw", cardBrand: .squareGiftCard, last4: "4325")
       ]

       self.cards = cardArray

    }

    func savedCardsAction() {

        let locationID = "Your Location ID"

        let contact = SQIPContact()
        contact.givenName = "John"
        contact.familyName = "Doe"
        contact.email = "johndoe@example.com"
        contact.addressLines = ["London Eye","Riverside Walk"]
        contact.city = "London"
        contact.country = "UK"
        contact.postalCode = "SE1 7"
        contact.phone = "8001234567"

        let customer = SQIPVerifyBuyerSwiftUI(locationID, contact)

        SQIP.savedCards.present(cards: self.card, selected: self.selectedCard,     addCardCompletion: savedCardsAddCard, addCardVerifyBuyer: customer, completion:     savedCardsCompletion)
    }

    func savedCardsAddCard(card: SQIPCardDetails, verify: SQIPBuyerVerifiedDetails?,   completionHandler: @escaping (Error?) -> Void) {

        let cardToken = card.nonce
        let verifyToken = verify?.verificationToken

        let httpBody = [
            "cardToken": cardToken,
            "verifyToken": verifyToken
        ]

        var request         = URLRequest(url: "https://example.com/api/savecard")
        request.httpMethod  = "POST"
        request.httpBody    = httpBody

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode     == 200 else {
             
                // Return NSError to completionHandler() to indicate you was unsuccessfull     at saving the card
                let error = NSError(domain: "", code: 0, userInfo: ["Save Error": "We  could not save your card"])
                completionHandler(error)

                return
            }

            // Return nil to completionHandler() to indicate you have successfully saved   the card
            completionHandler(nil)

            return
        }

    }

    func savedCardsCompletion(cardDetails: SQIPCardDetailsSwiftUI) {
		  
        // cardDetails is of type SQIPCardDetailsSwiftUI, read more on Step 5 about SQIPCardDetailsSwiftUI type.

    }
}

````