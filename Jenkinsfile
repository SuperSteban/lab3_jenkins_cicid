pipeline {
    agent {
        label 'pc-windows'
    }
    
    environment {
        // Definir puerto según la rama
        PORT = "${env.BRANCH_NAME == 'main' ? '3000' : '3001'}"
        IMAGE_NAME = "cicd-app-${env.BRANCH_NAME}"
        CONTAINER_NAME = "cicd-container-${env.BRANCH_NAME}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo "========== CHECKOUT =========="
                echo "Branch: ${env.BRANCH_NAME}"
                echo "Puerto asignado: ${PORT}"
                checkout scm
                
                script {
                    // Mostrar que logo.svg está presente
                    bat 'dir src\\logo.svg || dir public\\logo.svg'
                }
            }
        }
        
        stage('Build') {
            steps {
                echo "========== BUILD =========="
                script {
                    if (env.BRANCH_NAME == 'main') {
                        echo 'Building MAIN branch (Production) - Puerto 3000'
                    } else if (env.BRANCH_NAME == 'dev') {
                        echo 'Building DEV branch (Development) - Puerto 3001'
                    }
                }
                
                // Instalar dependencias
                bat 'npm install'
            }
        }
        
        stage('Test') {
            steps {
                echo "========== TEST =========="
                script {
                    // Ejecutar el script de test si existe
                    bat '''
                        if exist jenkins\\scripts\\test.sh (
                            echo Running test script...
                            sh jenkins/scripts/test.sh
                        ) else (
                            echo Running npm test directly...
                            npm test
                        )
                    '''
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo "========== BUILD DOCKER IMAGE =========="
                script {
                    // Detener y eliminar contenedor existente si existe
                    bat """
                        docker stop ${CONTAINER_NAME} 2>nul || echo Contenedor no existe
                        docker rm ${CONTAINER_NAME} 2>nul || echo Contenedor ya eliminado
                        docker rmi ${IMAGE_NAME}:latest 2>nul || echo Imagen no existe
                    """
                    
                    // Construir imagen Docker con el puerto como argumento
                    bat """
                        docker build -t ${IMAGE_NAME}:latest ^
                        --build-arg REACT_APP_PORT=${PORT} .
                    """
                    
                    echo "Imagen Docker creada: ${IMAGE_NAME}:latest"
                    echo "Puerto configurado: ${PORT}"
                }
            }
        }
        
        stage('Deploy') {
            steps {
                echo "========== DEPLOY =========="
                script {
                    // Desplegar contenedor con el puerto correcto
                    bat """
                        docker run -d ^
                        --name ${CONTAINER_NAME} ^
                        -p ${PORT}:3000 ^
                        -e PORT=${PORT} ^
                        ${IMAGE_NAME}:latest
                    """
                    
                    // Esperar a que el contenedor inicie
                    bat 'timeout /t 8 /nobreak'
                    
                    if (env.BRANCH_NAME == 'main') {
                        echo "========================================="
                        echo "✓ Aplicación MAIN desplegada"
                        echo "URL: http://localhost:3000"
                        echo "Logo: Estrella azul (MAIN)"
                        echo "========================================="
                    } else if (env.BRANCH_NAME == 'dev') {
                        echo "========================================="
                        echo "✓ Aplicación DEV desplegada"
                        echo "URL: http://localhost:3001"
                        echo "Logo: Engranaje verde (DEV)"
                        echo "========================================="
                    }
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                echo "========== VERIFY DEPLOYMENT =========="
                script {
                    // Verificar que el contenedor está corriendo
                    bat "docker ps --filter name=${CONTAINER_NAME}"
                    
                    // Verificar logs del contenedor
                    bat "docker logs ${CONTAINER_NAME}"
                    
                    echo "========================================="
                    echo "Contenedor: ${CONTAINER_NAME}"
                    echo "Estado: Running"
                    echo "Accede a: http://localhost:${PORT}"
                    echo "Verifica el logo.svg correspondiente"
                    echo "========================================="
                }
            }
        }
    }
    
    post {
        success {
            echo "========================================="
            echo "✓✓✓ PIPELINE EXITOSO ✓✓✓"
            echo "========================================="
            echo "Branch: ${env.BRANCH_NAME}"
            echo "Puerto: ${PORT}"
            echo "URL: http://localhost:${PORT}"
            if (env.BRANCH_NAME == 'main') {
                echo "Logo: Estrella azul (MAIN)"
            } else {
                echo "Logo: Engranaje verde (DEV)"
            }
            echo "========================================="
        }
        failure {
            echo "✗ Pipeline falló para branch ${env.BRANCH_NAME}"
            script {
                // Limpiar recursos en caso de fallo
                bat """
                    docker stop ${CONTAINER_NAME} 2>nul || exit 0
                    docker rm ${CONTAINER_NAME} 2>nul || exit 0
                """
            }
        }
        always {
            echo "Workspace cleanup completado"
        }
    }
}