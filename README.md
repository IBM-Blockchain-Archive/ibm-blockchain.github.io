# Jekyll Starter Theme V2

A more "advanced" starter theme, see the 
[Jekyll Starter Theme V1](https://github.com/henrythemes/jekyll-starter-theme) for
a more "basic" version. The V2 includes:

- Shared (common) template/page building blocks using `_includes` e.g. `head.html`, `header.html`, `footer.html` etc.
- CSS preprocessing using Sass/SCSS e.g. `_settings.scss` with `$link-color` etc.
- Nav(igation) menu (auto-)built using a configuration / data block
- And more


```
├── _config.yml                  # site configuration
├── _includes                    # shared (common) building blocks
|   ├── head.html                #   page head e.g. meta, stylesheet, etc.
|   ├── header.html              #   header e.g. title, nav menu, etc.
|   └── footer.html              #   footer
├── _layouts
|   └── default.html             # master layout template
├── css
|   ├── _settings.scss           #   style settings/variables e.g. $link-color, etc.
|   └── style.scss               # styles in sass/scss
├── three.html                   # another sample page (in hypertext markup e.g. html)
├── two.md                       # another sample page (in markdown e.g. md)
└── index.md                     # index (start) sample page (in markdown e.g. md)
```

Becomes

```
└── _site                        # output build folder; site gets generated here
    ├── css
    |   └── style.css            # styles for pages (preprocessed with sass/scsss)
    ├── three.html               # another sample page
    ├── two.html                 # another sample page 
    └── index.html               # index (start) sample page
```


### CSS Preprocessing using Sass/SCSS

Step 1: Configure the CSS Preprocessing using Sass/SCSS. Add in  `_config.yml`:

``` yaml
sass:
  sass_dir: css
  style:    expanded
```

Step 2: Add a new `css/_settings.scss` partial (where you can add your global style settings) e. g.:

``` scss

$font-family:  Helvetica,Arial,sans-serif;

$link-color:   navy;
```

Step 3: Add the required front matter to `css/style.scss` and include (import) the settings e.g.:

```
---
###  turn on preprocessing by starting with required front matter block
---

@import 'settings';

body {
  font-family:     $font-family;
}

a, a:visited {
  color:           $link-color;
  text-decoration: none;
}

...
```



### Shared (Common) Page/Template Building Blocks Using `_includes`

Use shared building blocks to split-up the all-in-one default master layout page e.g.:

``` html
<!DOCTYPE html>
<html>

{% include head.html %}

<body>

{% include header.html %}

<div id="content">
  {{ content }}
</div>

{% include footer.html %}

</body>
</html>
```

In the new `_includes` folder, add the new building blocks e.g. `head.html`, `header.html`,
and `footer.html`.


### Nav(igation) Menu (Auto-)Built Using a Configuration Block

Instead of "hard-coding" the navigation menu e.g.:

``` html
<div id="nav">
  <a href="{{ '/index.html' | relative_url }}">Welcome</a>
  <a href="{{ '/two.html'   | relative_url }}">Page Two</a>
  <a href="{{ '/three.html' | relative_url }}">Page Three</a>
  <a href="http://groups.google.com/group/wwwmake">Questions? Comments?</a>
  <a href="https://github.com/henrythemes/jekyll-starter-theme">About</a>
</div>
```

Let's use a configuration / data block e.g.:

``` yaml
nav:
- { title: 'Welcome',              href: '/' }
- { title: 'Page Two',             href: '/two.html' }
- { title: 'Page Three',           href: '/three.html' }
- { title: 'Questions? Comments?', href: 'http://groups.google.com/group/wwwmake' }
- { title: 'About',                href: 'https://github.com/henrythemes/jekyll-starter-theme-v2' }
```

And (auto-)build the navigation menu using a macro e.g.:

``` html
<div id="nav">
{% for item in site.nav %}
  <a href="{{ item.href | relative_url }}">{{ item.title }}</a>
{% endfor %}
</div>
```


### Live Demo

See a live demo @ [`henrythemes.github.io/jekyll-starter-theme-v2` »](http://henrythemes.github.io/jekyll-starter-theme-v2)


### More Themes

See the [Dr. Jekyll's Themes](https://drjekyllthemes.github.io) directory.

### More Quick Starter Wizard Scripts

See the [Mr. Hyde's Scripts](https://github.com/mrhydescripts/scripts) library.



## Meta

**License**

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The starter theme is dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

**Questions? Comments?**

Post them to the [wwwmake forum](http://groups.google.com/group/wwwmake). Thanks!

