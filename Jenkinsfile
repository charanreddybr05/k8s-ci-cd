//Install Docker pipeline plugin in Jenkins
pipeline {
    environment {
        //CREDS = credentials('jfrogcred')
        registryUrl = 'https://macbookair.jfrog.io/docker'
        registry = 'macbookair.jfrog.io/docker'
        registryCredential = 'jfrogcred'
        gkeProject = 'stan-robot-shop-354006'
        gkeRegion = 'us-central1'
        gkeCluster = 'jenkins-k8s'
    }
    triggers {
//cron - Accepts a cron-style string to define a regular interval at which the Pipeline should be re-triggered, for example: triggers { cron('H */4 * * 1-5') }
//pollSCM - Accepts a cron-style string to define a regular interval at which Jenkins should check for new source changes. If new changes exist, the Pipeline will be re-triggered. For example: triggers { pollSCM('H */4 * * 1-5') }
//upstream - Accepts a comma-separated string of jobs and a threshold. When any job in the string finishes with the minimum threshold, the Pipeline will be re-triggered. For example: triggers { upstream(upstreamProjects: 'job1,job2', threshold: hudson.model.Result.SUCCESS) }
        pollSCM('* * * * *')
    }
                
    agent none 
//any - Execute the Pipeline, or stage, on any available agent. For example: agent any
//none - When applied at the top-level of the pipeline block no global agent will be allocated for the entire Pipeline run and each stage section will need to contain its own agent section. For example: agent none
//{ label 'docker' } - Execute the Pipeline, or stage, on an agent available in the Jenkins environment with the provided label. For example: agent { label 'my-defined-label' }
//node - agent { node { label 'labelName' } } behaves the same as agent { label 'labelName' }, but node allows for additional options (such as customWorkspace)
//kubernetes - Execute the Pipeline, or stage, inside a pod deployed on a Kubernetes cluster. In order to use this option, the Jenkinsfile must be loaded from either a Multibranch Pipeline or a Pipeline from SCM. The Pod template is defined inside the kubernetes { } block. For example, if you want a pod with a Kaniko container inside it, you would define it as follows:
    // agent {
    //   dockerfile {
    //     filename 'Dockerfile' }
    //   docker { 
    //     image 'maven:latest' }
    // }
    stages {
        stage('Maven Build & Sonar') {
          //agent any
          agent { docker 'maven' }
          steps {
            withSonarQubeEnv('jenkinsSonar') {
            //   sh 'mvn clean install sonar:sonar'
              sh 'mvn clean install'
                }
            }
        }
        // stage('Quality Gate') {
//This doesn't require an executor/agent
//waitForQualityGate - Wait for SonarQube analysis to be completed and return quality gate status. This step pauses Pipeline execution and wait for previously submitted SonarQube analysis to be completed and returns quality gate status. Setting the parameter abortPipeline to true will abort the pipeline if quality gate status is not green.
        //   steps {
        //     timeout(time: 1, unit: 'HOURS') {
        //       waitForQualityGate abortPipeline: true
        //         }
        //     }
        // })
//A stage must have one and only one of steps, stages, parallel, or matrix
        stage('Build Docker image & Upload to JFrog artifactory') {
            agent any
            input {
                message "Maven Build is success, proceed?"
                ok "Yes, proceed"
                submitter ""
                parameters {
                    string(name: 'Maven Build', defaultValue: 'yes', description: 'Build promotion')
                }
            }
            stages {
                stage('Upload WAR file to Artifactory') {
//We can force our parallel stages to all be aborted when any one of them fails, by adding failFast true to the stage containing the parallel
                    failFast true
                    parallel {
                        stage('Upload WAR file') {
                            agent any
                            steps {
                            //This is to upload WAR file
                                echo "Uploading Artifact"
                                script {
                                    rtUpload (
                                        serverId: 'Jfrog',
                                        spec: '''{
                                            "files": [
                                                {
                                                    "pattern": "target/*.war",
                                                    "target": "example-repo-local//"
                                                }
                                            ]
                                        }''',
 
                                        // Optional - Associate the uploaded files with the following custom build name and build number,
                                        // as build artifacts.
                                        // If not set, the files will be associated with the default build name and build number (i.e the
                                        // the Jenkins job name and number).
                                        buildName: 'holyFrog',
                                        buildNumber: '42'
                                    )
                                }
                                }
                            }
                        stage('Build Docker image & Upload to JFrog artifactory') {
                            agent any
                            steps {
                                // sh 'docker build -t app:${BUILD_NUMBER} .'
                                // sh 'docker login -u${CREDS_USR} -p${CREDS_PSW} macbookair.jfrog.io'
                                // sh 'docker tag app:${BUILD_NUMBER} macbookair.jfrog.io/docker/app:${BUILD_NUMBER}'
                                // sh 'docker push macbookair.jfrog.io/docker/app:${BUILD_NUMBER}'
                                script {
                                    withDockerRegistry(credentialsId: 'jfrogcred', url: "${registryUrl}"){
                                    def appImage = docker.build("${registry}/app:${env.BUILD_NUMBER}", "--target tomcat -f Dockerfile .")
                                    // dockerImage.push("app:${BUILD_NUMBER}")
                                    appImage.push()   
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        stage('Deploy to GKE cluster') {
            // agent any
            agent { docker 'kiwigrid/gcloud-kubectl-helm' }
            // agent {
            //     dockerfile {
            //         filename 'Dockerfile'
            //         args '--target helm'

            //     }
            // }
            steps {
                // kubeconfig(credentialsId: 'gke-svc-secret', serverUrl: '', caCertificate:'') {
                // // some block
                // }
                withCredentials([file(credentialsId: 'gke-svc-secret', variable: 'GKE_CREDS')]) {
                    sh '''
                        whoami
                        gcloud auth activate-service-account --key-file="$GKE_CREDS"
                        gcloud container clusters get-credentials ${gkeCluster} --region ${gkeRegion} --project ${gkeProject}
                        kubectl config set-credentials ~/.kube/config 
                        kubectl get ns
                        helm list 
                    '''
                }
                // kubernetesDeploy(credentialsType: '')
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
    //     always {
    //         deleteDir()
    //     }
    // }
    // post {
    //     always{
    //         deleteDir()
    //     }
    //     failure {
    //         echo "sendmail -s mvn build failed receipients@my.com"
            //  mail to: 'team@example.com',
            //  subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
            //  body: "Something is wrong with ${env.BUILD_URL}"
    //     }
    //     success {
    //         echo "The job is successful"
    //     }
    // }
}