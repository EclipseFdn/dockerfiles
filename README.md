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
  build_arg drupal-node d10.3.13-n22.14.0 "--build-arg DRUPAL_VERSION=10.3.13 --build-arg NODE_VERSION=v22.14.0" latest
  build_arg drupal-node d11.1.3-n22.14.0 "--build-arg DRUPAL_VERSION=11.1.3 --build-arg NODE_VERSION=v22.14.0"
  ```
* https://github.com/EclipseFdn/dockerfiles/blob/master/Jenkinsfile
  ```
  stage('drupal-node') {
    steps {
      buildImage('drupal-node', 'd10.3.13-n22.14.0', 'drupal-node', ['DRUPAL_VERSION':'10.3.13', 'NODE_VERSION': 'v22.14.0'], true)
      buildImage('drupal-node', 'd11.1.3-n22.14.0', 'drupal-node', ['DRUPAL_VERSION':'11.1.3', 'NODE_VERSION': 'v22.14.0'])
    }
  }
  ```
### How can I set an image to have the latest tag?
`build.sh`
  * You will need to add `latest` as the last parameter on the line of the specific version as seen above.
    
`Jenkinsfile`
  * You will need to add `true` as the last parameter on the line of the specific version as seen above.
    
Please note, only one image can have the `latest` tag at a time.

### Why does a new image need to be added in two places (build.sh and Jenkinsfile)?

build.sh can be used for local testing. The Jenkinsfile is used during the CI build, leveraging the Jenkins pipeline library.
