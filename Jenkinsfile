pipeline{
    agent none 
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
                        echo "ansible_host: $(awk '{print $2}' public_ip.txt)" > 04_ansible/host_vars/docker.yml
                        echo "check ip "
                        cat "04_ansible/host_vars/docker.yml"
                    '''
                }
            }
        }
    }
}