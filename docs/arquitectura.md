# Arquitectura de la solución

## Descripción general
La solución fue diseñada sobre Kubernetes (EKS) para cumplir con el objetivo de desplegar una aplicación distribuida, escalable y automatizada.

## Componentes principales
- **Frontend**: aplicación React servida con Nginx.
- **Ventas**: microservicio Spring Boot para lógica de ventas.
- **Despachos**: microservicio Spring Boot para la lógica de despacho.
- **MySQL**: base de datos relacional desplegada dentro del clúster.
- **GitHub Actions**: automatización de build, push y deploy.
- **ECR**: almacenamiento de imágenes de contenedor.
- **Kubernetes**: orquestación de servicios.

## Flujo de funcionamiento
1. El desarrollador realiza un push al repositorio.
2. GitHub Actions construye la imagen.
3. La imagen se publica en ECR.
4. Kubernetes despliega la nueva versión en el clúster.
5. El frontend consume los servicios backend por DNS interno.
6. Los microservicios se conectan a MySQL mediante variables de entorno.

## Decisiones técnicas
### Uso de EKS
Se eligió EKS porque permite trabajar con Kubernetes nativo, HPA y manifiestos portables.

### Uso de MySQL dentro del clúster
Se optó por MySQL como pod dentro del clúster para mantener coherencia con el entorno de desarrollo y evitar depender de un servicio externo.

### Separación de servicios
Ventas y despachos se separaron para aislar responsabilidades y facilitar el mantenimiento.

### Exposición de servicios
Solo el frontend se expone públicamente. Los microservicios y la base de datos permanecen internos.

## Comunicación entre componentes
- Frontend => Ventas: DNS interno de Kubernetes.
- Frontend => Despachos: DNS interno de Kubernetes.
- Backend =>  MySQL: servicio interno y variables de entorno.