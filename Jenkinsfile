@Library('releng-pipeline@main') _

pipeline {
  agent {
    kubernetes {
      yaml loadOverridableResource(
        libraryResource: 'org/eclipsefdn/container/agent.yml'
      )
    }
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
    timeout(time: 90, unit: 'MINUTES')
  }

  environment {
    HOME = '${env.WORKSPACE}'
    NAMESPACE = 'eclipsefdn'
    CREDENTIALS_ID = '04264967-fea0-40c2-bf60-09af5aeba60f'
  }

  triggers {
    cron('H H * * H')
  }

  stages {
    stage('Build Images') {
      parallel {
        stage('nginx') {
          steps {
            buildImage('nginx', 'stable-alpine', 'nginx/stable-alpine-for-staging', [:], true)
            buildImage('nginx', 'stable-alpine-for-staging', 'nginx/stable-alpine-for-staging')
          }
        }

        stage('planet-venus') {
          steps {
            buildImage('planet-venus', 'debian-10-slim', 'planet-venus', [:], true)
          }
        }
        stage('kubectl') {
          steps {
            buildImage('kubectl', 'okd-c1', 'kubectl/okd-c1', [:], true)
          }
        }

        stage('hugo-node') {
          steps {
            buildImage('hugo-node', 'h0.76.5-n12.22.1', 'hugo-node', ['HUGO_VERSION':'0.76.5', 'HUGO_FILENAME':'hugo_0.76.5_Linux-64bit.deb','NODE_VERSION': 'v12.22.1'], true)
            buildImage('hugo-node', 'h0.99.1-n16.15.0', 'hugo-node', ['HUGO_VERSION':'0.99.1', 'HUGO_FILENAME':'hugo_0.99.1_Linux-64bit.deb','NODE_VERSION': 'v16.15.0'])
            buildImage('hugo-node', 'h0.110.0-n18.13.0', 'hugo-node', ['HUGO_VERSION':'0.110.0', 'NODE_VERSION': 'v18.13.0'])
            buildImage('hugo-node', 'h0.120.4-n18.18.2', 'hugo-node', ['DEBIAN_VERSION':'12-slim', 'HUGO_VERSION':'0.120.4', 'NODE_VERSION': 'v18.18.2'])
          }
        }

        stage('drupal-node') {
          steps {
            buildImage('drupal-node', 'd9.5.10-n18.18.2', 'drupal-node', ['DRUPAL_VERSION':'9.5.10', 'NODE_VERSION': 'v18.18.2'], true)
            buildImage('drupal-node', 'd10.2.2-n18.19.0', 'drupal-node', ['DRUPAL_VERSION':'10.2.2', 'NODE_VERSION': 'v18.19.0'])
          }
        }

        stage('stack-build-agent') {
          steps {
            buildImage('stack-build-agent', 'h79.1-n12.22.1-jdk11', 'stack-build-agent/h79.1-n12.22.1-jdk11', [:], true)
            buildImage('stack-build-agent', 'h111.3-n18.19-jdk17', 'stack-build-agent', ['JDK_VERSION':'17'])
            buildImage('stack-build-agent', 'h111.3-n18.19-jdk11', 'stack-build-agent')
            buildImage('stack-build-agent', 'h111.3-n18.19-jdk17', 'stack-build-agent', ['JDK_VERSION':'17'])
          }
        }

        stage('java-api-base') {
          steps {
            buildImage('java-api-base', 'j11-openjdk', 'java-api-base', ['JDK_VERSION':'11:1.17'], true)
            buildImage('java-api-base', 'j17-openjdk', 'java-api-base', ['JDK_VERSION':'17:1.17'])
          }
        }

        stage('containertools') {
          steps {
            buildImage('containertools', 'alpine-latest', 'containertools', [:], true)
          }
        }
      }
    }
  }

  post {
    always {
      deleteDir() /* clean up workspace */
      sendNotifications currentBuild
    }
  }
}

def buildImage(String name, String version, String context, Map<String, String> buildArgs = [:], boolean latest = false) {
  String distroName = env.NAMESPACE + '/' + name + ':' + version
  println '############ buildImage ' + distroName + ' ############'
  def containerBuildArgs = buildArgs.collect { k, v -> '--opt build-arg:' + k + '=' + v }.join(' ')

  container('containertools') {
    containerBuild(
      credentialsId: env.CREDENTIALS_ID,
      name: env.NAMESPACE + '/' + name,
      version: version,
      dockerfile: context + '/Dockerfile',
      context: context,
      buildArgs: containerBuildArgs,
      push: env.GIT_BRANCH == 'master',
      latest: latest,
      debug: true
    )
  }
}
