---
title: Installation
---

# <span class="bigfirstletter">I</span>nstallation with Rails 5.1.0.rc1

### GEM dependencies issues

##### Sass-rails

Replace this line:

```
gem 'sass-rails', 'github: "rails/sass-rails"'
```

by this one:

```
gem 'sass-rails', '~> 5.0'
```

### Javascripts libraries

##### JQuery

Update your `/app/assets/javascripts/application.js` by adding:

```javascript
//= require jquery
//= require jquery_ujs
```

Note that these must be added before `//= require hyperloop-loader`
