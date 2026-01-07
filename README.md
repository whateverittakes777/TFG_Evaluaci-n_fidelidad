# 🦴 Consistencia analógica vs. digital: validación de la hipótesis

**Autora:** Agustina Muñoz  
**Carrera:** Licenciatura en Criminología y Ciencias Forenses  
**Universidad:** Universidad Nacional de Río Negro (UNRN)  
**Año:** 2025  

---

## 📘 Descripción del análisis

Este script forma parte del proyecto de investigación **“Morfometría tradicional y fotogrametría de corto alcance: validación metodológica para el análisis osteométrico en restos óseos humanos de Norpatagonia”**, correspondiente al **Trabajo Final de Grado** de la autora.  

El presente análisis tiene como objetivo **evaluar la fidelidad entre mediciones morfométricas tradicionales (analógicas)** y aquellas **obtenidas de forma digital a partir de modelos tridimensionales**, a fin de determinar la correspondencia entre métodos y validar la reproducibilidad del registro digital en estudios osteométricos.

---

## 🧠 Metodología implementada

El script ejecuta un flujo estadístico reproducible en R, compuesto por las siguientes etapas principales:

1. **Carga y exploración de datos**
   - Lectura de un archivo tabulado `datos.txt` con columnas como `Analogico`, `Digital`, `Unidad`, `Dif_rel`, `Dif_rel_porc`.  
   - Exploración inicial de estructura, tipo de variables y valores.

2. **Estadística descriptiva**
   - Cálculo de medidas de tendencia central y dispersión para ambos métodos.  
   - Comparación de medias y desviaciones estándar por unidad ósea.  
   - Cálculo de la diferencia relativa (%) entre ambos métodos.

3. **Visualización de resultados**
   - Histogramas de distribución de la diferencia relativa.  
   - Boxplots comparativos (globales y por unidad ósea).  
   - Gráficos de dispersión y correlación entre métodos.

4. **Pruebas estadísticas de fidelidad**
   - **t de Student pareada** y **Wilcoxon pareada**, según supuestos de normalidad.  
   - Resumen tabular de resultados globales (medias, SD, valores p).

5. **Correlación y concordancia**
   - Correlación de Pearson entre mediciones digitales y analógicas.  
   - Gráfico de regresión lineal con coeficiente de correlación.  
   - **Análisis de Bland–Altman** para evaluar límites de acuerdo y sesgo sistemático.

---

## 📊 Resultados esperados

Los resultados del análisis permiten:

- Identificar la magnitud y dirección de las diferencias entre ambos métodos.  
- Evaluar si las discrepancias son aleatorias o sistemáticas.  
- Determinar la equivalencia práctica de las mediciones digitales respecto a las tradicionales.  
- Visualizar gráficamente la distribución y concordancia entre métodos.

---

## ⚙️ Requisitos de ejecución

Para reproducir este análisis, es necesario tener instalado **R (≥ 4.2)** y los siguientes paquetes:

```r
install.packages(c(
  "readr", "dplyr", "ggplot2", "psych", "pastecs", "tidyverse", "broom"
))
