pipeline {
    agent {
        label 'AGENT-1'
    }
    options {
        timeout(time: 30, unit: 'MINUTES') 
        disableConcurrentBuilds()
        ansiColor( 'xterm')
    }
    parameters {

        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Pick something')
    
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
            when {
                expression {
                    params.action == true
                }
            }
            steps {
                sh """
                cd 01-vpc
                terraform plan
                """
                
            }
        }
        stage('Deploy') {
            when {
                expression {
                    params.action == apply 
                }
            }
            steps {
                sh """
                cd 01-vpc
                terraform apply -auto-approve
                """

            }
        }
        stage('Deploy') {
            when {
                expression {
                    params.action == destroy 
                }
            }
            steps {
                sh """
                cd 01-vpc
                terraform destroy -auto-approve
                """

            }
        }
        
    }

    post { 
        always { 
            echo 'I will always say Hello again!'
            deleteDir()
        }
        success { 
            echo 'I will run when pipeline is success'
        }
        failure { 
            echo 'I will run when pipeline is failure'
        }
    }
}