pipeline {
    agent none
    stages {
        stage ('Build EC2 on AWS with terraform') {
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
                  #terraform destroy --auto-approve
                  terraform plan
                  terraform apply --var="stack=docker" --auto-approve
               '''
             }
          }
        }

        stage ('Prepare Ansible environment') {
          agent any
          }          
          steps {
             script {
               sh '''
                  echo "Generating host_vars for EC2 servers"
                  echo "ansible_host: $(awk '{print $2}' /var/jenkins_home/workspace/ic-webapp/public_ip.txt)" > 04_ansible/host_vars/docker.yml
                  echo " Generating key pair "
                  
               '''
             }
          }
        }
                  
        stage('Deploy DEV  env for testing') {
            agent   {     
                        docker { 
                            image 'registry.gitlab.com/robconnolly/docker-ansible:latest'
                        } 
                    }
            stages {
                stage ("DEV - Ping target hosts") {
                    steps {
                        script {
                            sh '''
                                apt update -y
                                apt install sshpass -y                            
                                ansible prod -m ping  --private-key /var/jenkins_home/workspace/ic-webapp/docker.pem -o 
                            '''
                        }
                    }
                }
            }
        }

        // stage ("Delete Dev environment") {
        //     agent { docker { image 'jenkins/jnlp-agent-terraform'  } }
        //     environment {
        //         AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        //         AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        //         PRIVATE_AWS_KEY = credentials('private_aws_key')
        //     }
        //     steps {
        //         script {       
        //             timeout(time: 30, unit: "MINUTES") {
        //                 input message: "Confirmer vous la suppression de la dev dans AWS ?", ok: 'Yes'
        //             } 
        //             sh'''
        //                 cd "./sources/terraform ressources/app"
        //                 terraform destroy --auto-approve
        //                 rm -rf sources/ansible-ressources/host_vars/*.dev.yml
        //                 rm -rf devops.pem
        //             '''                            
        //         }
        //     }
        // }  
        // stage ("Deploy in PRODUCTION") {
        //     /* when { expression { GIT_BRANCH == 'origin/prod'} } */
        //     agent { docker { image 'registry.gitlab.com/robconnolly/docker-ansible:latest'  } }                     
        //     stages {
        //         stage ("PRODUCTION - Ping target hosts") {
        //             steps {
        //                 script {
        //                     sh '''
        //                         apt update -y
        //                         apt install sshpass -y                            
        //                         export ANSIBLE_CONFIG=$(pwd)/sources/ansible-ressources/ansible.cfg
        //                         ansible prod -m ping  -o
        //                     '''
        //                 }
        //             }
        //         }                                                       
        //         stage ("PRODUCTION - Install Docker on all hosts") {
        //             steps {
        //                 script {
        //                     timeout(time: 30, unit: "MINUTES") {
        //                         input message: "Etes vous certains de vouloir cette MEP ?", ok: 'Yes'
        //                     }                            

        //                     sh '''
        //                         export ANSIBLE_CONFIG=$(pwd)/sources/ansible-ressources/ansible.cfg
        //                         ansible-playbook sources/ansible-ressources/playbooks/install-docker.yml --vault-password-file vault.key  -l odoo_server,pg_admin_server
        //                     '''                                
        //                 }
        //             }
        //         }

        //         stage ("PRODUCTION - Deploy pgadmin") {
        //             steps {
        //                 script {
        //                     sh '''
        //                         export ANSIBLE_CONFIG=$(pwd)/sources/ansible-ressources/ansible.cfg
        //                         ansible-playbook sources/ansible-ressources/playbooks/deploy-pgadmin.yml --vault-password-file vault.key  -l pg_admin
        //                     '''
        //                 }
        //             }
        //         }
        //         stage ("PRODUCTION - Deploy odoo") {
        //             steps {
        //                 script {
        //                     sh '''
        //                         export ANSIBLE_CONFIG=$(pwd)/sources/ansible-ressources/ansible.cfg
        //                         ansible-playbook sources/ansible-ressources/playbooks/deploy-odoo.yml --vault-password-file vault.key  -l odoo
        //                     '''
        //                 }
        //             }
        //         }

        //         stage ("PRODUCTION - Deploy ic-webapp") {
        //             steps {
        //                 script {
        //                     sh '''
        //                         export ANSIBLE_CONFIG=$(pwd)/sources/ansible-ressources/ansible.cfg
        //                         ansible-playbook sources/ansible-ressources/playbooks/deploy-ic-webapp.yml --vault-password-file vault.key  -l ic_webapp

        //                     '''
        //                 }
        //             }
        //         }
        //     }
        // } 
    }  

    // post {
    //     always {
    //         script {
    //             /*sh '''
    //                 echo "Manually Cleaning workspace after starting"
    //                 rm -f vault.key id_rsa id_rsa.pub password devops.pem public_ip.txt
    //             ''' */
    //             slackNotifier currentBuild.result
    //         }
    //     }
    // }    
}