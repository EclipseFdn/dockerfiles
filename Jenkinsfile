pipeline {
  agent any

  environment {
    REPO_NAME = 'eclipsefdn'
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }

  stages {
    stage('Build nginx') {
      agent {
        label 'docker-build'
      }
      steps {
        withDockerRegistry([credentialsId: '04264967-fea0-40c2-bf60-09af5aeba60f', url: 'https://index.docker.io/v1/']) {
          sh '''
            . build_init.sh

            build nginx stable-alpine latest
            build nginx stable-alpine-for-staging

            build planet-venus buster-slim latest
          '''
        }
      }
    }
  }

  post {
    always {
      agent {
        label 'docker-build'
      }
      sh '''
      docker logout
      '''
      deleteDir() /* clean up workspace */
    }
  }
}