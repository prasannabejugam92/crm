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

        stage('Start Containers') {
            steps {
                    sh '''
                    docker compose down --remove-orphans || true
                    docker rm -f crm_mysql || true
                    docker rm -f laravel_app || true
                    docker compose up -d --build
                    '''
            }
        }

        stage('Laravel Setup') {
            steps {
                sh '''
                docker exec laravel_app composer install --no-dev --optimize-autoloader
                docker exec laravel_app php artisan migrate --force
                docker exec laravel_app php artisan config:cache
                docker exec laravel_app php artisan route:cache
                docker exec laravel_app php artisan view:cache
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful'
        }

        failure {
            echo 'Deployment Failed'
        }
    }
}
