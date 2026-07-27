pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker compose build'
            }
        }

        stage('Debug') {
                steps {
                    sh '''
                    pwd
                    ls -la
                    docker compose config
                    '''
                }
        }

        stage('Start Containers') {
            steps {
                    sh '''
                    docker compose down --remove-orphans || true
                    docker compose up -d --build
                    '''
            }
        }

        stage('Wait for Container') {
            steps {
                sh 'sleep 15'
            }
        }

        stage('Laravel Setup') {
            steps {
                sh '''
                APP_CONTAINER=$(docker compose ps -q apache)
                docker exec $APP_CONTAINER composer install --no-dev --optimize-autoloader
                docker exec $APP_CONTAINER php artisan key:generate --force || true
                docker exec $APP_CONTAINER php artisan migrate --force
                docker exec $APP_CONTAINER php artisan config:cache
                docker exec $APP_CONTAINER php artisan route:cache
                docker exec $APP_CONTAINER php artisan view:cache
                docker exec $APP_CONTAINER php artisan storage:link || true
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful'
        }

        failure {
            sh 'docker ps -a || true'
            sh 'docker compose logs --tail=100 || true'
            echo 'Deployment Failed'
        }
    }
}
