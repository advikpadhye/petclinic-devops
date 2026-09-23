pipeline {

    agent any

    environment {
        TF_IN_AUTOMATION = 'true'
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    options {
        timestamps()
        disableConcurrentBuilds()
        skipDefaultCheckout(true)
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code from GitHub'

                checkout scm
            }
        }

        stage('Terraform Format Check') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform fmt -check -recursive
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform init -input=false
                    '''
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform validate
                    '''
                }
            }
        }

        stage('AWS Identity Check') {
            steps {
                sh '''
                    echo "Checking AWS identity..."
                    aws sts get-caller-identity
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform plan \
                          -input=false \
                          -out=tfplan
                    '''
                }
            }
        }

        stage('Manual Approval') {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input(
                        id: 'TerraformApproval',
                        message: 'Terraform plan is ready. Review the plan and approve the infrastructure deployment.',
                        ok: 'Proceed with Terraform Apply'
                        
                    )
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform apply \
                          -input=false \
                          tfplan
                    '''
                }
            }
        }
    }

    post {

        success {
            echo 'Terraform deployment completed successfully.'
        }

        failure {
            echo 'Terraform pipeline failed.'
        }

        aborted {
            echo 'Terraform deployment was aborted.'
        }
    }
}
