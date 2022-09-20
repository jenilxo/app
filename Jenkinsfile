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
                script{
                    kubernetesDeploy(configs: "node-app-pod.yml", kubeconfigId: "kubernetes")
                    }
                }

				}
            }
        }
    


def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
