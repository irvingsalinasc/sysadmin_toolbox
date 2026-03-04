**IASC - KIT DE SOPORTE TÉCNICO PROFESIONAL**

Creado por: Irving Adair Salinas Cervantes

Email: Irving.salinas@engineer.com

Información: https://irvingsalinas.jimdofree.com/

---------------------------------------------------------------------------

**Manual Técnico: Kit de Soporte IASC v3.0 (Edición Definitiva)**

Propósito: Diagnóstico automatizado de conectividad para usuarios remotos y locales, con recolección de métricas de rendimiento y auditoría de identidad.



1\. Componentes del Kit

Para que el sistema funcione, los siguientes archivos deben residir en la misma carpeta:

-Lanzador.bat: Gestiona la elevación de privilegios y bypass de políticas de seguridad.

-SoporteRed.ps1: El motor principal de diagnóstico.

-Speedtest.exe: Ejecutable de línea de comandos para métricas de ancho de banda.



2\. Flujo de Ejecución para el Usuario

El técnico debe indicar al usuario:

-Ejecución: Haz doble clic en Lanzador.bat.

-Autorización: Si aparece el Control de Cuentas de Usuario (UAC), selecciona Sí.

-Interacción: La ventana azul mostrará tu nombre y equipo. Espera a que se abra el Speedtest, realiza la prueba y cierra la ventana del Speedtest para continuar.

-Finalización: Al terminar, se abrirá automáticamente un archivo de texto en el Bloc de Notas. Envía ese archivo al técnico.



3\. Puntos Críticos de Auditoría (El Log)

El archivo C:\\scripts\_logs\\soportered.txt registra datos vitales que debes revisar como soporte:



|**Dato Registrado**|**Utilidad para el Soporte**|
|-|-|
|Usuario / Equipo|Identifica quién reporta y desde qué hardware (sin preguntar).|
|IP / Interfaz|Confirma si el usuario está por Wi-Fi, Ethernet o tiene una IP inválida (169.x).|
|MSDT Status|Indica si Windows logró reparar errores en la pila TCP/IP automáticamente.|
|Ping Google|Define si el problema es la salida a Internet del proveedor (ISP).|
|Servicios Empresariales|Verifica específicamente la VPN y el acceso a los controladores de dominio.|



4. Resolución de Problemas Comunes (FAQ para el Técnico)

-¿El Speedtest no abre? 

Revisa que el archivo Speedtest.exe esté en la carpeta. El script te dará un error en rojo si no lo encuentra.



-¿El log sale vacío? 

Asegúrate de que el usuario tenga permisos de escritura en C:\\. El lanzador .bat debería resolver esto al ejecutar como Administrador.



-¿Los pings a Servicios Empresariales fallan? 

Si el Ping a Google es exitoso, el problema reside exclusivamente en la conexión VPN o en el Gateway de la oficina remota.

