# Use an official Python runtime as a parent image
FROM python:3.6-alpine

# Set the working directory to /app
WORKDIR /group_service

# Copy the current directory contents into the container at /app
COPY . /group_service

RUN apk add py-mysqldb
RUN apk add --no-cache mariadb-dev build-base

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

# Make port 4100 available to the world outside this container
EXPOSE 4100

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]