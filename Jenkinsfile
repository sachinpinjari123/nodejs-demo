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
                    def deployExists = sh(
                        script: "oc get deployment $APP_NAME -n $PROJECT --ignore-not-found -o name",
                        returnStdout: true
                    ).trim()

                    if (deployExists == "deployment.apps/${APP_NAME}") {
                        sh '''
                            echo "Deployment exists, triggering rollout..."
                            oc rollout restart deployment/$APP_NAME -n $PROJECT
                        '''
                    } else {
                        echo "Deployment not found, creating new app..."
                        def newAppStatus = sh(
                            script: "oc new-app $APP_NAME:$IMAGE_TAG -n $PROJECT || true",
                            returnStatus: true
                        )
                        if (newAppStatus != 0) {
                            echo "Warning: oc new-app reported non-zero exit, continuing..."
                        }

                        echo "Checking if Service exists..."
                        def svcExists = sh(
                            script: "oc get svc $APP_NAME -n $PROJECT --ignore-not-found -o name",
                            returnStdout: true
                        ).trim()

                        if (svcExists == "service/${APP_NAME}") {
                            echo "Service already exists, skipping expose step."
                        } else {
                            sh '''
                                echo "Exposing service..."
                                oc expose svc/$APP_NAME -n $PROJECT
                            '''
                        }
                    }
                }
            }
        }
    }
}
