pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Trigger OpenShift Build') {
            steps {
                sh '''
                  oc start-build nodejs-demo --from-dir=. -F
                '''
            }
        }
        stage('Rollout Deploy') {
            steps {
                sh '''
                  oc rollout restart deployment/nodejs-demo
                '''
            }
        }
    }
}
