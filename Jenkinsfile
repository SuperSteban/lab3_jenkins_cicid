pipeline {
    agent { label 'pc-windows' }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Ejecutando tests desde el script...'
                // Usamos 'sh' si usas Git Bash o 'bat' si es CMD
                // Asumiendo que scripts/tests.sh es un script de shell:
                sh "bash ./scripts/test.sh"
            }
        }

        stage('Build & Deploy (Docker)') {
            steps {
                script {
                    echo "Construyendo imagen: ${IMAGE_NAME}..."
                    // Construye la imagen usando el Dockerfile de tu raíz
                    sh "docker build -t ${IMAGE_NAME} ."

                    echo "Limpiando contenedores antiguos..."
                    // Detiene y elimina el contenedor si ya existe para evitar errores de puerto ocupado
                    sh "docker rm -f ${CONTAINER_NAME} || true"

                    echo "Lanzando contenedor en puerto 3001..."
                    // Corre el contenedor en segundo plano (-d)
                    sh "docker run -d -p 3001:3001 --name ${CONTAINER_NAME} ${IMAGE_NAME}"
                }
            }
        }
    }

    post {
        always {
            echo 'Limpiando espacio de trabajo...'
        }
    }
}