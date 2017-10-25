# Documentación EMOTRIX

El proyecto Emotrix es una plataforma que permitirá el estudio, identificación y manipulación de emociones humanas. La plataforma se podrá utilizar para fines educativos, médicos o recreacionales, entre otros. A la fecha, existen distintos dispositivos que permiten imitar inteligencia emocional, los cuales tienen precios elevados. Es por esto por lo que la plataforma tiene un enfoque de código libre para permitir el desarrollo de forma abierta y evitar cualquier tipo de restricciones a los usuarios. El ámbito al que pertenece el proyecto es a la interacción humano – computador (HCI).

**IMPORTANTE** todo lo desarrollado por EMOTRIX Fase II se encuentra dentro de los directorios: 
> /emotrix/2017/... 

> /R/... 

Lo demas fue desarrollado por EMOTRIX Fase I.
## Requisitos Previos
1. Python 2.7
2. pip
3. R
4. RStudio

## Instalación
```
pip install requirements.txt
```

## Ejecutar el SDK
```
python main.py
```
## API

### 

## Codigo Fuente Para Estados de Relajacion

### Regresion Logistica

### Maquinas de Soporte Vectorial (SVM)

### K-Medias

### Redes Neuronales

## Codigo Fuente Para Estados Emocionales
Todo el codigo fuente para esta seccion se encuentra dentro del directorio:
> /R/Emotions-Scripts/...
### Obtencion de Emociones Seleccionadas
Nombre del archivo: *SelectedEmotions.R*

Programa que lee cada uno de los archivos generados por el API, luego de la experimentacion, y genera un archivo por cada uno de los archivos anteriores, con la emocion seleccionada por segundo para cada estimulo.
### Generacion de Graficas
Nombre del archivo: *Graphics.R*

Programa que lee cada uno de los archivos generados por el API, luego de la experimentacion, y genera un graficas de las lecturas de cada electrodo del emotiv y de las onda presente en cada segundo de experimentacion.

### Obtencion de Datos de Entrenamiento y Validacion Cruzada
Nombre del archivo: *SetTrainingData.R*

Programa que lee cada uno de los archivos generados por el API, luego de la experimentacion, y genera un un archivo con los datos separados para el entrenamiento y validacion de lso algoritmos.

### Regresion Logistica
Nombre del archivo: *lr.R*

Programa que lee los archivos generados mediante el programa *SetTrainingData.R*, entrana el algoritmo de regresion logistica, hace la validacion cruzada y devuelve el porcentaje de eficiencia.
### Maquinas de Soporte Vectorial (SVM)
Nombre del archivo: *SVM.R*

Programa que lee los archivos generados mediante el programa *SetTrainingData.R*, entrana el algoritmo de maquinas de soporte vectorial (SVM), hace la validacion cruzada y devuelve el porcentaje de eficiencia.
### K-Medias
Nombre del archivo: *k-means.R*

Programa que lee los archivos generados mediante el programa *SetTrainingData.R*, utiliza el algoritmo de k-medias para la generacion de clusteres para la prediccion de los estados emocionales. Retorna la eficiencia del algoritmo.
### Redes Neuronales
Nombre del archivo: *Neural-Networks.R*

Programa que lee los archivos generados mediante el programa *SetTrainingData.R*, utiliza el algoritmo de redes neuronales para la prediccion de los estados emocionales. Retorna el porcentaje de eficiencia.
## Recomendaciones
- Utilizar un sistema operativo basado en linux
- Utilizar Visual Studio Code

## Autores
- Angel Morales
- Cesar Ruiz
- Diego Jacobs
- Henzer Garcia
- Kevin Garcia
- Mario Barrientos
- Sergio Gomez
