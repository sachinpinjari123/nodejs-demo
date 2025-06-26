pipeline {
    agent any

    environment {
        PROJECT = 'ci-cd'
        APP_NAME = 'nodejs-demo'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Image') {
            steps {
                sh '''
                    oc project $PROJECT
                    echo "Starting Build..."
                    oc start-build $APP_NAME --from-dir=. -F
                '''
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Checking if Deployment exists..."
                    def deployExists = sh(
                        script: "oc get deployment $APP_NAME -n $PROJECT --ignore-not-found",
                        returnStatus: true
                    ) == 0

                    if (deployExists) {
                        sh '''
                            echo "Deployment exists, triggering rollout..."
                            oc rollout restart deployment/$APP_NAME -n $PROJECT
                        '''
                    } else {
                        sh '''
                            echo "Deployment not found, creating new app..."
                            oc new-app $APP_NAME:latest -n $PROJECT
                            oc expose svc/$APP_NAME -n $PROJECT || true
                        '''
                    }
                }
            }
        }
    }
}
