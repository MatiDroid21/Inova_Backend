# Aprendizajes y aporte personal al trabajo Matías Chavez

Durante el desarrollo del proyecto participé en la parte operativa de la solución, especialmente en la configuración de los deployments, el uso de Secrets, la validación del funcionamiento entre frontend y backend, y la revisión del autoscaling en el clúster EKS. Mi aporte estuvo enfocado en asegurar que los servicios quedaran bien conectados, que las variables de entorno se cargaran correctamente y que la aplicación pudiera mantenerse estable dentro del entorno orquestado.

## Cómo se desarrolló el proyecto

El proyecto se desarrolló en varias etapas. Primero se trabajó la aplicación contenedorizada y luego se avanzó hacia su despliegue en AWS, usando EKS como plataforma principal de orquestación. A partir de eso, se levantaron los servicios de frontend, ventas y despachos, además de la base de datos, integrando también autoscaling y un pipeline CI/CD con GitHub Actions.

Durante el proceso fue necesario probar varias veces la comunicación entre componentes, revisar errores de despliegue y ajustar configuraciones hasta que todo funcionara correctamente. Esto hizo que el proyecto no solo quedara desplegado, sino también validado en condiciones reales.

## Decisiones técnicas tomadas

Una de las decisiones más importantes fue mantener el frontend público y dejar los microservicios backend internos dentro del clúster. Esto permitió tener una arquitectura más segura y ordenada. También se decidió usar Kubernetes Secrets para manejar credenciales y variables sensibles, evitando exponer información directamente en el código.

Otra decisión relevante fue configurar HPA para que los servicios pudieran escalar de forma automática según la carga. Esto ayudó a que la solución fuera más estable y más cercana a un entorno productivo. Además, se optó por usar nombres de servicio internos para la comunicación entre contenedores, en lugar de IPs fijas, porque eso hace que la arquitectura sea más flexible y fácil de mantener.

## Cómo funciona la solución implementada

La solución funciona con un flujo automatizado. Cuando se realiza un cambio en el repositorio, GitHub Actions construye la imagen, la publica en ECR y luego despliega los cambios en EKS. Dentro del clúster, el frontend se comunica con los microservicios backend y estos a su vez acceden a la base de datos usando variables de entorno cargadas desde Secrets.

El sistema también cuenta con autoscaling para que los pods puedan ajustarse según el uso de CPU. Gracias a eso, la aplicación puede responder mejor frente a aumentos de carga y mantener una mejor disponibilidad.

## En qué partes participé directamente

Participé directamente en la revisión y ajuste de los deployments, en la configuración de Secrets y en la validación del flujo entre frontend y backend. También apoyé en la comprobación de los servicios dentro del clúster y en la resolución de problemas relacionados con la conexión entre componentes.

Otra parte importante de mi participación fue verificar que el autoscaling estuviera bien configurado y que los servicios se mantuvieran funcionales después de cada despliegue. Esto fue clave para asegurar que la solución final no solo se viera bien, sino que realmente funcionara.

## Principal aporte al equipo

Mi principal aporte fue asegurar la correcta integración entre los servicios y ayudar a que la solución quedara estable dentro del clúster. Me enfoqué en la parte de configuración funcional, especialmente en los detalles que afectan la comunicación interna, el uso de credenciales y la validación del comportamiento del sistema.

También aporté en la detección y corrección de errores que aparecieron durante las pruebas, lo que ayudó a que el proyecto avanzara desde una implementación básica hacia una solución más sólida y confiable.

## Aspectos técnicos que domino

Los aspectos que mejor domino de este proyecto son el uso de Kubernetes para desplegar servicios, la gestión de Secrets, la validación de pods y servicios, y la comprensión del autoscaling mediante HPA. También puedo defender cómo funciona la comunicación entre frontend y backend dentro del clúster y por qué es mejor usar servicios internos en lugar de IPs fijas.

Además, puedo explicar cómo se valida una solución con herramientas como `kubectl logs`, `kubectl exec` y los comandos de revisión del estado de los pods y servicios. Esto me permite defender tanto la parte de funcionamiento como los problemas que se resolvieron durante la implementación.

## Aprendizaje personal

Este proyecto me ayudó a entender mejor cómo se trabaja en un entorno más cercano a producción. Aprendí que no basta con desplegar una aplicación, sino que también hay que pensar en seguridad, escalabilidad, recuperación ante fallos y monitoreo.

También comprendí la importancia de probar, corregir y validar constantemente. Los errores que aparecieron durante el proceso fueron parte importante del aprendizaje, porque permitieron entender mejor cómo se comporta realmente una arquitectura en Kubernetes.
