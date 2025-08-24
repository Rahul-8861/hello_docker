pipeline {
  agent any

  environment {
    REGISTRY_CRED = 'dockerhub-creds'      // <-- your Jenkins creds ID
    IMAGE_NAME    = 'rahul187/image_1' // <-- change to your repo  
 }

 stages {
    stage('Checkout') {
      steps { 
        checkout scm 
      }
    }



    stage('Set Build Vars') {
      steps {
        script {
          // Compute after checkout so .git exists
          env.GIT_SHORT = sh(script: 'git rev-parse --short HEAD || echo dev', returnStdout: true).trim()
          env.BRANCH    = env.BRANCH_NAME ?: 'docker'
          env.TAG       = "${env.BRANCH}-${env.GIT_SHORT}-${env.BUILD_NUMBER}"
        }
      }
    }

    stage('Build image') {
      steps {
        sh """
          docker build -t ${IMAGE_NAME}:${TAG} .       //before building docker image jenkins user should be added to docker group
        """
      }
    }

    stage('Login & Push (Docker Hub)') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: REGISTRY_CRED,
          usernameVariable: 'DH_USER',
          passwordVariable: 'DH_PASS'
        )]) {
          sh """
            echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin
            docker tag ${IMAGE_NAME}:${TAG} ${IMAGE_NAME}:latest
            docker push ${IMAGE_NAME}:${TAG}
            docker push ${IMAGE_NAME}:latest
            docker logout
          """
        }
      }
    }
  }

post {
    always {
      sh 'docker image prune -f || true'
    }
  }
}

