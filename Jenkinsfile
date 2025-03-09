pipeline {
    agent {
        docker {image 'node:23-alpine3.20'}
    }
    stages {
        stage('Test') {
            steps {
                sh 'node --version'
            }
        }
    }
}