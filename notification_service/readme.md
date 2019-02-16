# TODO
set up a listener so that the app can receive notifications

currently we can send notifications to users but they need to be "listening" while logged in to get the notification.

sending a notification currently looks like this

```
...
...
...
W/BiChannelGoogleApi(16562): [FirebaseAuth: ] getGoogleApiForMethod() returned Gms: com.google.firebase.auth.api.internal.zzal@80cedc4
W/DynamiteModule(16562): Local module descriptor class for com.google.firebase.auth not found.
I/FirebaseAuth(16562): [FirebaseAuth:] Loading module via FirebaseOptions.
I/FirebaseAuth(16562): [FirebaseAuth:] Preparing to create service connection to gms implementation
D/FirebaseAuth(16562): Notifying id token listeners about user ( Fu8rrjGWdFfjVxEMQ4hGvKtLFJ72 ).
D/FirebaseApp(16562): Notifying auth state listeners.
D/FirebaseApp(16562): Notified 0 auth state listeners.
```

# Best way to contribute to this service
to start the server: `python app.py`

Then, after every modification, the server will automatically reload.
To see the service in action: `localhost:4000` (while it's running)

# If you find problems in the previous procedure
After docker installation

to build the docker image: `sudo docker build -t notification_service .`

to run the docker image:  `sudo docker run -p 4000:4000 notification_service`