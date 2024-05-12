#!/bin/bash


# Verificar si yt-dlp está instalado
if ! command -v yt-dlp &> /dev/null; then
    echo "yt-dlp no está instalado. Instalando..."
    sudo apt install -y yt-dlp
fi

# Verificar si ffmpeg está instalado
if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg no está instalado. Instalando..."
    sudo apt install -y ffmpeg
fi


# Pedir al usuario la URL de YouTube
read -p "Introduce la URL de YouTube: " youtube_url

# Pedir al usuario el nombre para el vídeo
read -p "Introduce el nombre para ponerle al vídeo: " video_file


# Mostrar formatos disponibles ofrecidos por yt-dlp
echo "Formatos disponibles para la descarga:"
yt-dlp -F "$youtube_url"

# Pedir al usuario el formato deseado
read -p "Selecciona el formato deseado (código del formato): " format_code

# Descargar el video
echo "Descargando el video..."
yt-dlp -f "$format_code" -o "$video_file.$format_code" "$youtube_url"



# Extraer información del audio y video
echo "Códec del audio: $(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$video_file.$format_code")"


echo "Códec del video: $(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$video_file.$format_code")"


# Extraer el audio en formato mp3
echo "Extrayendo el audio en formato mp3..."
ffmpeg -i "$video_file.$format_code" -vn -acodec mp3 "${video_file}_audio.mp3"

# Extraer el video sin audio
echo "Extrayendo el video sin audio..."
ffmpeg -i "$video_file.$format_code" -an "${video_file}_noAudio.$format_code"


echo "Proceso completado."