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
        stage('Run Tests Inside Container') {
            steps {
                echo 'Ejecutando tests...'
                sh "chmod +x ./scripts/build.sh" 
                sh "./scripts/build.sh" 
                sh "chmod +x ./scripts/test.sh" 
                sh "./scripts/test.sh" 


            }
        }
        

        stage('Deploy') {
            steps {
                script {
                    echo "Tests aprobados. Procediendo al despliegue..."
                    echo "Construyendo la imagen con todo el código..."
                    sh "docker build -t ${env.IMAGE_NAME} ."
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