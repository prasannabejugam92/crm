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
                docker exec crm_app composer install --no-dev --optimize-autoloader
                docker exec crm_app php artisan key:generate --force || true
                docker exec crm_app php artisan migrate --force
                docker exec crm_app php artisan config:cache
                docker exec crm_app php artisan route:cache
                docker exec crm_app php artisan view:cache
                docker exec crm_app php artisan storage:link || true
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
