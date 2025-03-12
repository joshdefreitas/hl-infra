pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile.agent'
            additionalBuildArgs '--no-cache'
            reuseNode true    
            args '-v /tmp:/tmp'
        }
    }
    
    parameters {
        string(name: 'PROXMOX_HOST', defaultValue: '192.168.1.10', description: 'Proxmox host IP address')
        string(name: 'VM_NAME', defaultValue: 'test-vm', description: 'Name for the new VM')
        string(name: 'VM_IP', defaultValue: '192.168.1.11', description: 'IP address for the new VM')
    }
    
    environment {
        PROXMOX_API_TOKEN_ID = credentials('proxmox-token-id')
        PROXMOX_API_TOKEN_SECRET = credentials('proxmox-token-secret')
        SSH_PUBLIC_KEY = credentials('homelab-ssh-public-key')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Test Connectivity') {
            steps {
                sh '''
                echo "Testing connectivity to Proxmox..."
                ping -c 3 ''' + params.PROXMOX_HOST + ''' || echo "Ping failed but continuing"
                
                echo "Testing API access..."
                curl -k -s -o /dev/null -w "Proxmox API HTTP Status: %{http_code}\\n" https://''' + params.PROXMOX_HOST + ''':8006/ || echo "API check failed but continuing"
                '''
            }
        }
        
        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init -upgrade'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh """
                    terraform plan \\
                      -var="proxmox_api_url=https://${params.PROXMOX_HOST}:8006/api2/json" \\
                      -var="proxmox_api_token_id=\${PROXMOX_API_TOKEN_ID}" \\
                      -var="proxmox_api_token_secret=\${PROXMOX_API_TOKEN_SECRET}" \\
                      -var="proxmox_node=pve-01" \\
                      -var="vm_name=${params.VM_NAME}" \\
                      -var="vm_ip=${params.VM_IP}" \\
                      -var="ssh_public_key=\${SSH_PUBLIC_KEY}" \\
                      -out=tfplan
                    """
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
        
        stage('Verify VM Creation') {
            steps {
                dir('terraform') {
                    sh 'terraform output'
                }
            }
        }
    }
    
    post { 
        always {
            echo "Cleaning up workspace..."
            
            // Clean up Terraform files inside the container
            sh '''
                # Print disk usage
                echo "Disk usage:"
                df -h /
                
                # Remove Terraform temporary files
                if [ -d "terraform" ]; then
                    cd terraform
                    rm -f terraform.tfstate.backup tfplan
                    cd ..
                fi
                
                # Clean workspace
                rm -rf .terraform
            '''
            
            cleanWs notFailBuild: true
            
            // Trigger the Docker cleanup job
            build job: 'docker-cleanup', wait: false, propagate: false
        }
        
        success { 
            echo "VM creation successful! VM '${params.VM_NAME}' has been created with IP ${params.VM_IP}" 
        } 
        failure { 
            echo "VM creation failed. Check the logs for details." 
        } 
}