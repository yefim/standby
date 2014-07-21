Stand By
==========

Browse Your Favorite Content Without Wi-Fi



Getting on the Caltrain or a plane without Wi-Fi soon? Stuck for something to read? Let us help.

Stand By pre-fetches the best content from Hacker News, Reddit, Medium, and more - and our seamless browsing experience will make you forget you're actually offline.

We've already pre-fetched Hacker News, Reddit, and some of the best of Medium. Turn off your Wi-Fi and see!

## TODO before launch

* [ ] Fix the 500s (Heroku Application Errors)
* [ ] Fix the page fetching errors
* [ ] Do not show the links with empty HTML (e.g., some NYTimes posts for some reason)
* [ ] Make the front page not just an image
* [ ] Do not start loading/caching anything until the user hits a button on the front page or something
* [ ] Disable the site while loading content and make the loading bar more obvious (take up the entire page or something)

## Wishlist

* Add Pocket
* Add Reddit Custom Frontpage
* Have users so we can save their tabs/visited links

## Installation

We depend on

* ```node```
* ```redis```
* ```sass```
* ```coffeescript```

All of which need to be installed and in your PATH.

To install the node dependencies just run ```npm install```


## Running

* Run ```redis-server``` or ```redis-server &```

* Compile the CoffeeScript with ```coffee -cw public/scripts```

* Compile the Sass with ```sass --watch public/styles```

* Run ```coffee app.coffee``` and navigate to ```http://localhost:3000```
