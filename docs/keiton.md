# Aprendizajes y aporte personal al trabajo - Keiton Chaves

Durante el desarrollo del proyecto de InnovaTech, mi participación se centró exclusivamente en la base operativa y estructural del entorno DevOps, absteniéndome del desarrollo de software, dado que el código fuente del frontend y los microservicios backend fue provisto directamente por la cátedra. Mi rol se concentró en el diseño y aprovisionamiento de la infraestructura en la nube, y en la definición e implementación del stack de persistencia de datos necesario para que dichos componentes provistos pudieran operar de forma distribuida. Trabajé en la configuración del motor de base de datos para asegurar el correcto almacenamiento del ecosistema, colaborando con Sergio Soto en el mapeo de variables dentro de los contenedores y con Matías Chavez para asegurar que los Secrets de Kubernetes inyectaran las credenciales correctas en el clúster. Mi aporte estuvo orientado a establecer un entorno de infraestructura sólido, seguro y con la alta disponibilidad necesaria para el despliegue de la solución.

## Cómo se desarrolló el proyecto

El proyecto se ejecutó bajo un enfoque de ingeniería de infraestructura progresivo. Tomando como punto de partida las aplicaciones modulares entregadas por el docente, la primera instancia consistió en definir la arquitectura de red y el motor de base de datos idóneo para soportar la persistencia de los servicios de ventas y despachos. Una vez validados los entornos locales mediante contenedores y Docker Compose, avanzamos hacia la fase crítica de despliegue en la nube de AWS utilizando Amazon EKS como orquestador.

Durante este proceso, el mayor reto técnico radicó en integrar la persistencia de datos dentro de la arquitectura de la nube, asegurando que las políticas de red interna permitieran a los microservicios backend comunicarse con la base de datos de manera aislada. La colaboración estrecha del equipo nos permitió resolver las inconsistencias de conectividad iniciales, logrando validar el despliegue del ecosistema completo en un escenario productivo real.

## Decisiones técnicas tomadas

Una de las decisiones más estratégicas en las que participé activamente fue la elección e implementación del stack de la base de datos que complementaría el código entregado. Optamos por un motor que garantizara transacciones seguras y escalabilidad para resguardar los datos de los módulos transaccionales.

Asimismo, apoyé la decisión arquitectónica de aislar completamente la capa de datos y los microservicios backend dentro de la red privada del clúster EKS. De esta forma, el frontend actúa como el único punto de entrada público, mitigando vectores de ataque directos y resguardando las cadenas de conexión y credenciales críticas mediante Kubernetes Secrets, evitando cualquier exposición de datos sensibles en el código fuente o en las configuraciones del repositorio.

## Cómo funciona la solución implementada

La solución opera mediante un pipeline completamente automatizado de Integración y Despliegue Continuo (CI/CD) a través de GitHub Actions. Al realizar un push en la rama principal, el flujo construye las imágenes de Docker de los componentes provistos, las aloja en Amazon ECR y actualiza los deployments en Amazon EKS de forma automática.

Dentro del clúster, el flujo de información se desencadena cuando el frontend interactúa con los microservicios backend. Estos componentes consumen y procesan la lógica de negocio consultando de forma interna a la base de datos que aprovisionamos, cuyas credenciales se inyectan dinámicamente en tiempo de ejecución desde los Secrets de Kubernetes. El sistema está respaldado por Horizontal Pod Autoscaling (HPA), ajustando la cantidad de réplicas de los pods de manera dinámica según el consumo de CPU para absorber variaciones en la carga de trabajo.

## En qué partes participó directamente

Mi participación directa se concentró en las siguientes actividades clave del entorno DevOps:
* **Definición del Stack de Persistencia:** Selección, configuración e inicialización del motor de base de datos del proyecto para asegurar el almacenamiento de los módulos transaccionales entregados.
* **Diseño y Configuración de Infraestructura:** Apoyo en el aprovisionamiento y estructuración de los recursos necesarios en la nube para el correcto funcionamiento del clúster orquestado.
* **Seguridad y Conectividad Interna:** Definición de los parámetros de red interna y variables de entorno para que los microservicios backend se conectaran eficientemente al motor de datos.
* **Pruebas de Integración Operativa:** Apoyo en la validación y pruebas de comunicación de extremo a extremo (Frontend - Backend - Base de datos) en el entorno de despliegue junto al equipo.

## Principal aporte al equipo

Mi principal contribución al equipo consistió en garantizar la disponibilidad, robustez y seguridad de la capa de datos e infraestructura que dio soporte a la aplicación del docente. Al concentrarme en la base operativa y la persistencia, permití que mis compañeros estructuraran los Dockerfiles y las políticas de escalado (HPA) sobre una arquitectura de red y datos predecible y bien definida. Además, mi enfoque preventivo en el manejo de credenciales robusteció la seguridad del entorno frente a los requerimientos de la rúbrica de evaluación.

## Aspectos técnicos que domino

Los aspectos que domino con total propiedad y que puedo defender técnicamente en la evaluación individual son:
* **Gestión de Bases de Datos en Microservicios:** Configuración, vinculación y optimización de motores de bases de datos integrados en ecosistemas contenedorizados.
* **Aprovisionamiento de Infraestructura Cloud:** Comprensión y diseño de la arquitectura de red y despliegue de servicios distribuidos en entornos de nube (AWS / EKS).
* **Aislamiento de Redes y Seguridad (DevSecOps):** Implementación de políticas de acceso cerradas dentro de un clúster de Kubernetes, comunicación interna mediante nombres de servicios nativos e inyección de variables mediante Secrets.
* **Diagnóstico de Errores de Conexión:** Uso de logs y comandos de inspección (`kubectl`) para trazar problemas de red, timeouts de bases de datos y fallos en el handshake de comunicación entre componentes distribuidos.

## Aprendizaje personal

Este proyecto significó una inmersión profunda en los estándares reales de la industria bajo la cultura DevOps, demostrando que la configuración del entorno es tan crítica como el software mismo. Aprendí que desplegar una aplicación de terceros o provista por un cliente requiere una comprensión rigurosa de sus dependencias, variables de entorno y requerimientos de red. Asimismo, trabajar en el pipeline y la nube me enseñó el valor de la automatización y el aislamiento de datos, transformando cada fallo de comunicación en una oportunidad para robustecer el sistema y mejorar mi capacidad de resolución de problemas en arquitecturas distribuidas.