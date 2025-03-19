pipeline {
    agent { label 'maven' }  // Ensure 'maven' labeled Jenkins Slave use ho raha ho

    environment {
        PATH = "/opt/apache-maven-3.9.9/bin:$PATH"  // Maven ka path set karna
        DOCKERHUB_USERNAME = 'riyaraina76'  // Docker Hub username
        DOCKER_IMAGE_NAME = 'ttrend'  // Docker Image name
    }

    stages {
        stage('Build') {
            steps {
                echo '<--------------- Building JAR --------------->'
                sh 'mvn clean deploy -DskipTests'  // JAR build karega
            }
        }

        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'valaxy-sonar-scanner'
            }
            steps {
                echo '<--------------- Running SonarQube Analysis --------------->'
                withSonarQubeEnv('sonarqube-server') {  
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    echo '<--------------- Docker Image Build Started --------------->'

                    // Securely fetch DockerHub password from Jenkins credentials store
                    withCredentials([string(credentialsId: 'dockerhub-token', variable: 'DOCKERHUB_PASSWORD')]) {
                        sh "echo '$DOCKERHUB_PASSWORD' | docker login -u $DOCKERHUB_USERNAME --password-stdin"
                    }

                    // Docker image build (Dockerfile se)
                    sh "docker build -t $DOCKERHUB_USERNAME/$DOCKER_IMAGE_NAME:latest ."

                    // Docker image push to Docker Hub
                    sh "docker push $DOCKERHUB_USERNAME/$DOCKER_IMAGE_NAME:latest"

                    echo '<--------------- Docker Build & Push Completed --------------->'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo '<--------------- Deploying Application --------------->'

                    // Pull the latest image from Docker Hub
                    sh "docker pull $DOCKERHUB_USERNAME/$DOCKER_IMAGE_NAME:latest"

                    // Stop and remove old container (if running)
                    sh "docker stop ttrend-container || true"
                    sh "docker rm ttrend-container || true"

                    // Run new container
                    sh "docker run -d --name ttrend-container -p 8080:8000 $DOCKERHUB_USERNAME/$DOCKER_IMAGE_NAME:latest"

                    echo '<--------------- Deployment Completed --------------->'
                }
            }
        }
    }
}
