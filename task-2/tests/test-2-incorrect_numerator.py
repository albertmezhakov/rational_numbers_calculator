exe_path = r"C:\Users\BerhtAdal\Desktop\RationalNumbersCalculator\output\rational_numbers_calculator.exe"

command_correct = list('-+*/')

space_after_command = [' ' * i for i in range(1, 3)]

base = [i for i in range(2, 257)]

delimiter = [':']

space_after_delimiter = [' ']

block = [
    command_correct,
    space_after_command,
    base,
    delimiter,
    space_after_delimiter

]
data = list()
for command in block[0]:
    text_2 = command
    for space_after_command in block[1]:
        text_3 = text_2 + space_after_command
        for base in block[2]:
            text_4 = text_3 + str(base)
            for delimiter in block[3]:
                text_5 = text_4 + delimiter
                for space_after_delimiter in block[4]:
                    text_6 = text_5 + space_after_delimiter
                    data.append((text_6, command, space_after_command, base, delimiter, space_after_delimiter))


# k = True
#
#
# def ffo(data):
#     for i in data:
#         process = subprocess.Popen(
#             [exe_path, '10'],  # Путь к исполняемому файлу
#             stdin=subprocess.PIPE,  # Включаем стандартный ввод
#             stdout=subprocess.PIPE,  # Включаем стандартный вывод
#             stderr=subprocess.PIPE,  # Включаем стандартный вывод ошибок
#             text=True  # Используем текстовый режим
#         )
#         output, errors = process.communicate(input=i[0] + '\n')
#         check = True
#         for j in i[1]:
#             if j in str(output):
#                 check = False
#         if check:
#             print(i[0])
#             print(i[1])
#             print(i)
#             print('+++++')
#             print(str(output))
#             print('------------------')
#
#
# thr = list()
# for i in range(15):
#     h = len(data) // 15
#     thr.append(threading.Thread(target=ffo, args=(data[h * i:h * (i + 1)],)))
#     thr[-1].start()
# for i in thr:
#     i.join()
#     print('end')
