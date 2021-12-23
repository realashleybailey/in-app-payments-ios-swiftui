---
permalink: /usage/cardpay/
layout: default
---

<nav class="navbar navbar-expand-lg navbar-light">
  <div class="collapse navbar-collapse">
    <div class="navbar-nav">
        <a class="nav-item nav-link btn" style="background-color: rgb(0 0 0 / 8%); border-color: rgb(0 0 0 / 20%);" href="../../">
            <span style="margin-right: 5px; margin-left: 5px;"><i class="fas fa-arrow-left" style="margin-right: 5px;"></i> Back</span>
        </a>
    </div>
  </div>
</nav>

# Add Card Pay to your project
Card Pay is a single use Card Input form that returns a cnon:nonce_here through a completion block to allow you to proccess the transaction.

> <strong>Example Application</strong><br>
> To see an example Swift application [click here](../../example/cardpay/)

## Steps

1. Add imports to the top of the file

    > Even though you interface with <strong>SquareInAppPaymentsSwiftUI</strong> you still have to import <strong>SquareBuyerVerificationSDK</strong> and <strong>SquareInAppPaymentsSDK</strong> so that you can use some of its Struct Types that let you pass data in.

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
            Button("Card Pay", action: cardPayAction)
        }
    }
    ````

3. Add the Card Pay initilizer action

    > Verify Buyer can be set to ````nil```` if you do not want to verify the users card, see <strong>Step 4</strong> on how to create a Verify Buyer

    ````
    var body: some View {
        VStack {
            Button("Card Pay", action: cardPayAction)
        }
    }

    func cardPayAction() {
        SQIP.cardPay.present(verifyBuyer: //Verify Buyer, completion: //Completion function )
    }
    ````

4. To create a Verify Buyer create a ````let```` and assign it ````SQIPVerifyBuyerSwiftUI()````

    1. Create a ````let```` and assign string of Square Location ID
    2. Create a ````SQIPContact()```` and assign values
    3. Create a ````SQIPMoney()```` and insert amount and currency

    > <strong>How to find your Location ID:</strong>
    >
    > 1. Go to [https://developer.squareup.com](https://developer.squareup.com).
    > 2. Click Developer Dashboard.
    >   1. Click on + New Application.
    >   2. Name the application and click on Create Application
    > 3. The Location ID(s) for your Square account can be found in the Locations tab of your [Developer Dashboard](https://developer.squareup.com).
    >
    > Before copying the Location ID, check that the top of the page that you have selected either "Sandbox" or "Production".

    > <strong>SQIPContact</strong>
    >
    > You should build the [SQIPContact](https://developer.squareup.com/docs/api/in-app-payment/ios/Classes/SQIPContact.html) object with as many contact field values as possible. 
    > You must provide the given name. 
    > The contact family name and city should be provided. 
    > The more complete the contact object, the lower the chance that the buyer is challenged by the card-issuing bank.

    > <strong> SQIPMoney</strong>
    >
    > [SQIPMoney](https://developer.squareup.com/docs/api/in-app-payment/ios/Classes/SQIPMoney.html) will charge the card payment source ID with amount in the specified currency
    >
    > | amount | Amount of money that will be charged (i.e 100 in GBP will be £1.00) |
    > | currency | The currency the payment source ID will be charged in. |

    ````

    var body: some View {
        VStack {
            Button("Card Pay", action: cardPayAction)
        }
    }

    func cardPayAction() {

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

        // See above for more information on SQIPMoney
        let money = SQIPMoney(amount: 100, currency: .GBP)

        let buyer = SQIPVerifyBuyerSwiftUI(locationID, contact, money)

        SQIP.cardPay.present(verifyBuyer: buyer, completion: //Completion function )
    }

    ````

5. Next you will need to create a completion function that will handle forwarding the card token to your own server to proccess the transaction.

    Copy and past this into your project

    > <strong>How it works</strong>
    >
    > How you choose to proccess the card nonce and verification token is up to you, we have provided an example below.
    >
    > The Card Nonce is provided at ````card.nonce```` and the Verification Token is provided at ````verify?.verificationToken````<br>
    > Verification Token is optional because it becomes ````nil```` if no verify buyer is provided to ````SQIP.cardPay.present()````
    
    > <strong>completionHandler()</strong>
    >
    > When payment is successfull call ````completionHandler(nil)```` inside the function to indicate a successfull transaction
    >
    > When the payment is <strong>not</strong> successfull then call ````completionHandler(error)````, error should be of type ````NSError```` for example:<br>
    > ````let error = NSError(domain: "", code: 0, userInfo: ["Transaction Error": "We could not proccess your transaction"])````
    
    ````

    var body: some View {
        VStack {
            Button("Card Pay", action: cardPayAction)
        }
    }

    func cardPayAction() {
        // Verify buyer as from above
        SQIP.cardPay.present(verifyBuyer: seeAbove, completion: proccessCardToken)
    }

    func proccessCardToken(card: SQIPCardDetails, verify: SQIPBuyerVerifiedDetails?, completionHandler: @escaping (Error?) -> Void) {
		
	}

    ````

    > <strong>Example function for proccessing a transaction</strong>
    >
    > Take the result of <strong>````card````</strong> and <strong>````verify````</strong> if you chose to verify buyers

    ````

    var body: some View {
        VStack {
            Button("Card Pay", action: cardPayAction)
        }
    }

    func cardPayAction() {
        // Verify buyer as from above
        SQIP.cardPay.present(verifyBuyer: seeAbove, completion: proccessCardToken)
    }

    func proccessCardToken(card: SQIPCardDetails, verify: SQIPBuyerVerifiedDetails?, completionHandler: @escaping (Error?) -> Void) {
                
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
        
                // Return NSError to completionHandler() to indicate unsuccessfull transaction
                let error = NSError(domain: "", code: 0, userInfo: ["Transaction Error": "We could not proccess your transaction"])
                completionHandler(error)
        
                return
            }
        
            // Return nil to completionHandler() to indicate successful transaction
            completionHandler(nil)
        
            return
        }
        
	}
    ````

## The Result

![iPhone App](../../images/CardPayMain.gif) | ![iPhone App](../../images/CardPayMainError.gif)

![iPhone App](../../images/CardPayLog.png)