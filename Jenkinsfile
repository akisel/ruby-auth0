@Library('sharedlib') _
def git_hash = ""
// define the objects that will be needed
def general_utils = new dataxu.general.utils()

//Syntax quick guide: https://jenkins.io/doc/book/pipeline/syntax/
pipeline {
    agent {
        node {
            label 'micro'
            customWorkspace "/var/lib/jenkins/jobs/${JOB_NAME}/${BUILD_NUMBER}"
        }
    }
    options {
        //keep last 10 builds
        buildDiscarder(logRotator(numToKeepStr: '10'))
        //timestamps
        timestamps()
    }
    //begin stage definitions
    stages {
        stage('Prep Env') {
            stages {
                stage ('Checkout SCM') {
                    steps {
                        //clean the current directory
                        deleteDir()
                        //get the repository this Jenkinsfile lives in
                        checkout scm
                    }
                }
            }
            post {
                always {
                    //notify github that we made it this far
                    github_notify_status()
                }
            }
        }
        stage('Build') {

            stages {
                stage('Build Docker Image') {
                    steps {
                        sh '''
                        docker build -t ruby-auth0 .
                        '''
                    }
                }
                /*
                stage('Run Tests') {
                    steps {
                        sh '''
                        docker run ruby-auth0 bundler exec rake
                        '''
                    }
                }*/
                stage('Build & Push Gem') {
                    when {
                        expression { env.BRANCH_NAME == 'master' }
                    }
                    steps {
                        sh '''
                        docker run ruby-auth0 /home/builder/app/buildDeploy.sh
                        '''
                    }
                }
            }
            post {
                always {
                    github_notify_status()
                }
            }
        }
    }
    post {
        always {
            script {
                github_notify_status(stage_name: 'Pipeline complete')
            }
        }
    }
}
