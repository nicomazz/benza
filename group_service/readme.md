# Requirements
- Flask
- Redis
- flask-restplus

# Usage
- Install Docker.
- Build Docker image: `sudo docker build -t notification_service`.
- Run the docker image: `sudo docker run -p 4000:4000 notification_service`.

# Working on the service
- Like Nicolò said, start the server with `python app.py`.
- Open `localhost:4000` (can be in command line or browser, just make sure the server is running before you open it).
- Server should reload automatically after every change made to `app.py`, so there should be no need to open and close a hundred times while you're working on it.


