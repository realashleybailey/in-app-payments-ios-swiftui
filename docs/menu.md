<nav class="navbar navbar-expand-lg navbar-light">
  <div class="collapse navbar-collapse">
    <div class="navbar-nav">
	{% for p in site.pages %}
		{% if p.title %}
			{% if page.url == p.url %}
      			<p class="nav-item nav-link active" style="margin: 0px;">{{ p.title }}</p>
				<p class="nav-item nav-link d-none d-sm-none d-md-none d-lg-block d-xl-block" style="margin: 0px; padding-left: 0px; padding-right: 0px;">&#47;</p>
			{% else %}
			    <a class="nav-item nav-link" href="{% if page.url == '/' %}.{% else %}..{% endif %}{{ p.url }}">{{ p.title }}</a>
				<p class="nav-item nav-link d-none d-sm-none d-md-none d-lg-block d-xl-block" style="margin: 0px; padding-left: 0px; padding-right: 0px;">&#47;</p>
			{% endif %}
		{% endif %}
	{% endfor %}
    </div>
  </div>
</nav>