# diaspora-docker

This project allows you to quickly and easily set up a Diaspora pod running inside a 
collection of Docker containers. It allows users to run
Diaspora with a minimum of system administration, and a minimum of knowledge
of Unix, databases, web servers, etc. 

# To use this project

1. Install Docker and (optionally) install Docker Compose. 

3. Run `docker pull koehn/diaspora:latest` to use an image pre-built from the latest Diaspora source code. 

4. Set up a database, redis, etc (see the [compose directory](https://gitlab.koehn.com/docker/diaspora/tree/master/compose) for an easy way to do this). 

5. Configure diaspora to use the database, redis, etc you set up above. Again, the [docker-compose configuration](https://gitlab.koehn.com/docker/diaspora/tree/master/compose) file does this all for you. 

# What this project does

This project builds an image that follows the [official wiki instructions](https://wiki.diasporafoundation.org/Installation/Debian/Jessie)
for installing Diaspora on Debian. By default, it uses the [current Diaspora code](https://github.com/diaspora/diaspora/tree/master)
to drive the installation process, but you can build an image based off of another 
repository/branch; see below for more information about building custom images. 

The resulting image will include all the diaspora code, RVM, Postgres Driver, package dependencies, 
Ruby Gems, etc. It creates and uses a `diaspora` user in the image, under which the
code is actually run. All you need to supply is a database and redis server (again,
using the files supplied in the [compose directory](https://gitlab.koehn.com/docker/diaspora/tree/master/compose)
is the simplest way to go about this). 

# Upgrading

When a new version of Diaspora is released, I publish a new image to [Docker Hub](https://hub.docker.com/r/koehn/diaspora/).
You can pull the latest version into your machine using `docker pull koehn/diaspora`. 
The next time you start your application you'll get the latest build, and the latest set
of database migrations will be installed automatically.

# Making and pushing your own image
The `build` script included will (on *nix systems) build and push your image. You can run it with the following
arguments: 

`--git-url url`
: Sets the URL that is used to fetch your Diaspora code.

`--diaspora-version version`
: Sets both the git tag used to fetch the Diaspora code you want to build, and sets the label of the image.

`--ruby-version version` 
: See `RUBY_VERSION`, below.

`--gem-version version`
: See `GEM_VERSION`, below.

`--image-name`
: The name of the image pushed. Defaults to `koehn/diaspora`.

`--scanner-token`
: See `SCANNER_TOKEN`, below.

# Customizing your own image

The Dockerfile accepts several build arguments to customize the build:

`GIT_URL`
: Specifies the repository from which the Diaspora code should be cloned. Defaults to
the official Diaspora Git Repository (https://github.com/diaspora/diaspora.git)

`GIT_BRANCH`
: Specifies the branch or tag to be checked out from the above repository. Defaults to
`master`

`RUBY_VERSION`
: The version of Ruby to be installed by RVM. Defaults to `2.4` per the installation
instructions, and will install the latest version in the 2.4 series. 

`GEM_VERSION`
: The version of Gem to be installed. Defaults to `2.6.14` per the installation instructions. 

`SCANNER_TOKEN`
: You can scan the image for vulnerabilities with [MicroScanner](https://github.com/aquasecurity/microscanner).
You'll need to generate your own token (see the link above for instructions). Scanning is disabled
if no token is provided.

These arguments allow you to use your own version of Diaspora and its tooling to make
your own images. When building your image with `docker build`, simply specify the values
you want with `--build-arg [argument]=[value]` e.g., 
`docker build --build-arg GIT_BRANCH=develop .`. 

# How “official” images are produced

When a new version of Diaspora is released, I run this script twice. Once with the `--diaspora-version` 
flag set to the current version number, and once without, to build `master` and tag `latest`. It's
about that simple. 

# Vulnerability scan
Starting with 0.7.9.0, support was added for [MicroScanner](https://github.com/aquasecurity/microscanner), a
tool that scans images for vulnerabilities. The official images include a report in `/microscanner.html`
where you can see the vulnerabilities of the various components installed. 
