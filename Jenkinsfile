pipeline {
    agent any

    environment {
        PROJECT = 'ci-cd'
        APP_NAME = 'nodejs-demo'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    npm install
                '''
            }
        }

        stage('Lint Code') {
            steps {
                sh '''
                    npx eslint . || true
                '''
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh '''
                    npx mocha || true
                '''
            }
        }

        stage('Build Image using BuildConfig') {
            steps {
                sh '''
                    oc project $PROJECT
                    oc start-build $APP_NAME --from-dir=. -F
                '''
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    def deployExists = sh(
                        script: "oc get deployment $APP_NAME -n $PROJECT --ignore-not-found -o name",
                        returnStdout: true
                    ).trim()

                    if (deployExists == "deployment.apps/${APP_NAME}") {
                        sh "oc rollout restart deployment/$APP_NAME -n $PROJECT"
                    } else {
                        sh "oc new-app $APP_NAME:$IMAGE_TAG -n $PROJECT || true"

                        def svcExists = sh(
                            script: "oc get svc $APP_NAME -n $PROJECT --ignore-not-found -o name",
                            returnStdout: true
                        ).trim()

                        if (svcExists != "service/${APP_NAME}") {
                            sh "oc expose svc/$APP_NAME -n $PROJECT"
                        }
                    }
                }
            }
        }

        stage('Expose Route') {
            steps {
                script {
                    def routeExists = sh(
                        script: "oc get route $APP_NAME -n $PROJECT --ignore-not-found -o name",
                        returnStdout: true
                    ).trim()

                    if (routeExists != "route.route.openshift.io/${APP_NAME}") {
                        sh "oc expose svc/$APP_NAME -n $PROJECT"
                    }
                }
            }
        }
    }
}
