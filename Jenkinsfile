pipeline {
    agent none
    stages {
        // stage ('Build EC2 on AWS with terraform') {
        //   agent { 
        //             docker { 
        //                 image 'jenkins/jnlp-agent-terraform'  
        //             } 
        //         }
        //   environment {
        //     AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        //     AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        //   }          
        //   steps {
        //      script {
        //        sh '''
        //           echo "Generating aws credentials"
        //           echo "Deleting older if exist"
        //           mkdir -p ~/.aws
        //           echo "[default]" > ~/.aws/credentials
        //           echo -e "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
        //           echo -e "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
        //           chmod 400 ~/.aws/credentials
        //           cd "./02_terraform/"
        //           terraform init 
        //           #terraform destroy --auto-approve
        //           terraform plan
        //           terraform apply --var="stack=docker" --auto-approve
        //        '''
        //      }
        //   }
        // }

        stage ('Prepare Ansible environment') {
          agent any        
          steps {
             script {
               sh '''
                  pwd
                  echo "Generating host_vars for EC2 servers"
                  echo "ansible_host: $(awk '{print $2}' /var/jenkins_home/workspace/ic-webapp/public_ip.txt)" > /var/jenkins_home/workspace/ic-webapp/04_ansible/host_vars/docker.yaml
                  echo "check ip "
                  cat /var/jenkins_home/workspace/ic-webapp/04_ansible/host_vars/docker.yaml
                  
               '''
             }
          }
        }
                  
        stage('Deploy DEV  env for testing') {
            agent{     
                    docker { 
                        image 'registry.gitlab.com/robconnolly/docker-ansible:latest'
                    } 
                }
            stages {
                stage ("DEV - Ping target hosts") {
                    steps {
                        script {
                            sh '''   
                                cd 04_ansible/
                                cat host_vars/docker.yaml
                                #export ANSIBLE_CONFIG=$(pwd)/04_ansible/ansible.cfg                      
                                ansible docker -m ping  --private-key /var/jenkins_home/workspace/ic-webapp/docker.pem -o 
                            '''
                        }
                    }
                }
                // stage ("DEV - Deploy App") {
                //     steps {
                //         script {
                //             sh '''
                //                 apt update -y
                //                 apt install sshpass -y    
                //                 export ANSIBLE_CONFIG=$(pwd)/04_ansible/ansible.cfg                      
                //                 ansible-playbook $(pwd)/04_ansible/playbooks/docker/main.yaml  --private-key /var/jenkins_home/workspace/ic-webapp/docker.pem 
                //             '''
                //         }
                //     }
                // }
            }
        }
        // stage ('destroy EC2 on AWS with terraform') {
        //     steps {
        //         input message: "Confirmer vous la suppression de la dev dans AWS ?", ok: 'Yes'
        //     }
        // }
        // stage ('destroy EC2 with Docker') {
        //     agent {
        //         docker {
        //             image 'jenkins/jnlp-agent-terraform'
        //         }
        //     }
        //     environment {
        //         AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        //         AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        //     }
        //     steps {
        //         script {
        //             sh '''
        //                 cd "./02_terraform/"
        //                 terraform destroy --var="stack=docker" --auto-approve
        //             '''
        //         }
        //     }
        // }

    }   
}
