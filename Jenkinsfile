pipeline {
    agent any
    environment{
        DOCKER_TAG = getDockerTag()
    }
    stages{
        stage('Build Docker Image'){
            steps{
                sh "sudo docker build . -t jenilxo/ynode:${DOCKER_TAG} "
            }
        }
        stage('DockerHub Push'){
            steps{
                //withDockerRegistry(credentialsId: 'docker-hub')//
		withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                    sh "sudo docker login -u jenilxo -p ${dpass}"
                    sh "sudo docker push jenilxo/ynode:${DOCKER_TAG}"
                }
            }
        }
        stage('Deploy to k8s'){
            steps{
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG} "
                sh "scp -o StrictHostKeyChecking=no node-app-deploy.yml ec2-user@13.232.206.64:/home/ec2-user/deployment/."
                script{
                    try{
                        sh "ssh ec2-user@13.232.206.64 kubectl apply -f /home/ec2-user/deployment/. "
                    }catch(error){
                        sh "ssh ec2-user@13.232.206.64 kubectl create -f /home/ec2-user/deployment/. "
                    }
                }

	        }
            }
        }
    }


def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
