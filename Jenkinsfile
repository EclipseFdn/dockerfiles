@Library('releng-pipeline@main') _

pipeline {
  agent any 

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
    stage('Run Builds') {
      parallel {
        stage('nginx') {
          agent {
            kubernetes {
              yaml loadOverridableResource(
                libraryResource: 'org/eclipsefdn/container/agent.yml'
              )
            }
          }
          steps {
            buildImage('nginx', 'stable-alpine', 'nginx/stable-alpine', [:], true)
            buildImage('nginx', 'stable-alpine-for-staging', 'nginx/stable-alpine-for-staging')
          }
        }

        stage('planet-venus') {
          agent {
            kubernetes {
              yaml loadOverridableResource(
                libraryResource: 'org/eclipsefdn/container/agent.yml'
              )
            }
          }
          steps {
            buildImage('planet-venus', 'debian-11-slim', 'planet-venus', [:], true)
          }
        }
        stage('kubectl') {
          agent {
            kubernetes {
              yaml loadOverridableResource(
                libraryResource: 'org/eclipsefdn/container/agent.yml'
              )
            }
          }
          steps {
            buildImage('kubectl', 'okd-c1', 'kubectl/okd-c1', [:], true)
          }
        }

        stage('hugo-node') {
          agent {
            kubernetes {
              yaml loadOverridableResource(
                libraryResource: 'org/eclipsefdn/container/agent.yml'
              )
            }
          }
          steps {
            buildImage('hugo-node', 'h0.99.1-n16.15.0', 'hugo-node', ['HUGO_VERSION':'0.99.1', 'HUGO_FILENAME':'hugo_0.99.1_Linux-64bit.deb','NODE_VERSION': 'v16.15.0'])
            buildImage('hugo-node', 'h0.110.0-n18.19.1', 'hugo-node', ['HUGO_VERSION':'0.110.0', 'NODE_VERSION': 'v18.19.1'], true)
            buildImage('hugo-node', 'h0.120.4-n18.19.1', 'hugo-node', ['DEBIAN_VERSION':'12-slim', 'HUGO_VERSION':'0.120.4', 'NODE_VERSION': 'v18.19.1'])
            buildImage('hugo-node', 'h0.124.1-n20.11.1', 'hugo-node', ['DEBIAN_VERSION':'12-slim', 'HUGO_VERSION':'0.124.1', 'NODE_VERSION': 'v20.11.1'])
            buildImage('hugo-node', 'h0.144.2-n22.14.0', 'hugo-node', ['DEBIAN_VERSION':'12-slim', 'HUGO_VERSION':'0.144.2', 'NODE_VERSION': 'v22.14.0'])
          }
        }

        stage('drupal-node') {
          agent {
            kubernetes {
              yaml loadOverridableResource(
                libraryResource: 'org/eclipsefdn/container/agent.yml'
              )
            }
          }
          steps {
            buildImage('drupal-node', 'd10.3.13-n22.14.0', 'drupal-node', ['DRUPAL_VERSION':'10.3.13', 'NODE_VERSION': 'v22.14.0'], true)
            buildImage('drupal-node', 'd11.1.3-n22.14.0', 'drupal-node', ['DRUPAL_VERSION':'11.1.3', 'NODE_VERSION': 'v22.14.0'])
          }
        }

        stage('stack-build-agent') {
          agent {
            kubernetes {
              yaml loadOverridableResource(
                libraryResource: 'org/eclipsefdn/container/agent.yml'
              )
            }
          }
          steps {
            buildImage('stack-build-agent', 'h111.3-n18.19-jdk11', 'stack-build-agent', [:], true)
            buildImage('stack-build-agent', 'h111.3-n18.19-jdk17', 'stack-build-agent', ['JDK_VERSION':'17'])
            buildImage('stack-build-agent', 'a3.19-h120-n20-jdk17', 'stack-build-agent', ['ALPINE_VERSION':'3.19', 'JDK_VERSION':'17', 'NODE_VERSION':'20.15.1-r0', 'NPM_VERSION':'10.2.5-r0', 'HUGO_VERSION':'0.120.4', 'YARN_VERSION':'1.22.19-r0'])
            buildImage('stack-build-agent', 'a3.22-h144-n22-jdk21', 'stack-build-agent', ['ALPINE_VERSION':'3.22', 'JDK_VERSION':'21', 'NODE_VERSION':'22.16.0-r2', 'NPM_VERSION':'11.3.0-r0', 'HUGO_VERSION':'0.144.2', 'YARN_VERSION':'1.22.22-r1'])
          }
        }

        stage('java-api-base') {
          agent {
            kubernetes {
              yaml loadOverridableResource(
                libraryResource: 'org/eclipsefdn/container/agent.yml'
              )
            }
          }
          steps {
            buildImage('java-api-base', 'j11-openjdk', 'java-api-base', ['JDK_VERSION':'11:1.17'])
            buildImage('java-api-base', 'j17-openjdk', 'java-api-base', ['JDK_VERSION':'17:1.22-1.1752621170'], true)
            buildImage('java-api-base', 'j21-openjdk', 'java-api-base', ['JDK_VERSION':'21:1.22-1.1752676422'])
          }
        }

        stage('native-build-agent') {
          agent {
            kubernetes {
              yaml loadOverridableResource(
                libraryResource: 'org/eclipsefdn/container/agent.yml'
              )
            }
          }
          steps {
            buildImage('native-build-agent', 'm23-n18.20.2', 'native-build-agent', [:], true)
            buildImage('native-build-agent', 'm23-n22', 'native-build-agent', ['NODE_VERSION':'v22.17.0'])
          }
        }

        stage('containertools') {
          agent {
            kubernetes {
              yaml loadOverridableResource(
                libraryResource: 'org/eclipsefdn/container/agent.yml'
              )
            }
          }
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
  String distroName = "${env.NAMESPACE}/${name}:${version}"
  def containerBuildArgs = buildArgs.collect { k, v -> "--opt build-arg:${k}=${v}" }.join(' ')
  
  println """
    "###### Build Image: ${distroName}
    * Version ${version}
    * Build Params ${buildArgs}
    * Build Args ${containerBuildArgs}
    * Dockerfile ${context}/Dockerfile
    * Latest ${latest}
    """

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
      debug: false
    )
  }
}
