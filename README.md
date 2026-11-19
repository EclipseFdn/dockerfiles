# Eclipse Foundation base Docker images

This is a list of base images that are used to run applications and builds on the Eclipse Foundation infrastructure.

## How to create a new image?

* Know the state of the art / best practices of building container images
  * https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
  * http://www.projectatomic.io/docs/docker-image-author-guidance/
  * https://cloud.google.com/solutions/best-practices-for-building-containers
* Handle OpenShift specifics
  * Support Arbitrary User IDs (https://docs.openshift.com/container-platform/3.11/creating_images/guidelines.html#use-uid)

### Example

If you want to add a new `drupal-node` image you will need to add a new line in two places:
* https://github.com/EclipseFdn/dockerfiles/blob/master/build.sh
  ```
  build_arg drupal-node d11-php8.5-n24 "--build-arg DRUPAL_VERSION=11-php8.5 --build-arg NODE_VERSION=v24.22.1 --build-arg NPM_VERSION=11" latest
  ```
* https://github.com/EclipseFdn/dockerfiles/blob/master/Jenkinsfile
  ```
  stage('drupal-node') {
    steps {
      buildImage('drupal-node', 'd11-php8.5-n24', 'drupal-node', ['DRUPAL_VERSION':'11-php8.5', 'NODE_VERSION': 'v24.22.1', 'NPM_VERSION': '11'], true)
    }
  }
  ```

### Drupal images: drupal-runtime and drupal-node

Drupal sites use two images:

* **`drupal-runtime`** (for example `d11-php8.5`): what deployed Drupal sites run. It has the PHP extensions and tools all our sites share (ldap, APCu, mariadb-client, vim, rsync), but no git, Node.js, npm or Yarn.
* **`drupal-node`** (for example `d11-php8.5-n24`): the build image, with git, Node.js and Yarn, used to run `composer install` and `yarn run production`.

Sites use a two-stage Dockerfile: they build in `drupal-node`, delete `node_modules`, and copy the result into `drupal-runtime`. gd (with FreeType, JPEG, PNG, WebP and AVIF) comes with the upstream `drupal` image. Sites only keep their own settings, such as `apcu.ini`. When adding a new PHP version, add both images.

### How specific should versions be?

* `DRUPAL_VERSION` (`drupal-runtime`, `drupal-node`): any `drupal:<tag>-apache` prefix, such as `11.4.10` or `11-php8.5`. Sites install their own Drupal core from `composer.lock`, so this mostly selects the PHP version. `11-php8.5` keeps PHP on 8.5 while picking up patch releases when the image is rebuilt.
* `NODE_VERSION`: an exact Node.js release, such as `v24.22.1`. To pick up a Node.js security release, bump it here and in the Jenkinsfile.
* `NPM_VERSION` (`drupal-node`): defaults to `11.1.0`. Pass `11` to get the newest npm 11.x instead, so it never downgrades the npm bundled with Node.js.

Name tags after the major version (for example `n24`, not `n24.22.1`). Sites then keep the same tag, and version bumps here reach them on their next rebuild.

### How can I set an image to have the latest tag?
`build.sh`
  * You will need to add `latest` as the last parameter on the line of the specific version as seen above.
    
`Jenkinsfile`
  * You will need to add `true` as the last parameter on the line of the specific version as seen above.
    
Please note, only one image can have the `latest` tag at a time.

### Why does a new image need to be added in two places (build.sh and Jenkinsfile)?

build.sh can be used for local testing. The Jenkinsfile is used during the CI build, leveraging the Jenkins pipeline library.
