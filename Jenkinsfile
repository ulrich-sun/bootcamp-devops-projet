pipeline {
    agent any
    stages {
        stage ('Build EC2 Instance') {
            steps {
                script {
                    sh '''
                        echo "Step 1: Building EC2 Instance"
                        # Commands to build EC2 instance
                    '''
                }
            }
        }

        stage ('Prepare Ansible Environment') {
            steps {
                script {
                    sh '''
                        echo "Step 2: Preparing Ansible Environment"
                        echo "Current working directory: ${WORKSPACE}"
                        echo "docker ansible_host: $(awk '{print $2}' ${WORKSPACE}/public_ip.txt)" > ${WORKSPACE}/04_ansible/host_vars/docker.yml
                        echo "Generated host_vars file:"
                        cat ${WORKSPACE}/04_ansible/host_vars/docker.yml
                    '''
                }
            }
        }

        stage ('Test Connection to Host') {
            agent {
                docker {
                    image 'registry.gitlab.com/robconnolly/docker-ansible:latest'
                    args "-w ${WORKSPACE}"
                }
            }
            steps {
                script {
                    sh '''
                        echo "Step 3: Testing Connection to Host"
                        echo "Current working directory: $(pwd)"
                        ansible -i ${WORKSPACE}/04_ansible/inventory.yml docker -m ping --private-key ${WORKSPACE}/docker.pem -o
                    '''
                }
            }
        }

        stage ('Deploy Application') {
            agent {
                docker {
                    image 'registry.gitlab.com/robconnolly/docker-ansible:latest'
                    args "-w ${WORKSPACE}"
                }
            }
            steps {
                script {
                    sh '''
                        echo "Step 4: Deploying Application"
                        cd ${WORKSPACE}/04_ansible
                        ansible-playbook playbooks/docker/main.yaml --private-key ${WORKSPACE}/docker.pem -vvv
                    '''
                }
            }
        }

        stage ('Cleanup') {
            steps {
                script {
                    sh '''
                        echo "Step 5: Cleaning up resources"
                        cd ${WORKSPACE}/02_terraform
                        terraform destroy --var="stack=docker" --auto-approve
                    '''
                }
            }
        }
    }
}
