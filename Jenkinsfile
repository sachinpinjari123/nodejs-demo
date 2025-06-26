pipeline {
    agent any

    environment {
        PROJECT = 'ci-cd'
        APP_NAME = 'nodejs-demo'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Image using BuildConfig') {
            steps {
                sh '''
                    echo "Switching to project $PROJECT"
                    oc project $PROJECT

                    echo "Starting Build using BuildConfig..."
                    oc start-build $APP_NAME --from-dir=. -F
                '''
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    echo "Checking if Deployment exists..."

                    def deployOutput = sh(
                        script: "oc get deployment $APP_NAME -n $PROJECT --ignore-not-found -o name",
                        returnStdout: true
                    ).trim()

                    if (deployOutput == "deployment.apps/${APP_NAME}") {
                        sh '''
                            echo "Deployment exists, triggering rollout..."
                            oc rollout restart deployment/$APP_NAME -n $PROJECT
                        '''
                    } else {
                        sh '''
                            echo "Deployment not found, creating new app using ImageStream..."
                            oc new-app $APP_NAME:$IMAGE_TAG -n $PROJECT
                            oc expose svc/$APP_NAME -n $PROJECT || true
                        '''
                    }
                }
            }
        }
    }
}
