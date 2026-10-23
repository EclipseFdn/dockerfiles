@Library('releng-pipeline@main') _

pipeline {
  agent any

  options {
    skipDefaultCheckout()
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
    stage('Checkout Workspace') {
      steps {
        checkout scm
        stash(name: 'workspace', includes: '**')
      }
    }
    stage('Run Builds') {
      parallel {
        stage('nginx') {
          steps {
            buildImage('nginx', 'stable-alpine', 'nginx/stable-alpine', [:], true)
            buildImage('nginx', 'stable-alpine-for-staging', 'nginx/stable-alpine-for-staging')
          }
        }

        stage('kubectl') {
          steps {
            buildImage('kubectl', 'okd-c1', 'kubectl/okd-c1', [:], true)
          }
        }

        stage('hugo-node') {
          steps {
            buildImage('hugo-node', 'h0.120.4-n18.19.1', 'hugo-node', ['DEBIAN_VERSION':'12-slim', 'HUGO_VERSION':'0.120.4', 'NODE_VERSION': 'v18.19.1'])
            buildImage('hugo-node', 'h0.124.1-n20.11.1', 'hugo-node', ['DEBIAN_VERSION':'12-slim', 'HUGO_VERSION':'0.124.1', 'NODE_VERSION': 'v20.11.1'])
            buildImage('hugo-node', 'h0.144.2-n22.14.0', 'hugo-node', ['DEBIAN_VERSION':'12-slim', 'HUGO_VERSION':'0.144.2', 'NODE_VERSION': 'v22.14.0'], true)
            buildImage('hugo-node', 'h0.144.2-n24', 'hugo-node', ['DEBIAN_VERSION':'12-slim', 'HUGO_VERSION':'0.144.2', 'NODE_VERSION': 'v24.22.1'])
          }
        }

        stage('drupal-node') {
          steps {
            buildImage('drupal-node', 'd10.6.19-n22.14.0', 'drupal-node', ['DRUPAL_VERSION':'10.6.19', 'NODE_VERSION': 'v22.14.0'], true)
            buildImage('drupal-node', 'd11.4.10-n22.14.0', 'drupal-node', ['DRUPAL_VERSION':'11.4.10', 'NODE_VERSION': 'v22.14.0'])
            buildImage('drupal-node', 'd10-php8.4-n24', 'drupal-node', ['DRUPAL_VERSION':'10-php8.4', 'NODE_VERSION': 'v24.22.1', 'NPM_VERSION': '11'])
            buildImage('drupal-node', 'd11-php8.5-n24', 'drupal-node', ['DRUPAL_VERSION':'11-php8.5', 'NODE_VERSION': 'v24.22.1', 'NPM_VERSION': '11'])
          }
        }

        stage('stack-build-agent') {
          steps {
            buildImage('stack-build-agent', 'h111.3-n18.19-jdk11', 'stack-build-agent', [:], true)
            buildImage('stack-build-agent', 'h111.3-n18.19-jdk17', 'stack-build-agent', ['JDK_VERSION':'17'])
            buildImage('stack-build-agent', 'a3.19-h120-n20-jdk17', 'stack-build-agent', ['ALPINE_VERSION':'3.19', 'JDK_VERSION':'17', 'NODE_VERSION':'20.15.1-r0', 'NPM_VERSION':'10.2.5-r0', 'HUGO_VERSION':'0.120.4', 'YARN_VERSION':'1.22.19-r0'])
            buildImage('stack-build-agent', 'a3.22-h144-n22-jdk21', 'stack-build-agent', ['ALPINE_VERSION':'3.22', 'JDK_VERSION':'21', 'NODE_VERSION':'22.23.2-r0', 'NPM_VERSION':'11.6.4-r0', 'HUGO_VERSION':'0.144.2', 'YARN_VERSION':'1.22.22-r1'])
          }
        }

        stage('java-api-base') {
          steps {
            buildImage('java-api-base', 'j11-openjdk', 'java-api-base', ['JDK_VERSION':'11:1.17'])
            buildImage('java-api-base', 'j17-openjdk', 'java-api-base', ['JDK_VERSION':'17:1.22-1.1752621170'], true)
            buildImage('java-api-base', 'j21-openjdk', 'java-api-base', ['JDK_VERSION':'21:1.22-1.1752676422'])
          }
        }

        stage('native-build-agent') {
          steps {
            buildImage('native-build-agent', 'jdk21-n22', 'native-build-agent', ['NODE_VERSION':'v22.17.0'], true)
          }
        }

        stage('containertools') {
          steps {
            buildImage('containertools', 'alpine-latest', 'containertools', [:], true)
          }
        }

        stage('aws') {
          steps {
            buildImage('aws', 'alpine-latest', 'aws/alpine-latest', [:], true)
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
  String distroName = "${env.NAMESPACE}/${name}:${version}"
  def containerBuildArgs = buildArgs.collect { k, v -> "--opt build-arg:${k}=${v}" }.join(' ')
  def pushArg = "${env.BRANCH_NAME}" == 'master'

  println """
    "###### Build Image: ${distroName}
    * Version ${version}
    * Build Params ${buildArgs}
    * Build Args ${containerBuildArgs}
    * Dockerfile ${context}/Dockerfile
    * Push ${pushArg}
    * Latest ${latest}
    """
  podTemplate(yaml: loadOverridableResource(libraryResource: 'org/eclipsefdn/container/agent.yml')) {
    node(POD_LABEL) {
      container('containertools') {
        unstash('workspace')
        containerBuild(
          credentialsId: env.CREDENTIALS_ID,
          name: env.NAMESPACE + '/' + name,
          version: version,
          dockerfile: context + '/Dockerfile',
          context: context,
          buildArgs: containerBuildArgs,
          push: pushArg,
          latest: latest,
          debug: false
        )
      }
    }
  }
}
