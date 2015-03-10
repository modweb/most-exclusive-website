#Liftoff [![Hack jfols/liftoff on Nitrous.IO](https://d3o0mnbgv6k92a.cloudfront.net/assets/hack-l-v1-3cc067e71372f6045e1949af9d96095b.png)](https://www.nitrous.io/hack_button?source=embed&runtime=nodejs&repo=jfols%2Fliftoff&file_to_open=README.md)

Opinionated boilerplate to get your [Meteor](https://meteor.com) project off the ground written in literal coffeescript. Meteor v1.0.3.2.

Liftoff is designed to be a basic starting point for any Meteor project.

Check the demo! [liftoff.meteor.com](http://liftoff.meteor.com)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Quick Start](#quick-start)
- [Included Packages](#included-packages)
- [Recommended Packages](#recommended-packages)
- [Directory Structure](#directory-structure)
- [Deploy your app](#deploy-your-app)
  - [Meteor Deploy](#meteor-deploy)
  - [Manual Deploy](#manual-deploy)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Quick Start

Clone repo

```sh
git clone git@github.com:jfols/liftoff.git YOURPROJECTNAME
```

Get up in that project directory

```sh
cd YOURPROJECTNAME
```

If you *don't* have Meteor install, install it

```sh
curl https://install.meteor.com | /bin/sh
```

Fire up the engines

```sh
meteor
```

# Included Packages

- [iron:router](https://atmospherejs.com/iron/router) - The de facto standard routing package for Meteor
- [coffeescript](https://atmospherejs.com/meteor/coffeescript) - Yum
- [useraccounts:bootstrap](https://atmospherejs.com/useraccounts/bootstrap) - The Design Framework
- [accounts-password](https://atmospherejs.com/meteor/accounts-password) - Accounts with passwords
- [zimme:iron-router-active](https://atmospherejs.com/zimme/iron-router-active) - Simple template helpers to determine active routes
- [natestrauser:connection-banner](https://atmospherejs.com/natestrauser/connection-banner) - Automagically connection status banner
- [fezvrasta:bootstrap-material-design](https://atmospherejs.com/fezvrasta/bootstrap-material-design) - Beautification
- [fortawesome:fontawesome](https://atmospherejs.com/fortawesome/fontawesome) - Beautiful icons

# Recommended Packages

- [aldeed:autoform](https://atmospherejs.com/aldeed/autoform) - Magic forms
  - [aldeed:simple-schema](https://atmospherejs.com/aldeed/simple-schema) - Schemas for your collections
  - [aldeed:collection2](https://atmospherejs.com/aldeed/collection2) - Automatically validate your collections
- [percolate:synced-cron](https://atmospherejs.com/percolate/synced-cron) - Cron jobs


# Directory Structure

```
├── LICENSE
├── README.md
├── client
│   ├── css
│   │   └── main.css
│   ├── router
│   │   ├── config.litcoffee
│   │   ├── controllers.litcoffee
│   │   └── map.litcoffee
│   └── views
│       ├── layout
│       │   ├── header.html
│       │   ├── header.litcoffee
│       │   └── layout.html
│       ├── main.html
│       └── pages
│           ├── about.html
│           └── home.html
├── lib
│   └── config
│       └── accountsTemplates.litcoffee
├── public
└── server
    └── publications.litcoffee
```

# Deploy your app

There are several options to deploy your app.

## Meteor Deploy

You can use the free `meteor deploy` service (hosted by Meteor) or your can deploy to your own server.

```sh
meteor deploy yourapp.meteor.com
```

Or to your own domain using Meteor deploy by setting the `CNAME` of your domain to `origin.meteor.com`.

## Manual Deploy

We find the use of [Digital Ocean](https://www.digitalocean.com/?refcode=c7c4c94c1222) with [Meteor Up](https://github.com/arunoda/meteor-up/) to be the simplest and most cost effective hosting solution.
For a more robust database experience give [Compose](https://www.compose.io/mongodb/) a try.
