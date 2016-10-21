# android-gradle
[![android-gradle](http://dockeri.co/image/cangol/android-gradle)](https://hub.docker.com/r/cangol/android-gradle/)

## Included
* OpenJDK 8
* Git
* Gradle 2.14.1
* Android SDK (android-23,android-24)
* Android Build-tools (23.0.0,23.0.1,23.0.2,23.0.3,24.0.0,24.0.1,24.0.2,24.0.3)
* Android System Images(sys-img-armeabi-v7a-android-23,sys-img-armeabi-v7a-android-24)
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
docker run --tty --interactive --volume=$(pwd):/opt/workspace --workdir=/opt/workspace --rm lerk/android  /bin/sh -c "./gradlew build"
```
