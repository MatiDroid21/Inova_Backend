# Pipeline CI/CD

## Objetivo
Automatizar la construcción, publicación y despliegue de los servicios para reducir intervención manual y errores operativos.

## Flujo del pipeline
1. Push a la rama principal.
2. GitHub Actions ejecuta el workflow.
3. Se construye la imagen Docker.
4. La imagen se publica en Amazon ECR.
5. Se actualiza el despliegue en Kubernetes.

## Repositorios involucrados
- Frontend.
- Backend.

## Variables y secretos
El pipeline utiliza secretos para:
- Credenciales de AWS.
- Registro de ECR.
- Nombre del clúster EKS.
- URL del backend para el frontend.

## Tiempos observados
- Build & Push API Ventas: 48s.
- Build & Push API Despachos: 54s.
- Deploy backend: 2m 21s.
- Build & Push frontend: 28s.
- Deploy frontend: 20s.

## Resultado
Cada push permite llevar la nueva versión al clúster sin pasos manuales intermedios.

## Evidencia
La ejecución del pipeline fue verificada con despliegues exitosos y repositorios actualizados en ECR.