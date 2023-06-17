# Container Images
OpenPipe uses a fedora base image over UBI due to a limitation of the [UBI End-User License Agreement (EULA)](https://developers.redhat.com/articles/ubi-faq#redistribution) which prohibits redistribution if non-UBI RPMs are added.

As a result, image builds and startup times are a little slower.
