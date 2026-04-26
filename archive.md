---
layout: default
title: Archive
permalink: /archive/
---

<section class="page-heading">
  <h1>Archive</h1>
</section>

<section class="archive-list">
  {% for post in site.posts %}
    <article>
      <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%Y-%m-%d" }}</time>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </article>
  {% endfor %}
</section>
