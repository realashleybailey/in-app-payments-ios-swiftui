---
permalink: /usage/savedcards/
layout: default
---

<nav class="navbar navbar-expand-lg navbar-light">
  <div class="collapse navbar-collapse">
    <div class="navbar-nav">
        <a class="nav-item nav-link btn" style="background-color: rgb(0 0 0 / 8%); border-color: rgb(0 0 0 / 20%);" href="../../usage">
            <span style="margin-right: 5px; margin-left: 5px;"><i class="fas fa-arrow-left" style="margin-right: 5px;"></i> Back</span>
        </a>
    </div>
  </div>
</nav>

# Add Saved Cards to your project
Saved Cards is a multi use Card Selection form that returns a ccof:nonce_here through a completion block to allow you to proccess the transaction.

> **Example Application** <br>
> To see an example Swift application [click here](../../example/savedcards/)

## Struct Types

* [SQIPCardDetailsSwiftUI()](../../types/SQIPCardDetailsSwiftUI)
* [SQIPCardBrandSwiftUI()](../../types/SQIPCardBrandSwiftUI)
* [SQIPContact()](../../types/SQIPContact)

## Steps

1. Add imports to the top of the file

    > Even though you interface with **SquareInAppPaymentsSwiftUI** you still have to import **SquareBuyerVerificationSDK** and **SquareInAppPaymentsSDK** so that you can use some of its Struct Types that let you pass data in.

    ````
    import SwiftUI
    import SquareInAppPaymentsSwiftUI
    
    import SquareBuyerVerificationSDK
    import SquareInAppPaymentsSDK
    ````

2. Create a button in your view

    ````
    var body: some View {
        VStack {
            Button("Saved Cards", action: savedCardsAction)
        }
    }
    ````

3. Add States to the top of your project so we can persist data

    > **@State var cards**
    >
    > This state variable will store an array of cards that will be presented to the use when they open the card selection screen.

    > **@State var selectedCard**
    >
    > This state variable will store the currently selected card in the list of cards and can be accessed at any time to retrieve the **ccof:nonce_here** and card information.

    ````
    @State var cards: [SQIPCardDetailsSwiftUI] = []
    @State var selectedCard: SQIPCardDetailsSwiftUI? = nil

    var body: some View {
        VStack {
            Button("Saved Cards", action: savedCardsAction)
        }
    }
    ````

4. Add the Saved Cards initilizer function

    You will see in our function that there is alot going on and this is because we are providing alot of functinality, here is a table of what it does:

    cards: | Provide a state variable that you have updated with an array of **SQIPCardDetailsSwiftUI()**, **See Step 5 for more information**.
    selected: | Provide it with a state variable that will be updated with the currently selected card.
    addCardCompletion: | This variable has to be provided a function similar to the [Card Pay](../cardpay) completion function, that will handle submitting card data to your own server to be saved and reprovided to be injected into the **@State var cards** so that a user can reuse previously added cards. **See Step 7 for more information.**
    addCardVerifyBuyer: | This variable is optional and can be set to nil if you don't want to implement [SCA](https://squareup.com/help/gb/en/article/7373-strong-customer-authentication-faq), however if you do please **See Step 6 on how to implement this**.
    completion: | This variable is provided a function the will be excuted when a use has selected a card and click done, see **Step null** for more information.

    > Verify Buyer can be set to ````nil```` if you do not want to verify the users card, see **Step 4** on how to create a Verify Buyer

    ````
    @State var cards: [SQIPCardDetailsSwiftUI] = []
    @State var selectedCard: SQIPCardDetailsSwiftUI? = nil

    var body: some View {
        VStack {
            Button("Saved Cards", action: savedCardsAction)
        }
    }

    func savedCardsAction() {
        SQIP.savedCards.present(cards: self.card, selected: self.selectedCard, addCardCompletion: savedCardsAddCard, addCardVerifyBuyer: buyer, completion: savedCardsCompletion)
    }
    ````

  5. How does the **@State var cards** work

      Upon launch of your application you will want to load card data into this variable so that it is accessible in  the card selection screen.

      **More about SQIPCardDetailsSwiftUI**

      id | This is the ccof nonce for the card as a string
      cardBrand | This is a type of [SQIPCardBrandSwiftUI](../../types/SQIPCardBrandSwiftUI) and represents the brand of card it belongs to.
      last4 | This is the last 4 digits of the card number as string

      Here is an example of how that would work.
      > You would obviously not store cards hard coded like this, you would bring them in through an API.

      ````
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
      ````

6. How to implement Verify Buyer

    To create a Verify Buyer create a ````let```` and assign it ````SQIPVerifyBuyerSwiftUI()````

    1. Create a ````let```` and assign string of Square Location ID
    2. Create a ````SQIPContact()```` and assign values

    > **How to find your Location ID:**
    >
    > 1. Go to [https://developer.squareup.com](https://developer.squareup.com).
    > 2. Click Developer Dashboard.
    >   1. Click on + New Application.
    >   2. Name the application and click on Create Application
    > 3. The Location ID(s) for your Square account can be found in the Locationstab   of your [Developer Dashboard](https://developer.squareup.com).
    >
    > Before copying the Location ID, check that the top of the page that you have selected either "Sandbox" or "Production".

    > **SQIPContact**
    >
    > You should build the [SQIPContact](https://developer.squareup.com/docs/api/in-app-payment/ios/Classes/SQIPContact.html) object with as many contact field  values as possible. 
    > You must provide the given name. 
    > The contact family name and city should be provided. 
    > The more complete the contact object, the lower the chance that the buyer is challenged by the card-issuing bank.

    > **SQIPMoney**
    >
    > **This is not needed for this implementation because we are not charging the customer, only storing there card**

    ````
    @State var cards: [SQIPCardDetailsSwiftUI] = []
    @State var selectedCard: SQIPCardDetailsSwiftUI? = nil

    var body: some View {
      VStack {
          Button("Saved Cards", action: savedCardsAction)
      }
    }

    func savedCardsAction() {

        // See above to find out where to get Location ID
        let locationID = "Your Location ID"

        // See above for more information on SQIPContact
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

        SQIP.savedCards.present(cards: self.card, selected: self.selectedCard, addCardCompletion: savedCardsAddCard, addCardVerifyBuyer: customer, completion: savedCardsCompletion)
    }

    ````

7. Create Add Card Completion function

    Add Card completion is run everytime a user clicks add card in the card selection menu, when they have entered there card details and pressed Save this function will run.

    You can Copy and Past this function into your project and enter your own methods inside.

    > **How it works**
    >
    > How you choose to save the card nonce and verification token is up to you, we have provided an example below.
    >
    > The Card Nonce is provided at ````card.nonce```` and the Verification Token is provided at ````verify?.verificationToken````<br>
    > Verification Token is optional because it becomes ````nil```` if no verify buyer is provided to ````SQIP.savedCards.present()````
    
    > **completionHandler()**
    >
    > When saving the card is successfull call ````completionHandler(nil)```` inside the function to indicate a that you completed this successfully.
    >
    > When saving the card was **not** successfull then call ````completionHandler(error)````, error should be of type ````NSError```` for example:<br>
    > ````let error = NSError(domain: "", code: 0, userInfo: ["Save Error": "We could not save your card"])````
    
    ````
    @State var cards: [SQIPCardDetailsSwiftUI] = []
    @State var selectedCard: SQIPCardDetailsSwiftUI? = nil

    var body: some View {
      VStack {
          Button("Saved Cards", action: savedCardsAction)
      }
    }

    func savedCardsAction() {
        SQIP.savedCards.present(cards: self.card, selected: self.selectedCard, addCardCompletion: savedCardsAddCard, addCardVerifyBuyer: buyer, completion: savedCardsCompletion)
    }

	  func savedCardsAddCard(card: SQIPCardDetails, verify: SQIPBuyerVerifiedDetails?, completionHandler: @escaping (Error?) -> Void) {

	  }
    ````

    > **Example function for saving a card**
    >
    > Take the result of **````card````** and **````verify````** if you chose to verify buyers

    ````
    @State var cards: [SQIPCardDetailsSwiftUI] = []
    @State var selectedCard: SQIPCardDetailsSwiftUI? = nil

    var body: some View {
      VStack {
          Button("Saved Cards", action: savedCardsAction)
      }
    }

    func savedCardsAction() {
        SQIP.savedCards.present(cards: self.card, selected: self.selectedCard, addCardCompletion: savedCardsAddCard, addCardVerifyBuyer: buyer, completion: savedCardsCompletion)
    }

	func savedCardsAddCard(card: SQIPCardDetails, verify: SQIPBuyerVerifiedDetails?, completionHandler: @escaping (Error?) -> Void) {
                
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
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        
                // Return NSError to completionHandler() to indicate you was unsuccessfull at saving the card
                let error = NSError(domain: "", code: 0, userInfo: ["Save Error": "We could not save your card"])
                completionHandler(error)
        
                return
            }
        
            // Return nil to completionHandler() to indicate you have successfully saved the card
            completionHandler(nil)
        
            return
        }
        
	}
    ````

8. Card Selected completion handler

    When a card has been selected and the user has chose to click Done then we run the completion handler so that you can proccess the details how you would like.

    For example you may want to update the Checkout screen with information about there selected card and a button that says Pay using CARDNAME.

    Its your app you decide.

    Here is the what your completion function should look like:

    ````
	  func savedCardsCompletion(cardDetails: SQIPCardDetailsSwiftUI) {
		  
      // cardDetails is of type SQIPCardDetailsSwiftUI, read more on Step 5 about SQIPCardDetailsSwiftUI type.

	  }
    ````

## The Result

![iPhone App](../../images/SavedCardSelectCard.gif) | ![iPhone App](../../images/SavedCardAddCard.gif)

![iPhone App](../../images/SavedCardLog.png)