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
                    script: "oc new-app $APP_NAME:latest -n $PROJECT || true",
                    returnStatus: true
                )
                if (newAppStatus != 0) {
                    echo "Warning: oc new-app reported a non-zero exit but continuing..."
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
