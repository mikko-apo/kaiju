kaiju
=====

Simple issue tracking system.

Goals
=====

* Flexible object model that supports complex scenarios out of the box: items and smart hierarchic groups  
* Git as storage medium: git's features provide powerful tools to issue tracking: branching, change history, merging, ...
* Smart UI: Drag'n'Drop ordering and process flows, mass input of items

Git revolutionized version control in many ways. Its flexible object model was a big step up from the
data models used by the previous version control systems. The flexible model allows it to describe
version control operations in an efficient way. Git also exposed powerful tools to the user and at the same
time made many operations much easier than before: branching, merging, distributed development.

As such, Git provides a good example of how to make revolutionary change: design solid and flexible core features
that support all required operations. Kaiju aims to make a same kind of change to issue tracking. Powerful
core features and easy to use user interface.

Technical stack
===============
* Ruby - Simple and powerful language
* Json - Data objects stored as json
* Git - The command line tool
* Some Ruby web framework
* Some javascript libraries: jquery, rx
* Sass, Coffeescript

Application code will have two parts: core and web site. Core will contain code to manage the data.
Web site will use core to display and update the data.

Web site has two parts
* User interface will be mostly server side code, with added JS goodies where needed.
* REST api available for everything

First steps
===========

1. Make core support and smart groups
  * projects: add, edit
  * items: add, edit
  * smart groups: include items, include groups, prioritizing
2. Make web site
  * all core features in web
  * wiki input
  * mass input
  * drag'n'drop prioritizing
3. ...
4. Profit ... not really, this is going to be open source & free