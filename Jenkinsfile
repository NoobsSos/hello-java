pipeline {
    agent any

    tools {
        maven 'maven17'
    }

    stages {

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t hello-java:latest .'
            }
        }

        stage('Push to Nexus Docker Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-creds', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh '''
                    echo $PASS | docker login localhost:5000 -u $USER --password-stdin
                    docker tag hello-java:latest localhost:5000/hello-java:latest
                    docker push localhost:5000/hello-java:latest
                    '''
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                # Зупиняємо старий контейнер, якщо він існує
                docker rm -f hello-java || true
        
                # Запускаємо новий контейнер
                docker run -d -p 8085:8080 --name hello-java hello-java:latest
                '''
            }
        }
    }
}
