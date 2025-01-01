pipeline{
    agent any
    stages{
        stage ('EC2 Instance Build'){
            steps {
                script {
                    sh '''
                        echo "Build Step"
                    '''
                }
            }
        }
        stage ('Ansible Environment'){
            steps {
                script {
                    sh '''
                        echo "show directory"
                        pwd
                        echo "show ip"
                        cat public_ip.txt
                        echo "write ip inside host directory"
                        echo "docker ansible_host: $(awk '{print $2}' public_ip.txt)" > 04_ansible/inventory
                        echo "check ip "
                        cat 04_ansible/inventory
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
                        export ANSIBLE_CONFIG=04_ansible/ansible.cfg
                        ansible docker -m ping --private-key docker.pem -o
                    '''
                }
            }
        }
    }
}