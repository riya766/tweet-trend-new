pipeline {
    agent { label 'maven' }  // Slave node label yahan match hona chahiye

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/riya766/tweet-trend-new.git'
            }
        }

        
    }
}
