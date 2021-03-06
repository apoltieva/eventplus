# README
The Event+ app is a web application for selling/buying tickets for events.

URL: http://167.172.35.71/

* Ruby version 3.0.0
* Rails version 6.1.4
* PostgreSQL 14.0

Anyone can see and filter events, registered users can buy tickets, admins can
CRUD events, venues, and create performers for events.

It is a standard MVC framework with Rails back-end, HTML (Slime) /CSS/JS (Coffeescript) front-end, and Postgres database.

Incorporates natural language processing in the form of automatic keyword extraction
using TextRank algorithm (graph-rank gem).

Includes authentication with Devise, authorisation with Cancancan, integration with Stripe payment system, Rspec tests, deploy to Digital Ocean droplet using Capistrano, and Circle CI pipeline.

© SoftServe, creator - Anna Poltieva
