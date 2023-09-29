FROM ubuntu:22.04  as devcontainer

ENV DEBIAN_FRONTEND noninteractive

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1



RUN apt update && apt install -y software-properties-common nano tree
RUN add-apt-repository ppa:deadsnakes/ppa && apt update && apt install -y python3.11  
RUN  update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
RUN  update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 2
RUN  update-alternatives --config python3
# RUN  update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1


RUN apt install -y git sudo

RUN apt install -y libpq-dev gcc python3.11-dev

RUN apt install -y python3-pip


RUN  apt install -y python3.11-distutils
# Create group and user
RUN groupadd -r appuser && useradd -m -g appuser appuser
RUN usermod --shell /bin/bash appuser
RUN usermod -aG sudo appuser
RUN echo "appuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# Copy the requirements.txt file into the container at /tmp/requirements.txt
COPY requirements.txt /tmp/requirements.txt




# # Install any needed packages specified in requirements.txt
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt
USER appuser
# # Switch to the new user


 


# Use an official Python runtime as a parent image
FROM tiangolo/uvicorn-gunicorn:python3.11 as runcontainer
# Set the working directory in the container to /code
WORKDIR /code

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create group and user
RUN groupadd -r appuser && useradd --no-log-init -r -g appuser appuser

# Set the working directory in the container to /code
WORKDIR /code

# Copy the requirements.txt file into the container at /tmp/requirements.txt
COPY requirements.txt /tmp/requirements.txt

# Install any needed packages specified in requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

COPY .env /code/.env

# Copy the current directory contents into the container at /code
COPY ./app /code/app

# Change ownership of the /code/app directory to appuser
RUN chown -R appuser:appuser /code/app

# Switch to the new user
USER appuser

# Expose port 8080 for the app to be reachable
EXPOSE 8080

# Run the command to start Uvicorn
# Using port 8080 since ports below 1024 require root access.
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]

#
# Example:
# podman run -p 8080:8080 -v /path/to/logs:/code/app/logs -v /path/to/data:/code/app/data <IMAGE>
