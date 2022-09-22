pipeline {
    agent any
    environment{
        DOCKER_TAG = getDockerTag()
    }
    stages{
        stage('Build Docker Image'){
            steps{ //build docker image with git commit id as as tag//
                sh "sudo docker build . -t jenilxo/ynode:${DOCKER_TAG} "
            }
        }
        stage('DockerHub Push'){
            steps{
                //Push To Docker Registery//
		withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                    sh "sudo docker login -u jenilxo -p ${dpass}"
                    sh "sudo docker push jenilxo/ynode:${DOCKER_TAG}"
                }
            }
        }
        stage('Deploy to k8s'){
            steps{
                sh "chmod +x changeTag.sh" //Need To Make It Executable//
                sh "./changeTag.sh ${DOCKER_TAG} " //Changing Docker Image Tags In Deployment File//
                sh "scp -o StrictHostKeyChecking=no node-app-deploy.yml ec2-user@13.232.206.64:/home/ec2-user/deployment/." //Copy Files In Bastion Host//
                script{
                    try{
                        sh "ssh ec2-user@13.232.206.64 kubectl apply -f /home/ec2-user/deployment/. " //If There Is No Depoyment//
                    }catch(error){
                        sh "ssh ec2-user@13.232.206.64 kubectl create -f /home/ec2-user/deployment/. "//If There Is Deployment Apply For New Updates//
                    }
		script{ //Send Mail In Compressed Zip File//
			emailext attachLog: true, body: '', compressLog: true, subject: 'Build Info', to: 'parekhmayank76@gmail.com'
		}
                }

	        }
            }
        }
    }


def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true //Fetch Git Commit Id As tag for docker image//
    return tag
}
