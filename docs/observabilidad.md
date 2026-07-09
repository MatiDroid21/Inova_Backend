# Observabilidad

## Objetivo
Verificar el estado del sistema y detectar fallas mediante logs, eventos y estado de pods.

## Herramientas utilizadas
- `kubectl get pods`
- `kubectl logs`
- `kubectl describe pod`
- `kubectl get hpa`
- Observación de reinicios y estados de contenedores

## Qué se monitoreó
- Estado de los pods.
- Reinicios de contenedores.
- Disponibilidad de servicios.
- Variación de uso de CPU.
- Comportamiento del autoscaling.

## Incidentes resueltos
### Frontend con error 504
Se detectó que Nginx apuntaba a IPs locales y se corrigió usando DNS interno de Kubernetes.

### CrashLoopBackOff en backend
Se identificó el problema de autenticación con MySQL 8 y se ajustó la URL JDBC mediante un Secret.

## Resultado
Tras las correcciones, los servicios volvieron a estado operativo.