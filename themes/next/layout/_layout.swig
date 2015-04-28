<!doctype html>
<html class="theme-next {% if theme.use_motion %}use-motion{% endif %} {% if theme.scheme %}theme-next-{{ theme.scheme | lower }}{% endif %}">
<head>
  {% include '_partials/head.swig' %}
  <title>{% block title %}{% endblock %}</title>

<!-- Schema.org markup for Google+ -->
<meta itemprop="name" content="{% block title %}{% endblock %}">
<meta property="og:description" content="{% if page.excerpt %}{{page.excerpt|striptags}}{%  elseif config.description %}{{config.description}}{% endif %}" />


<!-- Open Graph data -->
<meta property="og:title" content="{% block title %}{% endblock %}" />
<meta property="og:description" content="{% if page.excerpt %}{{page.excerpt|striptags}}{% elseif config.description %}{{config.description}}{% endif %}" />
<meta property="og:url" content="http://http://lauraluo.github.io" />
<meta property="og:site_name" content="{% block title %}{% endblock %}">
<meta property="og:type" content="article" />
<meta name="google-site-verification" content="q2qWotdLmcjEpi5o6MJsfOlusPeRI3mqljZj6Esj5aA" />


{% if page.photos %}
  {% for photo in page.photos %}
    {% if loop.first %}
      <meta itemprop="image" content="{{photo}}"> 
      <meta property="og:image" content="{{photo}}" />
    {% endif %}
  {% endfor %}
{%  else  %}
  <meta itemprop="image" content="/images/fb_share.jpg">
  <meta itemprop="image" content="/images/fb_share.jpg">
{% endif %}


</head>

<body>

  <div class="container one-column {% block page_class %}{% endblock %}">
    <div class="headband"></div>

    <div id="header" class="header">
      <div class="header-inner">
        {% include '_partials/header.swig' %}
      </div>
    </div>

    <div id="main" class="main">
      <div class="main-inner">
        <div id="content" class="content">
          {% block content %}{% endblock %}
        </div>
      </div>

      {% block sidebar %}{% endblock %}
    </div>

    <div id="footer" class="footer">
      <div class="footer-inner">
        {% include '_partials/footer.swig' %}
      </div>
    </div>

    <div class="back-to-top"></div>
  </div>

  <script type="text/javascript" src="{{ url_for(theme.vendors) }}/jquery/index.js?v=2.1.3"></script>

  {# This block is used to set options before any other scripts run #}
  {% block script_extra_before %}{% endblock %}

  {% include '_scripts/fancy-box.swig' %}
  {% include '_scripts/helpers.swig' %}
  {% include '_scripts/motion.swig' %}

  {% block script_extra %}{% endblock %}

  {% include '_scripts/mathjax.swig' %}
  {% block comment_system %}{% endblock %}

  {% include '_scripts/analytics/google-analytics.swig' %}
</body>
</html>
