# Kurage

*Kurage* is an anime recommendation engine aims to not suck.

[MyAnimeList][mal] is a service that lets anime fans keep track of the series they are watching and the series they have watched. The problem is that not much thought went behind their recommendation system. Recommendations on MAL are just a way of saying *"this series is similar to this other series"*. While that can be useful if you're looking for more of the same, what if you're interested in finding out what your friends have enjoyed?

*Kurage* tries to solve this by calculating a score for each series on your friends' lists from both their rating for that series and how similar their taste is to yours overall.

[mal]: http://myanimelist.net

## Requirements

* Ruby 1.8 or 1.9
* *nokogiri* and *open-uri* gems
* A MyAnimeList account
* Friends with MyAnimeList accounts

## Known Issues

* Anime in any category other than Completed is ignored. Recommendations are therefore limited to series that have ended airing, and anything you have dropped or have on hold may be suggested to you.
* Editing your own username or your list of friends currently requires you to change the source. This config could be done in some json/yaml file instead.
* Friends could just be scraped off of MAL instead of manually listing them. (The current behavior lets you add people who have good taste that aren't necessarily your friends in, so I'm not sure what I'm going to do about that.
* In a perfect world, this would be a gem you could easily install, but for now, I'm making you manually manage dependencies.
* Recommendations may suggest a second season to a series you haven't seen yet.
* Output isn't particularly pretty.
* The code is ugly and sucks, but my goal was to get it working first and then refine it.
