pipeline {
  agent any

  environment {
    REPO_NAME = 'eclipsefdn'
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }

  triggers { 
    // build once a week to keep up with parents images updates
    cron('H H * * H') 
  }

  stages {
    stage('Build docker images') {
      agent {
        label 'docker-build'
      }
      steps {
        withDockerRegistry([credentialsId: '04264967-fea0-40c2-bf60-09af5aeba60f', url: 'https://index.docker.io/v1/']) {
          sh '''
            ./build.sh
          '''
        }
      }
    }
  }

  post {
    always {
      deleteDir() /* clean up workspace */
    }
  }
}