pipeline {
    agent none
    stages {
        stage('kubernetes ec2') {
            agent {
                docker {
                    image 'jenkins/jnlp-agent-terraform'
                }
            }
            environment {
                AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
            }
            steps {
                script {
                    sh '''
                        echo "Generating aws credentials"
                        echo "Deleting older if exist"
                        mkdir -p ~/.aws
                        echo "[default]" > ~/.aws/credentials
                        echo -e "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
                        echo -e "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
                        chmod 400 ~/.aws/credentials
                        cd "./02_terraform/"
                        terraform init 
                        terraform apply --var="stack=kubernetes" --auto-approve
                    '''
                }
            }
        }

        stage('Check File with Docker') {
            agent { docker { image 'alpine:latest' } }
            steps {
                script {
                    // Vérification que les modifications dans le fichier sont présentes dans ce stage
                    sh '''
                        echo "Checking file in Check File stage..."
                        cat  "04_ansible/host_vars/k3s.yaml"
                    '''
                }
            }
        }
        // stage('deploy on kubernetes cluster') {
        //     steps {
        //         input message: "Confirmer vous le deploiement dans AWS ?", ok: 'Yes'
        //     }
        // }
        stage('ansible deploy kubernetes'){
            agent {
                docker {
                    image  'registry.gitlab.com/robconnolly/docker-ansible:latest'
                }
            }
            steps{
                script {
                    sh '''
                        apt update 
                        apt install curl -y
                        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                        chmod +x kubectl
                        mkdir -p ~/.local/bin
                        mv ./kubectl ~/.local/bin/kubectl
                        kubectl --version
                        cat  "04_ansible/host_vars/k3s.yaml"
                        cd "04_ansible/"
                        ansible all -m ping --private-key ../02_terraform/keypair/kubernetes.pem
                    '''
                }
            }
        }

        // Autres stages de ton pipeline, y compris ceux pour Terraform et Ansible
        stage('destroy EC2 on AWS with terraform') {
            steps {
                input message: "Confirmer vous la suppression de la dev dans AWS ?", ok: 'Yes'
            }
        }

        stage('destroy EC2 with Docker') {
            agent {
                docker {
                    image 'jenkins/jnlp-agent-terraform'
                }
            }
            environment {
                AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
            }
            steps {
                script {
                    sh '''
                        cd "./02_terraform/"
                        terraform destroy --var="stack=kubernetes" --auto-approve
                    '''
                }
            }
        }
    }
}