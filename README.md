# Benza

Benza is a mobile app developed by team "Bravo" as project for "Principle of software engineering" couse in the University of Aberdeen. All the project is at the very beginning.



The following technologies/languages/frameworks has been used:
- Flutter
   - Dart programming language
- Python
   - Flask
   - Flask-restplus
   - dataset
- Redis
- MySql
- Docker

## Setup

You have to install git on your machine. [git installation](http://bfy.tw/2LY7).

to clone this repository, cd in the target folder and do: `git clone https://github.com/nicomazz/benza.git`

Then, to enter in it: `cd benza`

## How to commit
I advise to follow an online detailed tutorial on how to use git. Here a short referece.

If you create a new file, you have to add it to the version control: `git add path/to/new/file.txt`

When you have done modification somewhere, you can commit locally with: `git commit -m "A description of my changes" -a` 

When you're ok with your modification, and you want to upload all online: `git push`

If you want to delete all your changes, and return back at the previous commit status: `git checkout`

If you encounter any merge problems, gl.

If you know how to work with branches, it could be better.

**BEFORE EVERY MODIFICATION** always do `git pull`, to get the latest version of all.

## How to execute services locally
(of course, you need to install docker)

`docker-compose up` on the root directory et woilà. Every time you save your code, everything reloads automatically

to run only some services: `docker-compose up service_name_1 service_name_2`. You can find service_names in docker-compose.yml.


## Rebuild in case of problems
`docker-compose build --no-cache service_name`


## multiple machine deploy 
Don't read this part if you don't really need to.

init swarm: `sudo docker swarm init --advertise-addr $(hostname -i)`

To add nodes follow the isstructions produced by the previous command.
something like `docker swarm join --token a_token 1.1.1.1:2377`

## Interesting folders
- benzaApp: it contains the flutter app
   - lib: contains the flutter code
      - main.dart: Where magic happens
      - resources/group_provider.dart: code to query the group web service
- group/matching/notification_service: contains the code needed for each service.