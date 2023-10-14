# Docker Image for ArchGym
This repository hosts the latest Docker image for [ArchGym](https://github.com/srivatsankrishnan/oss-arch-gym) along with the Dockerfile.

The last image was built on October 13, 2023 for [MICRO 2023](https://sites.google.com/g.harvard.edu/micro23-maad-tutorial/home) and can be pulled using the following:
```
docker pull ghcr.io/shvetankprakash/arch-gym-container:micro_2023
```
and run using the following after:
```
docker run -it --name my-arch-gym-container ghcr.io/shvetankprakash/arch-gym-container:micro_2023
```

If you would like the most up to date version of ArchGym you should clone this repo and build the image from scratch using the Dockerfile. Follow the instructions listed [here](https://oss-archgym.readthedocs.io/en/latest/installation.html#a-docker-install).
