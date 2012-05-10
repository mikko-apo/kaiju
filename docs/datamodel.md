Data model
==========

There are a few main object types in Kaiju. These interact together and link to each other.

Items
=====
* Items can have any number of fields
* Default fields: item name, description, creator
* There can be default templates for items
* Items can link to other items and groups: sub task, split, rewrite, duplicate
* Items can include files
* Items have history

Tags
====
* Items can be tagged, tags maintain list of tagged items

Groups
======
* Groups can link to items or other groups
* Groups can maintain order of items
* Groups can include selection rules: include, exclude by item field, by group
* Selection rules can be saved to group
* Groups can include items dynamically (does not save attached items), automatically (items attached)

Processes
=========
* Processes describe how items go through different steps. Users can advance items forward and backward in the processes and even abort the process.
* Processes are used to automate how items are handled
* Item can have multiple processes at the same time
* Process examples
  * Request for comments from user/group
  * UX design needed

Views
=====
* Views collect information from different sources (items, groups, processes) and render them
* Graphs, summaries, editors

Projects
========
* Project contains items, groups, processes, views, defaults, user groups
* Project keeps chronological list of items

Users
=====
* User name, email

UserGroups
==========
* Can contain user groups and users

Access rights
=============
* Can include access rights
* Maps operations to users or user groups
