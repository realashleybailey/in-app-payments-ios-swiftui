<nav class="navbar navbar-expand-lg navbar-light">
  <div class="collapse navbar-collapse">
    <div class="navbar-nav">
	{% for p in site.pages %}
		{% if p.title %}
			{% if page.url == p.url %}
      			<a class="nav-item nav-link active" href="/in-app-payments-ios-swiftui{{ p.url }}">{{ p.title }}</a>
			{% else %}
			    <a class="nav-item nav-link" href="/in-app-payments-ios-swiftui{{ p.url }}">{{ p.title }}</a>
			{% endif %}
		{% endif %}
	{% endfor %}
    </div>
  </div>
</nav>