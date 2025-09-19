from tensorflow.keras.preprocessing.image import ImageDataGenerator           #Aumentar datos y crear nuevas variaciones de datos existentes
import numpy as np
import tensorflow as tf         #Importa TensorFlow construir y entrenar modelos de aprendizaje profundo.
import tensorflow_hub as hub    #Modelos preentrenados

# print(tf.__version__)

datagen=ImageDataGenerator(
    rescale=1./255,           # Reescala los valores de píxeles a un rango de 0 a 1
    rotation_range=10,        # Rango de rotación en grados
    width_shift_range=0.15,   # Rango de cambio horizontal en fracción de la dimensión total
    height_shift_range=0.15,  # Rango de cambio vertical en fracción de la dimensión total
    shear_range=5,            # Rango de cambio de cizallamiento (shear)
    zoom_range=[0.7,1.3],     # Rango de zoom
    validation_split=0.2      # Fracción de datos a reservar para validación
)

data_gen_entrenamiento=datagen.flow_from_directory("./content/DATOSENT/",
    target_size=(224,224),
    batch_size=32,
    shuffle=True, #Baraja el conjunto de datos
    subset="training")

data_gen_pruebas=datagen.flow_from_directory("./content/PRUEBAS/",
    target_size=(224,224),
    batch_size=32,
    shuffle=False, #Baraja el conjunto de datos
    subset="validation")

url="https://tfhub.dev/google/tf2-preview/mobilenet_v2/feature_vector/4"
mobilenetv2=hub.KerasLayer(url,input_shape=(224,224,3))

#Importante
#Congelar las capas
mobilenetv2.trainable = False

modelo = tf.keras.Sequential([
    mobilenetv2,
    tf.keras.layers.Dense(4, activation="softmax")
])

modelo.compile(
    optimizer="adam",
    loss="categorical_crossentropy",
    metrics=["accuracy"]
)

EPOCAS = 20
entrenamiento = modelo.fit(
    data_gen_entrenamiento, epochs=EPOCAS, batch_size=32,
    validation_data=data_gen_pruebas
)