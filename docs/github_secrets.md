# Gestión de secretos y credenciales

## Objetivo
Evitar la exposición de credenciales sensibles en el código fuente y centralizar la configuración segura.

## Uso de secretos
Los secretos se usan para:
- Credenciales de base de datos.
- Variables de conexión JDBC.
- Datos de AWS requeridos por GitHub Actions.
- URL del backend para el frontend.

## Implementación
Las credenciales se inyectan en los pods mediante Kubernetes Secrets y variables de entorno.

## Beneficios
- No se exponen credenciales en el código.
- La configuración es reutilizable.
- Separamos configuración de implementación.

## Ejemplo de uso
Spring Boot construye la conexión a la base de datos usando las variables proporcionadas por el Secret.

## Buenas prácticas aplicadas
- No hardcodear contraseñas.
- Centralizar configuración sensible.
- Mantener los secretos fuera del repositorio.