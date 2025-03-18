def registry = 'https://riya766.jfrog.io/'
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

           def registry = 'https://riya766.jfrog.io/'
         stage("Jar Publish") {
        steps {
            script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"artifact-cred"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "libs-release-local/{1}",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '<--------------- Jar Publish Ended --------------->'  
            
            }
        }   
    }   
    }
}

