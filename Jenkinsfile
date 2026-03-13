pipeline {
    agent any

    environment {
        IMAGE_NAME = "soktyheng/finead-todo-app:latest"
    }

    stages {

        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh 'cd TODO/todo_backend && npm install'
                sh '''
                    cd TODO/todo_frontend
                    npm install
                    npm run build
                    mkdir -p ../todo_backend/static
                    mv build ../todo_backend/static/build
                '''
            }
        }

        stage('Containerise') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                    sh "docker push ${IMAGE_NAME}"
                }
            }
        }

        stage('Security') {
            steps {
                echo 'Using Jenkins Credentials Provider — no hardcoded secrets.'
                sh "docker images ${IMAGE_NAME}"
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}