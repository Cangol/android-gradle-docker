# android-gradle
[![android-gradle](http://dockeri.co/image/cangol/android-gradle)](https://hub.docker.com/r/cangol/android-gradle/)

## Included
* OpenJDK 8
* Git
* Gradle 6.5
* Android SDK (android-30)
* Android Build-tools (30.0.2)
* Android Support Libraries
* Google Play Services

## Build image

```bash
docker build -t cangol/android-gradle .
```

## Push build version to repository

```bash
docker push cangol/android-gradle
```

## Usage

### GitLab CI

This is what my .gitlab-ci.yml looks like:

```yaml
image: cangol/android-gradle
stages:
  - build

build:
  stage: build
  script:
    - gradlew build
  only:
    - master

```

### Without GitLab

```bash
docker pull cangol/android-gradle
```

Change directory to your project directory, then run:

```bash
docker run --tty --interactive --volume=$(pwd):/opt/workspace --workdir=/opt/workspace --rm cangol/android-gradle  /bin/sh -c "./gradlew build"
```
