pipeline {
    agent {
        label 'AGENT-1'
    }
    options {
        timeout(time: 30, unit: 'MINUTES') 
        disableConcurrentBuilds()
        ansiColor( 'xterm')
    }
    
    stages {
        stage('init') {
            steps {
                sh """
                ls -ltr
                cd 01-vpc
                terraform init -reconfigure
                """
            }
        }
        stage('plan') {
            steps {
                sh 'echo This is Test'
            }
        }
        stage('apply') {
            steps {
                sh 'echo This is Depoly'
            }
        }
        
    }

    post { 
        always { 
            echo 'I will always say Hello again!'
        }
        success { 
            echo 'I will run when pipeline is success'
        }
        failure { 
            echo 'I will run when pipeline is failure'
        }
    }
}