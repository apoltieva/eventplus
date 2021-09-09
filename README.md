# README
The Event+ app is a site for publishing/viewing local events
and venues.

* Ruby version 3.0.0

* Rails version 6.1.4

Venues consist of name, picture, location and maximum capacity

Events consist of title, description, picture, venue, artist (musician, band, lector etc, a string for the moment), start and end date-time, ticket price (not required, tickets may be free) and the total number of tickets

Anyone can see a list of future events (sorted by date and start time) with a number of available tickets

Users can register using email (confirmation is required) and password, sign in and sign out.

Users can buy tickets for events, more than one per person (at first we need a prototype where there is no actual buying flow, so the ticket is “bought” when a user pushes the “buy” button). Tickets are sent to the user’s email consisting of basic event information along with ticket ID (randomised human-readable string) and QR code with a unique long hash

Users can see how many tickets they have bought for each event, filter events using tabs “All events” and “Your events” (those for which tickets were bought)

Admins can CRUD events using appropriate buttons (links to new/edit pages and delete action that reloads the page) on the tickets list

Admins can CRUD venues in the same manner as events

Admins are pre-seeded in the database and can use the same sign-in/sign-out flow

Calendar input for start-end time of events

Map input for venue location

Scroll pagination for events

Filter for past events

© SoftServe, creator - Anna Poltieva
______________________________________________________________


