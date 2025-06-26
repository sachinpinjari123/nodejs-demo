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
                    oc new-app $APP_NAME:latest -n $PROJECT || true
                '''

                echo "Checking if Service exists..."

                def svcOutput = sh(
                    script: "oc get svc $APP_NAME -n $PROJECT --ignore-not-found -o name",
                    returnStdout: true
                ).trim()

                if (svcOutput == "service/${APP_NAME}") {
                    echo "Service already exists, skipping expose step..."
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
