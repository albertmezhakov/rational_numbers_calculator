import string
import subprocess
import threading

exe_path = r"C:\Users\BerhtAdal\Desktop\RationalNumbersCalculator\output\rational_numbers_calculator.exe"

command_correct = list('-+*/')
command_incorrect = list(string.ascii_uppercase + string.ascii_lowercase + string.digits)

space_after_command = [' ' * i for i in range(1, 3)]
incorrect_space_after_command = ['']

base = [i for i in range(10, 20)]
incorrect_base = ['3244', '0', '1', 'jgg', '-', '=', 'a', 'ff']

delimiter = [':']

space_after_delimiter = [' ']
incorrect_space_after_delimiter = ['', '  ', '   ']

block = [
    (command_correct, command_incorrect,),
    (space_after_command, incorrect_space_after_command,),
    (base, incorrect_base,),
    (delimiter, list('-+0987654321abcdef)(*&^%$#'),),
    (space_after_delimiter, incorrect_space_after_delimiter,)

]
data = list()
for i in range(len(block)):
    text = ''
    for command in block[0][0 if i != 0 else 1]:
        text_2 = text + command
        for space_after_command in block[1][0 if i != 1 else 1]:
            text_3 = text_2 + space_after_command
            for base in block[2][0 if i != 2 else 1]:
                text_4 = text_3 + str(base)
                for delimiter in block[3][0 if i != 3 else 1]:
                    text_5 = text_4 + delimiter
                    for space_after_delimiter in block[4][0 if i != 4 else 1]:
                        text_6 = text_5 + space_after_delimiter
                        error = '87654324567897654ew3q24rghbnfgvjfdhsaqys3r46 cb6eynxrg6wyteyhj'
                        match i:
                            case 0:
                                if text[0] == 'f':
                                    error = ('finish_structure_error')
                                else:
                                    error = ('missing_operation', 'invalid_operation_symbol')
                            case 1:
                                error = ('missing_required_whitespace_after_operation')
                            case 2:
                                error = ('radix_out_of_range', 'invalid_radix_format')
                            case 3:
                                error = ('missing_colomn')
                            case 4:
                                error = ('missing_required_whitespace_after_colomn')
                        data.append((text_6, error, i, command, space_after_command, base, delimiter, space_after_delimiter))
k = True


def ffo(data):
    for i in data:
        process = subprocess.Popen(
            [exe_path, '10'],  # Путь к исполняемому файлу
            stdin=subprocess.PIPE,  # Включаем стандартный ввод
            stdout=subprocess.PIPE,  # Включаем стандартный вывод
            stderr=subprocess.PIPE,  # Включаем стандартный вывод ошибок
            text=True  # Используем текстовый режим
        )
        output, errors = process.communicate(input=i[0] + '\n')
        check = True
        for j in i[1]:
            if j in str(output):
                check = False
        if check:
            print(i[0])
            print(i[1])
            print(i)
            print('+++++')
            print(str(output))
            print('------------------')


thr = list()
for i in range(15):
    h = len(data) // 15
    thr.append(threading.Thread(target=ffo, args=(data[h * i:h * (i + 1)],)))
    thr[-1].start()
for i in thr:
    i.join()
    print('end')
