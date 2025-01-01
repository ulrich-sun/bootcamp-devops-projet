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
                        echo "docker ansible_host: $(awk '{print $2}' public_ip.txt)" > 04_ansible/host_vars/docker.yml
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
                        cd "04_ansible/"
                        cat inventory.yml
                        cat host_vars/docker.yml
                        ansible -i inventory.yml docker  -m ping --private-key docker.pem -o
                        ansible all -m ping --private-key docker.pem -o
                    '''
                }
            }
        }
    }
}