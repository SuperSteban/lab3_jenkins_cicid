pipeline {
    agent { label 'debian-agent' } 

    environment {
        IMAGE_NAME = "react-app-lab"
        CONTAINER_NAME = "react-container"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Docker Build') {
            steps {
                echo "Construyendo la imagen con todo el código..."
                // Construimos la imagen. El Dockerfile debe tener el COPY . .
                sh "docker build -t ${env.IMAGE_NAME} ."
            }
        }

        stage('Run Tests Inside Container') {
            steps {
                echo 'Ejecutando tests dentro de la imagen construida...'
                // Corremos un contenedor temporal para ejecutar el script de tests
                // --rm borra el contenedor al terminar el test
                sh "docker run --rm ${env.IMAGE_NAME} npm test -- --watchAll=false"
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Tests aprobados. Procediendo al despliegue..."
                    
                    echo "Limpiando contenedor anterior..."
                    sh "docker rm -f ${env.CONTAINER_NAME} || true"

                    echo "Levantando contenedor final en puerto 3000..."
                    sh "docker run -d -p 3000:3000 --name ${env.CONTAINER_NAME} ${env.IMAGE_NAME}"
                    
                    echo "-----------------------------------------------------------"
                    echo "¡DESPLIEGUE REALIZADO EXITOSAMENTE!"
                    echo "Accede en: http://localhost:3000 (o la IP de tu servidor)"
                    echo "-----------------------------------------------------------"
                }
            }
        }
    }

    post {
        failure {
            echo "El pipeline falló. Posiblemente los tests no pasaron."
        }
    }
}