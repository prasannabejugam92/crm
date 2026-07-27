pipeline {

    agent any

    environment {
        APP_DIR = "/var/www/html/crm"
        APP_NAME = "crm_app"
        COMPOSE = "docker compose"
    }

    stages {

        stage('Checkout') {

            steps {

                git branch: 'master',

                    url: 'https://github.com/prasannabejugam92/crm.git'

            }

        }


        stage('Install Dependencies') {
            steps {
                sh 'composer install --no-dev --prefer-dist --optimize-autoloader'
            }
        }


        stage('Testing') {

            steps {

                sh 'php artisan test'

            }

        }

        stage('Docker Build') {

            steps {

                sh 'docker build -t crm .'

            }

        }

        stage('Deploy') {

            steps {

                sh '''
                docker compose down
                docker compose up -d
                '''
            }

        }


        stage('Laravel Optimization') {

            steps {

                sh '''

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

            echo "Deployment Successful"

        }

        failure {

            echo "Deployment Failed"

        }

    }

}