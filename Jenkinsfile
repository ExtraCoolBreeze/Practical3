pipeline {
    agent any
    environment {
        DOCKERHUB_CREDS = credentials('DockerKey')
    }
    stages {
        stage('Docker Image Build') {
            steps {
                echo 'Building Docker Image...'
                sh 'docker build --no-cache --tag xtracoolbreeze/cw2-server:1.2 .'
                echo 'Docker Image Built Successfully!'
            }
        }

        stage('Test Docker Image') {
            steps {
                echo 'Testing Docker Image...'
                sh '''
                    docker stop test-container || true
                    docker rm test-container || true

                    docker image inspect xtracoolbreeze/cw2-server:1.2
                    docker run -d --name test-container -p 8081:8080 xtracoolbreeze/cw2-server:1.2
                    sleep 5
		    docker logs test-container
		    docker ps

                    docker stop test-container
                    docker rm test-container
                '''
            }
        }

        stage('DockerHub Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin'
            }
        }

        stage('DockerHub Image Push') {
            steps {
                sh 'docker push xtracoolbreeze/cw2-server:1.2'
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['my-ssh-key']) {
                    sh '''
                        ssh ubuntu@54.163.210.196 "kubectl set image deployment/cw2-server cw2-server=xtracoolbreeze/cw2-server:1.2"
			ssh ubuntu@54.163.210.196 "kubectl rollout status deployment/cw2-server:1.2"
                    '''
                }
            }
        }
    }
}
