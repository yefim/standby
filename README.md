Stand By
==========

Browse Your Favorite Content Without Wi-Fi



Getting on the Caltrain or a plane without Wi-Fi soon? Stuck for something to read? Let us help.

Stand By pre-fetches the best content from Hacker News, Reddit, Medium, and more - and our seamless browsing experience will make you forget you're actually offline.

We've already pre-fetched Hacker News, r/all, and some of the best of Medium. Turn off your Wi-Fi and see!


Installation
==========

We depend on

* ```node```
* ```redis```
* ```sass```
* ```coffeescript```

All of which need to be installed and in your PATH.

To install the node dependencies just run ```npm install```


Running
=========

* Run ```redis-server``` or ```redis-server &```

* Compile the CoffeeScript with ```coffee -cw public/scripts```

* Compile the Sass with ```sass --watch public/styles```

* Run ```coffee app.coffee``` and navigate to ```http://localhost:3000```
