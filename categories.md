---
layout: default
title: Categories
permalink: /categories/
---

<section class="page-heading">
  <h1>Categories</h1>
</section>

{% assign sorted_categories = site.categories | sort %}
{% for category in sorted_categories %}
  <section class="category-block" id="{{ category[0] | slugify }}">
    <h2>{{ category[0] }}</h2>
    {% for post in category[1] %}
      <article>
        <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%Y-%m-%d" }}</time>
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </article>
    {% endfor %}
  </section>
{% endfor %}
