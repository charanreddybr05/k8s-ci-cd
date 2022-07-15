//Install Docker pipeline plugin in Jenkins
pipeline {
    agent {
    //We can define Dockerfile also
    dockerfile {
        filename 'Dockerfile.build'
        dir 'build'
        label 'my-defined-label'
        additionalBuildArgs  '--build-arg version=1.0.2'
        args '-v /tmp:/tmp'
    }
    //   docker { 
    //     image 'maven:latest' }
    // }
    stages {
        stage('Build') {
            steps {
                sh "mvn clean install"
            }
        }
        // stage('upload artifact to nexus') {
        //     steps {
        //         nexusArtifactUploader artifacts: [
        //             [
        //                 artifactId: 'wwp', 
        //                 classifier: '', 
        //                 file: 'target/wwp-1.0.0.war', 
        //                 type: 'war'
        //             ]
        //         ], 
        //             credentialsId: 'nexus3', 
        //             groupId: 'koddas.web.war', 
        //             nexusUrl: '10.0.0.91:8081', 
        //             nexusVersion: 'nexus3', 
        //             protocol: 'http', 
        //             repository: 'samplerepo', 
        //             version: '1.0.0'
        //     }
        // }
    }
    // post {
    //     always{
    //         deleteDir()
    //     }
    //     failure {
    //         echo "sendmail -s mvn build failed receipients@my.com"
    //     }
    //     success {
    //         echo "The job is successful"
    //     }
    // }
}