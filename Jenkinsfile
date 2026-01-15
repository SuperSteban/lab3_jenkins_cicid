pipeline {
    // Cambiamos el label para que use el nodo principal de Linux
    agent { label 'built-in' } 

    environment {
        IMAGE_NAME = "react-app-lab"
        CONTAINER_NAME = "react-container"
    }

    stages {
        stage('Checkout') {
            steps {
                // Clona el repo automáticamente
                checkout scm
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Ejecutando tests...'
                // Damos permisos de ejecución y corremos el script
                sh "chmod +x ./scripts/build.sh"
                sh "./scripts/build.sh"
                sh "chmod +x ./scripts/tests.sh"
                sh "./scripts/tests.sh"
            }
        }

        stage('Build & Deploy (Docker)') {
            steps {
                script {
                    echo "Construyendo imagen: ${env.IMAGE_NAME}..."
                    sh "docker build -t ${env.IMAGE_NAME} ."

                    echo "Limpiando contenedor anterior si existe..."
                    // En Linux, '|| true' evita que el pipeline falle si no hay contenedor
                    sh "docker rm -f ${env.CONTAINER_NAME} || true"

                    echo "Iniciando contenedor en puerto 3000..."
                    sh "docker run -d -p 3000:3000 --name ${env.CONTAINER_NAME} ${env.IMAGE_NAME}"
                }
            }
        }
    }

    post {
        always {
            echo 'Finalizando proceso...'
        }
        success {
            echo "Despliegue exitoso en el nodo principal."
        }
    }
}