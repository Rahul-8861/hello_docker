pipeline {
  agent any

  environment {
    IMAGE_NAME = "rahul187/image_1"
    TAG = "docker-${BUILD_NUMBER}"
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
        // Jenkins user should be in docker group before this step
        sh """
          docker build -t ${IMAGE_NAME}:${TAG} .
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

    stage('Deploy Container') {
      steps {
        sh """
          # Stop and remove existing container if any
          docker stop myapp || true
          docker rm myapp || true

          # Run new container on port 8080 (maps to app's port 80 inside container)
          docker run -d -p 8080:8000 --name myapp ${IMAGE_NAME}:${TAG}
        """
      }
    }
  }

  post {
    always {
      sh 'docker image prune -f || true'
    }
  }
}

