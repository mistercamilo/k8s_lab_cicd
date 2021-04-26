pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Build Docker Image'
                git branch: 'main',
                url: 'git@github.com:mistercamilo/k8s_lab_cicd.git'
            }
        }
        stage('Build image') {
            steps{
                app = docker.build('mistercamilo/awesomeapp:v1.0')                
            }
        }
        stage('Push image') {
            steps{
                docker.withRegistry('https://registry.hub.docker.com', 'git') {
                    app.push("${env.BUILD_NUMBER}")
                    app.push('latest')
                }
            }
        }
        stage('Deploy in Dev') {
            steps {
                echo 'Deploying Pod to Kubernetes'
                sh 'kubectl config use-context k3d-dev'
                sh 'kubectl apply -f k8s-api-produto/ -R'
            }
        }
        stage('Deploy in Staging') {
            steps {
                echo 'Deploying app in the Staging'
                sh 'kubectl config use-context k3d-staging'
                sh 'kubectl apply -f k8s-api-produto/ -R'
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
                sh 'kubectl apply -f k8s-api-produto/ -R'
            }
        }
    }
}
