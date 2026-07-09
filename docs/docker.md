# Contenerización con Docker

## Objetivo
Containerizar cada componente de la aplicación para garantizar portabilidad, consistencia entre entornos y despliegue reproducible.

## Imágenes utilizadas
- Frontend.
- Ventas.
- Despachos.
- MySQL.

## Frontend
El frontend se construyó como una imagen basada en Nginx para servir la aplicación compilada.

## Backend
Los microservicios backend se construyeron como imágenes Java/Spring Boot, listas para ejecutarse en contenedores.

## Base de datos
MySQL se ejecuta como contenedor independiente dentro del clúster, con persistencia y configuración propia.

## Beneficios de Docker
- Asegura el mismo comportamiento en local y en despliegue.
- Facilita el versionado de imágenes.
- Permite integrarse con GitHub Actions y ECR.
- Simplifica la orquestación en Kubernetes.

## Validación
La contenerización fue validada mediante:
- Construcción de imágenes sin errores.
- Publicación en ECR.
- Despliegue en el clúster.
- Consumo correcto entre servicios.