# 🧠 Prompt Base – GevenSoft | Plan Técnico de Desarrollo

## 📘 Contexto
Somos el equipo de desarrollo de **GevenSoft**, un ERP multiplataforma diseñado y coordinado por **Javier Fernández Lorca (Project Manager)**.  
Trabajamos en **Delphi**, con bases de datos **PostgreSQL**, y bajo una **arquitectura modular por capas**.  
Cada empresa tiene su propia base de datos, y existe una base central que gestiona las conexiones (host, usuario, contraseña, etc.).

---

## 🔧 Filosofía
1. **Claridad:** el código debe ser limpio, legible y coherente.  
2. **Reutilización:** toda la lógica de negocio debe poder usarse desde distintas interfaces (escritorio, API, web).  
3. **Escalabilidad:** el sistema debe crecer sin necesidad de reescribir sus bases.  

---

## 🗂️ Estructura del proyecto

```
/src
 ├── /Common    → utilidades, constantes, configuración
 ├── /Data      → conexión a BD (FireDAC)
 ├── /Services  → lógica de negocio y reglas funcionales
 ├── /Domain    → entidades (clientes, facturas, etc.)
 └── /UI        → interfaz de usuario (formularios, frames, editores)
```

---

## 🧩 Arquitectura

El sistema sigue un modelo **en capas**:

- **UI:** Interfaz visual sin lógica de negocio.  
- **Services:** Lógica funcional y reglas.  
- **Data:** Acceso a base de datos.  
- **Domain:** Clases de dominio (modelo de datos puro).  

Cada capa comunica solo con la siguiente, y ninguna accede directamente a la base de datos salvo la capa `Data`.

---

## 📚 Convenciones de nombres

| Tipo | Prefijo | Ejemplo |
|------|----------|----------|
| Formulario | `f` | `fMain.pas` |
| Editor | `ed` | `edInvoice.pas` |
| Frame | `fr` | `frAddress.pas` |
| DataModule | `dm` | `dmSession.pas` |
| Servicio | `svc` | `svcAuth.pas` |
| Utilidad | `u` | `uConsts.pas` |

Clases y métodos usan **PascalCase**, variables **camelCase**, y constantes en **MAYÚSCULAS_CON_GUIONES**.  
No se usa el nombre comercial en prefijos (por ejemplo, no usar `GevenSoft_`).

---

## 🌐 Modelo multiempresa

- Una base central almacena las credenciales de conexión de cada empresa.  
- Cada empresa tiene su propia base de datos.  
- El sistema selecciona y conecta dinámicamente según el usuario o empresa activa.  

---

## 🔗 Preparación para API REST

- Lógica central reutilizable desde una futura API (Horse o DMVCFramework).  
- Comunicación JSON, autenticación JWT, y transporte HTTPS.  
- Ningún formulario debe contener lógica o SQL.  

---

## 🧱 Estándares de programación

- Evitar `with...do`.  
- Usar `try...finally` en toda operación con recursos.  
- No repetir código.  
- SQL solo en la capa `Data`.  
- Commits Git con prefijos:  
  - `feat:` (nueva función)  
  - `fix:` (corrección)  
  - `refactor:` (mejora de código)  
  - `docs:` (documentación)  
  - `chore:` (configuración o tareas)  
- Revisar código antes de integrar.  

---

## 🚀 Visión futura

- Evolucionar hacia un sistema distribuido (UI + API + BD).  
- Migración progresiva hacia arquitectura **hexagonal (puertos y adaptadores)**.  
- Preparar integración con sistemas externos (facturación electrónica, transporte, pasarelas de pago, etc.).  
- Mantener independencia tecnológica: el dominio debe ser reutilizable incluso fuera de Delphi.

---

## 🧭 Documentación

El documento oficial es el **Plan Técnico de Desarrollo – GevenSoft (v1.0, Noviembre 2025)**.  
Todas las decisiones y solicitudes técnicas deben alinearse con él.

---

## 💬 Instrucción para usar con ChatGPT

> **Antes de responder, recuerda:**  
> Trabajamos bajo las normas del *Plan Técnico de Desarrollo – GevenSoft*.  
> Usa arquitectura por capas, nomenclatura coherente, y orienta todas tus soluciones a la reutilización y escalabilidad.  
> El lenguaje principal es **Delphi**, y la base de datos **PostgreSQL**.  
> No incluyas lógica SQL en la UI y sigue el estándar de nombres establecido.
