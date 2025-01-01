pipeline {
    agent any
    environment {
        WORKSPACE_DIR = "${env.WORKSPACE}" // Définit le répertoire de travail pour toutes les étapes
    }
    stages {
        stage('EC2 Instance Build') {
            steps {
                script {
                    sh '''
                        echo "Build Step"
                    '''
                }
            }
        }
        stage('Ansible Environment') {
            steps {
                script {
                    sh '''
                        echo "Switch to working directory"
                        cd ${WORKSPACE_DIR}
                        
                        echo "Show directory"
                        pwd
                        
                        echo "Show IP"
                        cat public_ip.txt
                        
                        echo "Write IP inside host_vars directory"
                        echo "docker ansible_host: $(awk '{print $2}' public_ip.txt)" > 04_ansible/host_vars/docker.yml
                        
                        echo "Check IP"
                        cat 04_ansible/host_vars/docker.yml
                    '''
                }
            }
        }
        stage('Try Ping Host') {
            agent {
                docker {
                    image 'registry.gitlab.com/robconnolly/docker-ansible:latest'
                }
            }
            steps {
                script {
                    sh '''
                        echo "Switch to working directory"
                        cd ${WORKSPACE_DIR}/04_ansible
                        
                        echo "Install tree utility"
                        apt-get update -y
                        apt-get install tree -y
                        
                        echo "Ping host using Ansible"
                        ansible -i inventory.yml docker -m ping --private-key ../docker.pem -o
                        
                        echo "Ping all hosts using Ansible"
                        ansible -i inventory.yml all -m ping --private-key ../docker.pem -o
                    '''
                }
            }
        }
    }
}
