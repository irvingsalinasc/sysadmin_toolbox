# 🛠️ sysadmin_toolbox
Herramientas para administración de infraestructuras de sistemas
---------------------------------------------------------------------------------

Este repositorio es mi centro de control para la gestión de infraestructura. Contiene scripts de automatización para redes, virtualización y auditoría de sistemas.

## 📁 Contenido del Repositorio

### 🛡️ Redes
* `/redes/`: Scripts de revisión de red y troubleshooting
* `/fortinet/backups/`: Scripts para la extracción automática de archivos de configuración (`.conf`) vía SSH/SCP.
* `/fortinet/templates/`: Plantillas de políticas comunes y objetos de red.

### ☁️ Virtualización
* `/vmware/resource-check.ps1`: Script en PowerCLI para revisar CPU/RAM/Disk de VMs con sobreasignación.
* `/vmware/snapshots/`: Herramientas para detectar y limpiar snapshots antiguos que consumen almacenamiento.

### 🔍 Auditoría e Infraestructura
* `/infra/health-check.sh`: Revisión general de estado de servidores (uptime, carga, logs críticos).
* `/infra/inventory/`: Scripts para generar reportes de inventario de hardware y SO.

---

## 🚀 Comandos de Referencia Rápida

### Backup de Fortigate (CLI)
```bash
# Ejemplo de comando para backup manual vía TFTP
execute backup config tftp backup-archivo.conf 192.168.1.100
