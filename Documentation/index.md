---
title: Home
permalink: /
layout: default
---

{% include_relative menu.md %} 

# Square In-App Payments iOS SDK SwiftUI
Build remarkable payments experiences in your SwiftUI app. This SDK is SwiftUI wrapper to the existing [In-App-Payments-SDK](https://raw.githubusercontent.com/square/in-app-payments-ios/) and is packed with everything you need to intergrate payments in your app.


# Information
While the project itself is stable it does rely on Squares In-App Payments SDK and updates to that SDK could break our implementaion so its on you to test your app fully before releasing to production.

# Recent Posts

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }} - {{ post.date || date_to_long_string }}</a>
    </li>
  {% endfor %}
</ul>