# ============================================ 
# Evaluación de fidelidad morfométrica
# Autora: Agustina Muñoz
# ============================================

# 1. Paquetes necesarios
library(readr)
library(dplyr)
library(ggplot2)
library(psych)
library(pastecs)
library(tidyverse)
library(broom)

# 2. Cargar los datos
datos <- read.table("datos.txt", header = TRUE, sep = "\t")

# 3. Exploración inicial
head(datos)
summary(datos)
str(datos)

# ==================================================
# ESTADÍSTICA DESCRIPTIVA
# ==================================================

# Estadísticos generales
desc_completo <- stat.desc(datos[, c("Analogico","Digital","Resta","Dif_rel","Dif_rel_porc")], norm = TRUE)
print(round(desc_completo, 3))

# Resumen por unidad ósea
resumen_univariado <- datos %>%
  group_by(Unidad) %>%
  summarise(
    media_analog = mean(Analogico, na.rm=TRUE),
    sd_analog    = sd(Analogico, na.rm=TRUE),
    media_digital= mean(Digital, na.rm=TRUE),
    sd_digital   = sd(Digital, na.rm=TRUE),
    media_dif    = mean(Digital - Analogico, na.rm=TRUE),
    sd_dif       = sd(Digital - Analogico, na.rm=TRUE),
    .groups = "drop"
  )
print(resumen_univariado)

# ==================================================
# ANÁLISIS UNIVARIADO Y BOXPLOTS
# ==================================================

# Histograma de la diferencia relativa porcentual
ggplot(datos, aes(x = Dif_rel_porc)) +
  geom_histogram(fill = "lightblue", color = "black", bins = 30) +
  theme_minimal() +
  labs(title = "Distribución de la diferencia relativa porcentual (Digital vs Analógico)",
       x = "Diferencia relativa porcentual (%)",
       y = "Frecuencia")

# Boxplot general por unidad
ggplot(datos, aes(x = Unidad, y = Digital - Analogico, fill = Unidad)) +
  geom_boxplot(alpha = 0.7) +
  theme_minimal() +
  labs(title = "Diferencias (Digital - Analógico) por unidad ósea",
       x = "Unidad ósea", y = "Diferencia (mm)")

# Boxplot por variable (Se puede cambiar la Unidad "")
ggplot(datos %>% filter(Unidad == "Femur"),
       aes(x = Medida, y = Digital - Analogico, fill = Medida)) +
  geom_boxplot(alpha = 0.8) +
  theme_minimal() +
  coord_flip() +
  labs(title = "Diferencias (Digital - Analógico) por variable del fémur",
       x = "Variable femoral", y = "Diferencia (mm)")

# ==================================================
# ANÁLISIS DE FIDELIDAD ESTADÍSTICO Wilcoxon y t pareada
# ==================================================

# --- Prueba t pareada ---
t_pareado_global <- t.test(datos$Digital, datos$Analogico, paired = TRUE)
print(t_pareado_global)

# --- Prueba de Wilcoxon pareada ---
wilcox_pareado_global <- wilcox.test(datos$Digital, datos$Analogico, paired = TRUE)
print(wilcox_pareado_global)

# --- Tabla resumen global ---
resumen_global <- data.frame(
  Media_Analogico = mean(datos$Analogico, na.rm = TRUE),
  SD_Analogico = sd(datos$Analogico, na.rm = TRUE),
  Media_Digital = mean(datos$Digital, na.rm = TRUE),
  SD_Digital = sd(datos$Digital, na.rm = TRUE),
  Media_Diferencia = mean(datos$Digital - datos$Analogico, na.rm = TRUE),
  SD_Diferencia = sd(datos$Digital - datos$Analogico, na.rm = TRUE),
  t_pvalor = t_pareado_global$p.value,
  wilcox_pvalor = wilcox_pareado_global$p.value
)
print(resumen_global)

# ==================================================
# CORRELACIÓN ENTRE MÉTODOS
# ==================================================

# Correlación general
correlacion_total <- cor.test(datos$Analogico, datos$Digital)
print(correlacion_total)

# Gráfico de dispersión (correlación)
ggplot(datos, aes(x = Analogico, y = Digital)) +
  geom_point(color = "darkgreen", alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  theme_minimal() +
  labs(title = "Correlación entre mediciones analógicas y digitales",
       x = "Medición analógica (mm)", y = "Medición digital (mm)") +
  annotate("text", x = min(datos$Analogico), y = max(datos$Digital),
           label = paste("r =", round(correlacion_total$estimate, 3)),
           hjust = 0, vjust = 1, size = 5)

# ==================================================
# GRÁFICO DE BLAND-ALTMAN
# ==================================================

# Cálculo de media y límites de acuerdo
media_dif_porc <- mean(datos$Dif_rel_porc, na.rm = TRUE)
sd_dif_porc <- sd(datos$Dif_rel_porc, na.rm = TRUE)
limite_sup_porc <- media_dif_porc + 1.96 * sd_dif_porc
limite_inf_porc <- media_dif_porc - 1.96 * sd_dif_porc

cat("Media de diferencia (%) =", round(media_dif_porc, 2), "\n")
cat("Límite inferior (%) =", round(limite_inf_porc, 2), "\n")
cat("Límite superior (%) =", round(limite_sup_porc, 2), "\n")

# Gráfico Bland–Altman
ggplot(datos, aes(x = (Analogico + Digital) / 2, y = Dif_rel_porc)) +
  geom_point(color = "steelblue", alpha = 0.65, size = 2) +
  
  # Líneas 
  geom_hline(yintercept = media_dif_porc, color = "red", linetype = "dashed", linewidth = 0.8) +
  geom_hline(yintercept = limite_sup_porc, color = "gray50", linetype = "dotted", linewidth = 0.7) +
  geom_hline(yintercept = limite_inf_porc, color = "gray50", linetype = "dotted", linewidth = 0.7) +
  
  # Anotaciones 
  annotate("text", x = max((datos$Analogico + datos$Digital) / 2) * 0.95,
           y = media_dif_porc, label = paste("Media =", round(media_dif_porc, 2), "%"),
           color = "gray30", size = 3, hjust = 1, vjust = -0.8) +
  annotate("text", x = max((datos$Analogico + datos$Digital) / 2) * 0.95,
           y = limite_sup_porc, label = paste("Límite sup. =", round(limite_sup_porc, 2), "%"),
           color = "gray40", size = 3, hjust = 1, vjust = -0.8) +
  annotate("text", x = max((datos$Analogico + datos$Digital) / 2) * 0.95,
           y = limite_inf_porc, label = paste("Límite inf. =", round(limite_inf_porc, 2), "%"),
           color = "gray40", size = 3, hjust = 1, vjust = 1.2) +
  
  theme_minimal(base_size = 12) +
  labs(
    title = "Bland–Altman: Evaluación de la concordancia entre técnicas",
    x = "Media entre ambos métodos (mm)",
    y = "Diferencia relativa (%)"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 13),
    axis.title = element_text(size = 11),
    panel.grid.minor = element_blank()
  )


