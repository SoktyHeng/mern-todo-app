pipeline {
    agent any

    environment {
        IMAGE_NAME = "soktyheng/finead-todo-app:latest"
    }

    stages {

        stage('Build') {
            steps {
                echo 'Installing dependencies...'
                // Install backend dependencies
                sh '''
                    cd TODO/todo_backend
                    npm install
                '''
                // Install frontend dependencies
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
                echo 'Building Docker image...'
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Push') {
            steps {
                echo 'Pushing image to Docker Hub...'
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ''' + IMAGE_NAME + '''
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deployment ready. Use docker run command to test.'
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