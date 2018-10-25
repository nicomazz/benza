You have to install git on your machine. [git installation](http://bfy.tw/2LY7).

to clone this repository, cd in the target folder and do: `git clone https://github.com/nicomazz/benza.git`

Then, to enter in it: `cd benza`

# How to commit
If you create a new file, you have to add it to the version control: `git add path/to/new/file.txt`

When you have done modification somewhere, you can commit locally with: `git commit -m "A description of my changes" -a` 

When you're ok with your modification, and you want to upload all online: `git push`

If you want to delete all your changes, and return back at the previous commit status: `git checkout`

If you encounter any merge problems, check the internet for the solution.

If you know how to work with branches, it could be better.

**BEFORE EVERY MODIFICATION** always do `git pull`, to get the latest version of all.

# How to execute a service locally
Fist of all, install python3. (https://www.python.org/downloads/)[]

`cd service_name` (eg. `cd notification_service`)

only the first time you have to install dependencies: `sudo pip install -r requirements.txt`

then, to start the server `python app.py`


# Docker

Don't read this if you don't know what docker is.

## Server specific initializations

init swarm: `sudo docker swarm init --advertise-addr $(hostname -i)`
(optional) to add nodes follow the isstructions produced by the previous command.
something like `docker swarm join --token a_token 1.1.1.1:2377`


## Code modification
Do all the modification you want, then in the correct service:
`sudo docker build -t SERVICE_NAME .`
in which `SERVICE_NAME` must be replaced with the right service.

Once the building is completed, you can run the service with :
`sudo docker run -p 4000:80 SERVICE_NAME`
