# 📘 Plan Técnico de Desarrollo – GevenSoft

**Versión:** 1.0  
**Fecha:** Noviembre 2025  
**Proyecto dirigido por:** Javier Fernández Lorca – Project Manager  
**Departamento de Desarrollo – GevenSoft**  
© 2025 GevenSoft. Todos los derechos reservados.

---

## 📑 Índice

1. [Introducción](#1-introducción)  
2. [Estructura del Proyecto](#2-estructura-del-proyecto)  
3. [Convenciones de Nombres](#3-convenciones-de-nombres)  
4. [Arquitectura por Capas](#4-arquitectura-por-capas)  
5. [Modelo Multiempresa](#5-modelo-multiempresa)  
6. [Preparación para API REST](#6-preparación-para-api-rest)  
7. [Estándares de Programación](#7-estándares-de-programación)  
8. [Recomendaciones de Arquitectura Futura](#8-recomendaciones-de-arquitectura-futura)  
9. [Créditos y Mantenimiento del Documento](#9-créditos-y-mantenimiento-del-documento)

---

## 1. Introducción

Este documento establece las normas oficiales de desarrollo para el ERP de **GevenSoft**.  
Su objetivo es garantizar uniformidad, calidad técnica, mantenibilidad y escalabilidad a largo plazo.  

### Filosofía del desarrollo

1. **Claridad** – el código debe ser legible, coherente y autoexplicativo.  
2. **Reutilización** – la lógica debe poder emplearse desde distintas interfaces (escritorio, web o API REST).  
3. **Escalabilidad** – el sistema debe crecer sin necesidad de reescribir sus bases.

---

## 2. Estructura del Proyecto

```
/src
 ├── /Common
 ├── /Data
 ├── /Services
 ├── /Domain
 └── /UI
```

### Descripción de carpetas

- **/Common:** Constantes, utilidades, configuración.  
- **/Data:** Conexión y datasets (FireDAC).  
- **/Services:** Lógica de negocio y validaciones.  
- **/Domain:** Clases de dominio (entidades del sistema).  
- **/UI:** Formularios, frames y componentes visuales.

Ejemplo estructura UI:
```
/UI
 ├── /Shell/fMain.pas
 ├── /Customers/fCustomerList.pas
 ├── /Customers/edCustomer.pas
 └── /Invoices/edInvoice.pas
```

**Beneficios:** mantenibilidad, claridad, escalabilidad, y colaboración.

---

## 3. Convenciones de Nombres

### Prefijos de unidades (.pas)

| Tipo | Prefijo | Ejemplo |
|------|----------|----------|
| Formulario | `f` | `fMain.pas` |
| Editor | `ed` | `edInvoice.pas` |
| Frame | `fr` | `frAddress.pas` |
| DataModule | `dm` | `dmSession.pas` |
| Servicio | `svc` | `svcAuth.pas` |
| Utilidad | `u` | `uConsts.pas` |

> No usar el nombre comercial del producto en prefijos.

### Convención de clases

| Tipo | Convención | Ejemplo |
|------|-------------|----------|
| Formularios | `TFrmNombre` | `TFrmMain` |
| Servicios | `TSvcNombre` | `TSvcAuth` |
| DataModules | `TDmNombre` | `TDmSession` |
| Clases de dominio | `TNombre` | `TCustomer` |

### Ejemplo Delphi

```delphi
unit fMain;

type
  TFrmMain = class(TForm)
  public
    procedure ShowWelcome;
  end;

procedure TFrmMain.ShowWelcome;
begin
  ShowMessage('Bienvenido a GevenSoft');
end;
```

---

## 4. Arquitectura por Capas

```
┌──────────────────────────────┐
│  Capa de Interfaz (UI)       │
└─────────────┬────────────────┘
              │
┌─────────────▼────────────────┐
│  Capa de Servicios (Lógica)  │
└─────────────┬────────────────┘
              │
┌─────────────▼────────────────┐
│  Capa de Datos (Data)        │
└─────────────┬────────────────┘
              │
┌─────────────▼────────────────┐
│  Capa de Dominio (Domain)    │
└──────────────────────────────┘
```

Cada capa tiene una función específica y comunica solo con la siguiente.

**Ventajas:** reutilización, seguridad, mantenibilidad y escalabilidad.

---

## 5. Modelo Multiempresa

El sistema usa una base central + una base por empresa.  

**Flujo de conexión:**
1. Usuario selecciona empresa.  
2. Se consultan credenciales en la base central.  
3. Se establece conexión dinámica (FireDAC).

**Tabla central ejemplo:**
| id_empresa | nombre | host | puerto | base_datos | usuario | contraseña |
|-------------|---------|------|--------|-------------|----------|-------------|
| 1 | Empresa A | 192.168.1.10 | 5433 | empresa_a | admin | pass123 |

**Código ejemplo:**
```delphi
procedure TDmSession.ConnectToCompany(const ACompanyId: Integer);
begin
  // Lógica de conexión dinámica
end;
```

**Ventajas:** aislamiento, seguridad, escalabilidad, mantenimiento independiente.

---

## 6. Preparación para API REST

El ERP podrá exponer servicios REST reutilizando su capa de lógica (`Services`).  

### Ejemplo de flujo REST

1. Usuario envía `POST /login`.  
2. `svcAuth` valida credenciales.  
3. Devuelve token JWT.  

**Ejemplo básico (Horse):**
```delphi
THorse.Post('/login',
  procedure(Req: THorseRequest; Res: THorseResponse)
  begin
    if TSvcAuth.Login(User, Pass) then
      Res.Send('token')
    else
      Res.Status(401);
  end);
```

**Ventajas:** integración, seguridad, escalabilidad.

---

## 7. Estándares de Programación

### Buenas prácticas

- Evitar `with...do`.  
- Usar `try...finally`.  
- SQL solo en la capa `Data`.  
- Código limpio y comentado.  
- Commit Git con prefijos (`feat:`, `fix:`, `refactor:`, etc.).

**Ejemplo correcto:**
```delphi
CustomerList := TSvcCustomer.GetAll;
```

**Ejemplo incorrecto:**
```delphi
FDQuery.SQL.Text := 'SELECT * FROM clientes';
FDQuery.Open;
```

---

## 8. Recomendaciones de Arquitectura Futura

### API REST centralizada
- Frameworks: Horse, DMVCFramework o MARS.  
- Autenticación JWT y HTTPS obligatorio.  
- Documentación con Swagger/OpenAPI.

### Migración a arquitectura distribuida

```
ERP (UI) → API REST → PostgreSQL
```

**Futuro:** arquitectura hexagonal (puertos y adaptadores) y modelo SaaS multiempresa.

---

## 9. Créditos y Mantenimiento del Documento

**Responsable:** Javier Fernández Lorca – Project Manager  
**Colaboradores:** Equipo de desarrollo GevenSoft  

**Objetivo:** mantener coherencia técnica y servir de guía oficial del ERP.  
**Actualizaciones:** bajo control del Departamento de Desarrollo.  

> © 2025 GevenSoft. Todos los derechos reservados.

---

**Fin del documento**  
*Plan Técnico de Desarrollo – GevenSoft (v1.0, Noviembre 2025)*
