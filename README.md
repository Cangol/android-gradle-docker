# android-gradle-docker
```
Java 8
Gradle 2.14.1
Android 24.4.1
```
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
