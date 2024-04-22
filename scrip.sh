#!/bin/bash


if [ "$#" -ne 2 ]; then
    echo "Использование: $0 <входная директория> <выходная директория>"
    exit 1
fi

input_dir=$1
output_dir=$2

if [ ! -d "$input_dir" ]; then
    echo "Ошибка: Директория '$input_dir' не найдена."
    exit 1
fi

if [ ! -d "$output_dir" ]; then
    mkdir -p "$output_dir"
fi

copy_unique() {
    local src=$1
    local dest=$2
    local filename=$(basename "$src")
    local counter=1
    local file_ext="${filename##*.}"
    local file_base="${filename%.*}"

    while [ -e "$dest/$filename" ]; do
        filename="${file_base}_$counter.$file_ext"
        let counter+=1
    done

    cp "$src" "$dest/$filename"
}

find "$input_dir" -type f | while read -r file; do
    copy_unique "$file" "$output_dir"
done

echo "Файлы были скопированы в '$output_dir'"
