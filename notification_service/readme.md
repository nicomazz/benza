# Best way to contribute tu this service
to start the server: `python app.py`

Then, after every modification, the server automatically reload.
To se the service in action: `localhost:4000` (while it's running)

# If you find problems in the previous procedure
After docker installation

to build the docker image: `sudo docker build -t notification_service .`

to run the docker image:  `sudo docker run -p 4000:4000 notification_service`