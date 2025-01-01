pipeline {
    agent any
    stages {
        stage ('Checkout') {
            steps {
                checkout scm // Récupère le code source du référentiel configuré
            }
        }
        stage ('EC2 Instance Build') {
            steps {
                script {
                    sh '''
                        echo "Build Step"
                    '''
                }
            }
        }
        stage ('Ansible Environment') {
            steps {
                script {
                    sh '''
                        echo "show directory"
                        pwd
                        echo "show ip"
                        cat public_ip.txt
                        echo "write ip inside host directory"
                        mkdir -p 04_ansible/host_vars
                        echo "ansible_host: $(awk '{print $2}' public_ip.txt)" > 04_ansible/host_vars/docker.yml
                        echo "check ip "
                        cat "04_ansible/host_vars/docker.yml"
                    '''
                }
            }
        }
        stage ('Try Ping Host') {
            agent {
                docker {
                    image 'registry.gitlab.com/robconnolly/docker-ansible:latest'
                }
            }
            steps {
                script {
                    sh '''
                        ls -l 04_ansible/host_vars/
                        export ANSIBLE_CONFIG=04_ansible/ansible.cfg
                        ansible all -m ping --private-key docker.pem -o
                    '''
                }
            }
        }
    }
}
