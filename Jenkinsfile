pipeline {
    environment {
        registry = 'mistercamilo/awesomeapp'
        registryCredential = 'dockerhub_id'
        dockerImage = ''
    }
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Checkout SCM'
                git branch: 'master',
                url: 'https://github.com/mistercamilo/k8s_lab_cicd.git'
            }
        }
        stage('Unit Tests') {
            steps {
                sh 'npm install'
                sh 'npm run test'
            }
        }
        stage('Build image') {
            steps {
                script {
                    dockerImage = docker.build registry + ":latest"
                }
            }
        }
        stage('Push image') {
            steps {
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Cleaning up') {
            steps {
                sh "docker rmi $registry:latest"
            }
        }
        stage('Deploy in Dev') {
            steps {
                echo 'Deploying Pod to Kubernetes'
                sh 'kubectl config use-context k3d-dev'
                sh 'kubectl apply -f manifests/dev/ -R'
            }
        }
        stage('Deploy in Staging') {
            steps {
                echo 'Deploying app in the Staging'
                sh 'kubectl config use-context k3d-staging'
                sh 'kubectl apply -f manifests/staging/ -R'
            }
        }
        stage('Deploy in Prod') {
            input {
                message 'Should we continue?'
                ok 'Yes, we should.'
                submitter 'camilo'
                parameters {
                    string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
                }
            }
            steps {
                echo 'Deploying Pod to Kubernetes'
                sh 'kubectl config use-context k3d-prod'
                sh 'kubectl apply -f manifests/prod/ -R'
            }
        }
    }
}
