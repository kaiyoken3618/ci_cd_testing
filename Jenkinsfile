pipeline {
    agent any

    triggers {
       // Poll GitHub every 5 minutes
        pollSCM('H/5 * * * *')
    }

    environment {
        IMAGE_NAME = "kai3618/ci-cd-test"
        IMAGE_TAG  = "latest"
        SONARQUBE_ENV = "SonarQube"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/kaiyoken3618/ci_cd_testing.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv("${SONARQUBE_ENV}") {
                    sh '''
                    mvn sonar:sonar \
                      -Dsonar.projectKey=ci-cd-test \
                      -Dsonar.projectName=ci-cd-test
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }
    }

    post {
        failure {
            echo '❌ Pipeline failed'
        }
        success {
            echo '✅ Pipeline completed successfully'
        }
    }
}
