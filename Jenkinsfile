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
                sh "./changeTag.sh"
                sshagent(['kops']) {
                    sh "scp -o StrictHostKeyChecking=no service.yml node-app-pod.yml ec2-user@13.232.206.64:/home/ec2-user."
                    }
                script{
                    try{
                        sh "ssh ec2-user@13.232.206.64 kubectl apply -f . "
                    }catch(error){
                        sh "ssh ec2-user@13.232.206.64 kubectl create -f . "
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
