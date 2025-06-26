pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Image') {
            steps {
                sh '''
                  oc start-build -F nodejs-demo --from-dir=.
                '''
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                  oc rollout latest dc/nodejs-demo
                '''
            }
        }
    }
}
