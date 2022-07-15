//Install Docker pipeline plugin in Jenkins
pipeline {
    agent none 
      //any - Execute the Pipeline, or stage, on any available agent. For example: agent any
      //none - When applied at the top-level of the pipeline block no global agent will be allocated for the entire Pipeline run and each stage section will need to contain its own agent section. For example: agent none
      //label - Execute the Pipeline, or stage, on an agent available in the Jenkins environment with the provided label. For example: agent { label 'my-defined-label' }
      //node - agent { node { label 'labelName' } } behaves the same as agent { label 'labelName' }, but node allows for additional options (such as customWorkspace)
      //kubernetes - Execute the Pipeline, or stage, inside a pod deployed on a Kubernetes cluster. In order to use this option, the Jenkinsfile must be loaded from either a Multibranch Pipeline or a Pipeline from SCM. The Pod template is defined inside the kubernetes { } block. For example, if you want a pod with a Kaniko container inside it, you would define it as follows:
      //dockerfile {
      //  filename 'Dockerfile'
      //docker { 
      //  image 'maven:latest' }
    stages {
        stage('Build') {
            agent { docker 'maven' }
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