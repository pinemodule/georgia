## Georgia

[![Gem Version](https://badge.fury.io/rb/georgia.png)](http://badge.fury.io/rb/georgia)
[![Build Status](https://travis-ci.org/georgia-cms/georgia.png?branch=master)](https://travis-ci.org/georgia-cms/georgia)
[![Code Climate](https://codeclimate.com/github/georgia-cms/georgia.png)](https://codeclimate.com/github/georgia-cms/georgia)
[![Coverage Status](https://coveralls.io/repos/georgia-cms/georgia/badge.png)](https://coveralls.io/r/georgia-cms/georgia)

Rails. Engine. CMS. Plug-and-play content management system for Ruby on Rails. Have a peak at the [demo](http://demo.georgiacms.org/admin) (demo@georgiacms.org // georgiacms).

### Features

* Media library on the cloud
* Spam filter on emails
* Multilingual from the get-go
* Review you pairs and draft new pages
* Preview before publishing
* Rollback to previous revisions when it hits the fan
* Great UI, nice search, gravatars
* Editable menus
* Extendable
* Widgets
* Slides
* Permission levels

### Why? aka Comparison with refinerycms

* Because diversity is good.
* Because Georgia is a Rails Engine. You can add to an existing application.
* Because it's prettier.
* Because the guys on refinerycms did a great job and you should check them out.
* Because it's easy to start a website and push to Heroku.

### Getting started

Add Georgia to your Gemfile

    gem 'georgia'

Make sure you have properly identify your default locale and possible available ones.
Georgia uses available_locales to know which translations should be configured or not.

``` ruby
config.i18n.default_locale = :en
config.i18n.available_locales = [:en]
```

Then run the generator to mount routes, run migrations & setup initial instances.

    rails generate georgia:install

We built Georgia to help you quickly develop an application with a CMS (Content Management System). However, we don't want to be in your way when you need to customize it.

    rails generate georgia:views

Start your server (`rails server`) and go to [http://localhost:3000/admin](http://localhost:3000/admin) to get started.

### Cloud Storage

Georgia's media library stores your documents and images on the cloud. You'll need to configure the solution that best fits your needs. Two options for you: Cloudinary or Custom Storage with Fog (e.g. Amazon S3, Rackspace Cloud Files)

#### Cloudinary

This will only work if you plan to have only pictures/images in your Media Library. Cloudinary won't work for `.pdf` files and other documents.

1. Add cloudinary gem to your Gemfile.

    gem 'cloudinary'

2. Set storage to `:cloudinary` in the `config/initializers/georgia.rb` file.

    ``` ruby
    Georgia.setup do |config|
      ...

      # Storage
      config.storage = :cloudinary
    end
    ```

3. Open a Cloudinary Account

You can skip this step if you plan on using Heroku. Otherwise, take 10 seconds to open an account on Cloudinary if not already done. Download your `cloudinary.yml` file and add to your config folder.

#### Custom Storage

The `georgia:install` generator added a `carrierwave.example.rb` file to your initializers. Use it to configure your custom location.

### Heroku

Georgia will run smoothly and cheaply (read free) on Heroku but you will need certain addons to make it work, all free.

#### Sengrid

Add sendgrid addon to handle emails

    heroku addons:add sendgrid

Add sendgrid config to your production environment file

``` ruby
# Send emails via sendgrid
config.action_mailer.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV['SENDGRID_USERNAME'],
  :password       => ENV['SENDGRID_PASSWORD'],
  :domain         => 'heroku.com',
  :enable_starttls_auto => true
}
```

#### Bonsai

Add bonsai addon to handle elasticsearch

    heroku addons:add bonsai

Add `config/initializers/bonsai.rb` with:

    ENV['ELASTICSEARCH_URL'] = ENV['BONSAI_URL']

Create your elasticsearch indices with these commands:

*** After your first deploy *** You need tire installed on Heroku to perform this.

    heroku run rake environment tire:import CLASS=Georgia::Page FORCE=true
    heroku run rake environment tire:import CLASS=Ckeditor::Asset FORCE=true
    heroku run rake environment tire:import CLASS=Ckeditor::Picture FORCE=true
    heroku run rake environment tire:import CLASS=ActsAsTaggableOn::Tag FORCE=true

#### Cloudinary

Add cloudinary addon to handle media library cloud storage

    heroku addons:add cloudinary

#### Create your admin user

Finally, create your first admin user to access to web panel:

    heroku run rake georgia:seed

For more information, you can also follow these [instructions](https://gist.github.com/nz/2041121) to setup bonsai.io. More [here](https://devcenter.heroku.com/articles/bonsai) on heroku.com