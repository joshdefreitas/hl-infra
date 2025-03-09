pipeline {
    agent {
        docker {image 'node:16.alpine'}
    }
    stages {
        state('Test') {
            steps {
                sh 'node --version'
            }
        }
    }
}