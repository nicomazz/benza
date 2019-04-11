# Benza

Benza is a mobile app developed by team "Bravo" as a project for a series of sustained study courses focused on software development at the University of Aberdeen.

![alt text](https://raw.githubusercontent.com/nicomazz/benza/master/demo_image.png)


The following technologies/languages/frameworks have been used:
- Flutter
   - Dart programming language
- Python
   - Flask
   - Flask-restplus
   - dataset
- Redis
- MySql
- Docker

## Developer Setup

You have to install git on your machine. [git installation](http://bfy.tw/2LY7).

To clone this repository, cd into the target folder and do: `git clone https://github.com/nicomazz/benza.git`

## How to commit
Follow an online detailed tutorial on how to use git. Here's a short referece.

If you create a new file, you have to add it to the version control: `git add path/to/new/file.txt`

When you've modified something, you can commit locally with: `git commit -m "A description of my changes" -a` 

When you're ok with your modification (it works) and you want to upload it so we can all use it: `git push`

If you want to delete all your changes, and return back to the previous commit status: `git checkout`

**BEFORE EVERY MODIFICATION** always do `git pull`, to get the latest version of the repo.

If you have any problems with git, try googling first :)

## Executing services locally
Install Docker on your machine

`docker-compose up` on the root directory et woilà. Every time you save your code, everything reloads automatically

To run only selected services: `docker-compose up service_name_1 service_name_2`. You can find service_names in docker-compose.yml.

To interact via the rest AOI, open a web browser and go to the default Docker URL (e.g. `0.0.0.0:4000` for the notification service).

Your default URL might be different, you can find it when you start docker in command line (it'll be one of the first things Docker prints out).


## Rebuild in case of problems
`docker-compose build --no-cache service_name`


## Multiple machine deploy 
Don't read this part if you don't really need to.

Init swarm: `sudo docker swarm init --advertise-addr $(hostname -i)`

To add nodes follow the instructions produced by the previous command.
something like `docker swarm join --token a_token 1.1.1.1:2377`

## File Structure
```
benzaApp
   └── lib                                            - Contains all of the Flutter code
         ├── models                                   - Where objects are made, attrs defined
         |     ├── Group.dart
         |     ├── Offer.dart
         |     ├── Position.dart                      - Must change to suit GoogleMaps integration
         |     ├── User.dart
         |     └── UserInGroup.dart
         |
         ├── pages                                    - Structure of pages in the Flutter app
         |     ├── home_page.dart                     - The basic layout of the app (home of the navbar)
         |     ├── placeholder_page.dart              - from flutter app template (unnecessary)
         |     ├── chat
         |     |    └── chat_page.dart                - Chat page for the group that current user is in
         |     |
         |     ├── groups
         |     |    ├── create_group_page.dart       - Create a group
         |     |    ├── group_detail_page.dart       - View of one group (tap one of the groups from the list)
         |     |    ├── group_list_item.dart         - Elements of the list (includes map tile, group name, people inside etc.)
         |     |    └── group_list_page.dart         - The page that the list is displayed on
         |     |
         |     ├── login
         |     |    ├── login_page.dart
         |     |    └── signup_page.dart
         |     |
         |     └── profile
         |          ├── profile_page.dart
         |          └── rating_widget.dart 
         |
         ├── resources
         |     ├── mock
         |     |    ├── group_mock_provider.dart
         |     |    └── user_mock_provider.dart
         |     |
         |     └── group_provider.dart                - Code to query the group web service
         |
         ├── services
         |     ├── map_utilities.dart                 - Interfaces with OpenStreetMap, widget grabs appropriate map tile
         |     ├── gmaps.dart                         - Interfaces with Google Maps API
         |     └── user_management.dart               - Interfaces with Firebase Console for adding new User/updating dp
         |
         └── main.dart                                - Initialise the app, check for auth, load landing page
```
