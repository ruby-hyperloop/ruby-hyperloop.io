---
title: Tutorials, Videos & Quickstarts
---

## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">C</span>hat-App Tutorial

We'll be building a simple but realistic chat application, a basic version of a chat room offered by a service like gitter.im.

![Screen](https://raw.githubusercontent.com/ruby-hyperloop/hyperloop-js-chatapp/master/hyperloopjschatappscreenshot.png)

You can find the complete source code of this tutorial here: [Hyperloop with Rails ChatApp](https://github.com/ruby-hyperloop/hyperloop-rails-chatapp)

### Tutorial

To set up your **Hyperloop** environment and continue this tutorial, please first follow the [Hyperloop installation with Ruby On Rails](/installation#rorsetup) tutorial.

After **Hyperloop** has been installed properly we can go further:

#### Step 1: Creating the Chatapp component

Run the hyperloop generator:

```
rails g hyper:component Chatapp
```

You can view the new Component created in `/app/hyperloop/components/`