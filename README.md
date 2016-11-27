# Firestarter

This is a platform to plan co-created events. It was originally created for Urban Burn Stockholm in 2016 and was then used for The Borderland in 2016. It's being continuously and sporadically developed by a rag-tag team and will probably always be in beta. This version was the adoption of the midburnerot - Israeli regional community. You can see it in action here: 
http://dreams.midburnerot.com
and the original system here:
http://dreams.theborderland.se/

## To get started

* Install ruby 2.3.0 (or any ruby will probably work).
* Install postgres - `brew install postgresql`
* Install imagemagick - `brew install imagemagick`
```
    gem install bundler # if needed
    bundle install
    bundle exec rake db:migrate
```
To get all the deps and the database set up properly. To start the server:

    bundle exec rails s

Now rails will listen at `localhost:3000` for your requests.

Go to `camps/new` to create a new camp and to `camps` to see a list of camps.

## There are tests

Run them with:

    bundle exec rspec spec

## Database

Currently sqlite is used as database. We will stick to this in development but set up
postgres in production. Install sqlite with your favourite package manager and you should
be up and running right away.

## Mail

In development mode [mailcatcher](http://mailcatcher.me/) is configured to catch emails
locally for easier testing.

## Ticket ID Import

Ticket ids are imported from a two column csv file of IDs, which is located in db/borderland_codes.csv
Rake task is in lib/tasks/import.rake and is run with "bundle exec rake import"

## Ticket verifier through TixWise

We added verification through tixwise - you need to aquire an API from them and then set `TICKETS_EVENT_URL` ENV variable to a url such as:
```
https://www.tixwise.co.il/he/api.xml?USER=useremail@gmail.com&PASS=userpass&TOKEN=api_token&VERSION=1.0&ACTION=event_listPurchases&id=event_id
```
make sure you change the username, password, token and event id

## Active Admin
Users and creations can be administrated with Active Admin. 
After install, run:
```
bundle exec rake db:migrate
bundle exec rake db:seed
```
Then naviagte to
http://localhost:3000/admin
and use `admin@example.com` and `password`

## TODO
Before final version, change "camps" to creations or dreams.

## Production

#### Email
To get the mailing system working on Heroku -
* Add Sendgrid as a Resource (this will automatically set SENDGRID_USERNAME & SENDGRID_PASSWORD)
* Update the email from using:
`heroku config:set EMAIL_FROM=postmaster@urbanburn.se`

#### Image upload
To set up the image upload make sure to create the S3 user and set the following heroku env variables
* `S3_BUCKET_NAME`
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

From our experience, if the s3 bucket didn't exist - it was automatically created on first time upload in case your user have write access to s3.
