# Innovatech - Documentación técnica

Este repositorio contiene la solución del proyecto Innovatech desplegada sobre Kubernetes (EKS), con frontend, microservicios backend y base de datos MySQL.

## Objetivo
Implementar una solución escalable, automatizada y observable, utilizando contenedores, GitHub Actions, Kubernetes y secretos administrados de forma segura.

## Componentes
- Frontend en React + Nginx.
- Microservicio de ventas en Spring Boot.
- Microservicio de despachos en Spring Boot.
- Base de datos MySQL.
- Pipeline CI/CD con GitHub Actions.
- Despliegue en Kubernetes.

## Documentación disponible
- Arquitectura.
- Docker.
- CI/CD.
- Secrets.
- Observabilidad.
- Validación funcional.

## Alcance del proyecto
La solución permite:
- Desplegar servicios en contenedores.
- Automatizar la construcción y publicación de imágenes.
- Ejecutar los servicios en Kubernetes.
- Conectar frontend, backend y base de datos.
- Verificar el estado del sistema mediante logs y métricas.

## Estructura del repositorio
- `frontend/`: código fuente del frontend.
- `backend/`: código fuente de los microservicios.
- `kubernetes/`: manifiestos de despliegue.
- `docs/`: documentación técnica del proyecto.

## Evidencia del sistema
La solución fue validada con:
- Pods en estado Running.
- Servicios expuestos correctamente.
- Base de datos accesible.
- Comunicación entre frontend y backend.
- Autoscaling configurado.
- Pipeline CI/CD funcionando.