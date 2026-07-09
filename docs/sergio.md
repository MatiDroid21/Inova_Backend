# Aprendizajes y aporte personal al trabajo - Sergio Soto

Durante el desarrollo del proyecto participé activamente en la etapa estructural de la solución, enfocándome principalmente en la contenedorización de las aplicaciones mediante la creación y optimización de Dockerfiles personalizados y la configuración del entorno local con Docker Compose. Asimismo, asistí de cerca a Matías Chavez en la transición hacia la nube, apoyándolo en la configuración operativa de los deployments, el manejo de Secrets y la validación de que la comunicación entre el frontend y el backend se mantuviera estable al migrar al clúster orquestado. Mi aporte estuvo concentrado en asegurar que las imágenes base quedaran bien configuradas, que las variables de entorno se mapearan correctamente y que el ecosistema completo funcionara de forma sólida tanto en local como en el entorno de producción.

## Cómo se desarrolló el proyecto

El proyecto se construyó de manera escalonada. Primero, nos enfocamos en empaquetar de forma independiente cada componente del sistema en contenedores Docker, aislando sus dependencias. Una vez que validamos el funcionamiento en local mediante Docker Compose, avanzamos en conjunto hacia el despliegue en AWS. En esta etapa, trabajé junto a Matías probando los servicios de frontend, ventas y despachos dentro del clúster, integrando además las políticas de autoescalado y el pipeline de CI/CD con GitHub Actions.

Durante el proceso, el mayor desafío fue testear repetidamente la red interna para asegurar que la comunicación entre componentes fuera fluida y sin latencia. Revisar constantemente los errores de despliegue y ajustar las configuraciones en equipo nos permitió levantar una solución completamente validada bajo condiciones reales.

## Decisiones técnicas tomadas
Una de las decisiones más importantes en mi área fue estandarizar el uso de imágenes base oficiales y ligeras para asegurar la compatibilidad de todas las dependencias del backend y frontend. Además, en conjunto con el equipo de despliegue, decidimos centralizar la gestión de variables de entorno y Secrets de manera que la arquitectura de microservicios backend quedara interna y protegida dentro del clúster, dejando expuesto únicamente el frontend público para garantizar la seguridad del sistema.
