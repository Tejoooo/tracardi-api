# Installation from source

## Software prerequisites

* Docker
* Python version 3.9 or 3.10 (for version 0.8.1+)
* Pip
* Python Virtual Environment
* PyCharm
* Git

Install the above software and we're ready to start.

# Launching Elasticsearch on Ubuntu

We have two options:

* Installing elasticsearch as a service
* Installing elasticsearch as a docker

## Elasticsearch as a service

The Elasticsearch components are not available in Ubuntu’s default package repositories. They can, however, be installed
with APT after adding Elastic’s package source list.

All of the packages are signed with the Elasticsearch signing key in order to protect your system from package spoofing.
Packages which have been authenticated using the key will be considered trusted by your package manager. In this step,
you will import the Elasticsearch public GPG key and add the Elastic package source list in order to install
Elasticsearch.

To begin, use cURL, the command line tool for transferring data with URLs, to import the Elasticsearch public GPG key
into APT. Note that we are using the arguments -fsSL to silence all progress and possible errors (except for a server
failure) and to allow cURL to make a request on a new location if redirected. Pipe the output of the cURL command into
the apt-key program, which adds the public GPG key to APT.

Open a terminal and enter:

```
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
```

Next, add the Elastic source list to the sources.list.d directory, where APT will look for new sources:

```
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
```

Next, update your package lists so APT will read the new Elastic source:

```
sudo apt update
```

Then install Elasticsearch with this command:

```
sudo apt install elasticsearch
```

Elasticsearch is now installed and ready to be configured.

### Elasticsearch configuration

To configure Elasticsearch, we will edit its main configuration file elasticsearch.yml where most of its configuration
options are stored. This file is located in the /etc/elasticsearch directory.

Use your preferred text editor to edit Elasticsearch’s configuration file. Here, we’ll use nano:

```
sudo nano /etc/elasticsearch/elasticsearch.yml
```

!!! Note

    Elasticsearch’s configuration file is in YAML format, which means that we need to maintain the indentation format. 
    Be sure that you do not add any extra spaces as you edit this file.

The elasticsearch.yml file provides configuration options for your cluster, node, paths, memory, network, discovery, and
gateway. Most of these options are preconfigured in the file but you can change them according to your needs. For the
purposes of our demonstration of a single-server configuration, we will only adjust the settings for the network host.

Elasticsearch listens for traffic from everywhere on port 9200. You will want to restrict outside access to your
Elasticsearch instance to prevent outsiders from reading your data or shutting down your Elasticsearch cluster through
its [REST API] (https://en.wikipedia.org/wiki/Representational_state_transfer). To restrict access and therefore
increase security, find the line that specifies network.host, uncomment it, and replace its value with localhost, so it
looks like this:

``` 
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
network.host: localhost
```

We have specified localhost so that Elasticsearch listens on all interfaces and bound IPs. If you want it to listen only
on a specific interface, you can specify its IP in place of localhost. Save and close elasticsearch.yml. If you’re using
nano, you can do so by pressing CTRL+X, followed by Y and then ENTER .

These are the minimum settings you can start with in order to use Elasticsearch. Now you can start Elasticsearch for the
first time.

Start the Elasticsearch service with systemctl. Give Elasticsearch a few moments to start up. Otherwise, you may get
errors about not being able to connect.

```bash
sudo systemctl start elasticsearch
```

### Testing elasticsearch

By now, Elasticsearch should be running on port 9200. You can test it with cURL and a GET request.

```
curl -X GET 'http://localhost:9200'
```

You should see the following response:

```
{
  "name" : "localhost",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "XHATygZ4R1C59dEXDUs-og",
  "version" : {
    "number" : "7.17.0",
    "build_flavor" : "default",
    "build_type" : "deb",
    "build_hash" : "bee86328705acaa9a6daede7140defd4d9ec56bd",
    "build_date" : "2022-01-28T08:36:04.875279988Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

If you see a response similar to the one above, Elasticsearch is working properly. If not, make sure that you have
followed the installation instructions correctly and you have allowed some time for Elasticsearch to fully start.


## Elasticsearch as a docker container

Open a terminal and enter:

```
docker run -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.13.2

``` 

You have run a single instance of elasticsearch in the console. When you want to stop it, press CTRL + C

!!! Tip

    If you want elasticsearch to run in the background, type: 
    `docker run -d -p 9200: 9200 -p 9300: 9300 -e "discovery.type = single-node" docker.elastic.co/elasticsearch/elasticsearch:7.13.2`

#### Redis

You will need a redis instance as well. 

Start it with:

```
docker run -p 6379:6379 redis
```

# Download the source code

Open a terminal and go to the directory where you want to keep the code. Enter:

```bash
git clone https://github.com/Tracardi/tracardi  #(1)
git clone https://github.com/Tracardi/tracardi-api #(2)
```

1. Clones tracardi repository. Code will be available in tracardi folder.
2. Clones tracardi-api repository

# Create virtual environments

Type:

```bash
cd tracardi-api
python3.9 -m venv venv  # (1)
cd ..
cd tracardi
python3.9 -m venv venv
```

1. Installs virtual environment with python 3.9 or 3.10 (for version 0.8.1+)

!!! Tip

    Before creating the virtual environment make sure you have version 3.9.x installed. Type `python --version` to see if the version is correct.

# Install dependencies

=== "Linux"

    ```bash
    # Activates virtual environment (1)
    cd tracardi-api
    source venv/bin/activate

    # Install wheel
    pip3 install wheel
    
    # Installs dependencies
    pip install -r app/requirements.txt
    
    # Run code (2)
    USER_NAME=admin PASSWORD=admin uvicorn app.main:application --host 0.0.0.0 --port 8686
    ```

    1. Only tracardi-api is required to run the API. Tracardi library will be installed as dependency.
    2. Sets default username: password as admin: admin and runs Tracardi API on port 8686.

=== "Windows"

    ```bash
    cd tracardi-api
    venv\Scripts\activate
    
    // Installs dependencies
    pip install -r app/requirements.txt
    
    // Run code 
    USER_NAME=admin PASSWORD=admin uvicorn app.main:application --host 0.0.0.0 --port 8686
    ```

=== "Mac OS"

    ```bash
    // Activates virtual environment
    cd tracardi-api
    source venv/bin/activate
    
    // Installs dependencies
    pip install -r app/requirements.txt
    
    // Run code
    USER_NAME=admin PASSWORD=admin uvicorn app.main:application --host 0.0.0.0 --port 8686
    ```

# Test access to documentation

Visit http://0.0.0.0:8686/docs

---
Summary

This documentation answers the following questions:

* How to install Tracardi from source?
* What are the software prerequisites for installation from source?
* What are the two options for launching Elasticsearch on Ubuntu?
* How do you install Elasticsearch as a service?
* How do you configure Elasticsearch?
* How do you install Elasticsearch as a docker container?
