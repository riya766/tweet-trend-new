pipeline {
    agent { label 'maven' }  // Slave node label match hona chahiye

    environment {
        PATH = "/opt/apache-maven-3.9.9/bin:$PATH"  // Maven ka path set kar rahe hain
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean deploy -DskipTests'  // Tests ko skip karke build karega
            }
        }

        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'valaxy-sonar-scanner'
            }
            steps {
                withSonarQubeEnv('sonarqube-server') {  
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }
}

