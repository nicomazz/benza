# Use an official Python runtime as a parent image
FROM python:3.6-alpine

# Set the working directory to /app
WORKDIR /matching_service

# Copy the current directory contents into the container at /app
COPY . /matching_service

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

# Make port 4200 available to the world outside this container
EXPOSE 4200


# Run app.py when the container launches
CMD ["python", "app.py"]