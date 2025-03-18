def registry = 'https://riya766.jfrog.io/artifactory'  // ✅ Correct URL 

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

        
        stage("Jar Publish") {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'

                    def server = Artifactory.newServer(url: registry, credentialsId: "artifact-cred-access") // ✅ Correct URL usage
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
                    
                   def uploadSpec = """{
    "files": [
        {
            "pattern": "jarstaging/**/*.jar",
            "target": "libs-release-local/com/valaxy/demo-workshop/",
            "flat": false
        }
    ]
}"""


                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.collectEnv()  // ✅ Correct method call
                    server.publishBuildInfo(buildInfo)

                    echo '<--------------- Jar Publish Ended --------------->'
                }
            }
        }
        
    }
}
