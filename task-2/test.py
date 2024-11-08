import random
import subprocess
import time

from tqdm import tqdm

exe_path = r"C:\Users\BerhtAdal\Desktop\RationalNumbersCalculator\output\TestReaderCommands.exe"


def get_command_type(correct=True):
    return random.choice(['+', '-', '*', '/'] if correct else list('''ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!"#$%&'(),.:;<=>?@[\]^_`{|}~'''))


def get_sign(correct=True):
    return random.choice(['+', '-', ''] if correct else list('''ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!"#$%&'(),.:;<=>?@[\]^_`{|}~'''))


error_type = {
    'incorrect_command_type': 'Некоректный знак действия. Допустимы только +, -, *, /.',
    'space_after_command_not_found': 'Ошибка структуры 1634453',
    'incorrect_symbol_in_system_numbers_first': 'Ввели недопустимый символ 8765765',
    'not_found_system_numbers': 'Вы не ввели систему счисления',
    'incorrect_symbol_in_system_numbers_after_first': 'Ввели недопустимый символ 465343566453',
    'incorrect_system_numbers_with_out_range_1': 'Система счисление не может быть больше 256 и меньше 2',
    'incorrect_system_numbers_with_out_range_2': 'Система счиление не может быть больше 256',
    'after_delimiter_system_numbers_not_found_space': 'Ошибка структуры 869748532135672',
    'before_sign_have_found_one_space': 'Должен быть 1 пробел 56342363564365435',
    'before_sign_have_found_incorrect_symbols': 'Ввели недопустимый символ 74564545433645',
    'before_denominator_have_one_numbers': 'Ошибка невведено не одного числа перед дробной частью',
    'after_sign_not_have_space': 'Ошибка после знака нельзя ноль',
    'space_between_numbers_incorrect': 'Пробел между цифрами, некоректный',
    'denominator_space_between_numbers_incorrect': 'Пробел между цифрами, некоректный 435434',
    'space_between_numbers': 'Кол-во цифр нечетно. Ошибка.',
    '???':'???'
}
test = []

for correct_1 in (True, False):
    for correct_2 in range(1, 10):
        for correct_3 in range(2, 300):
            for correct_4 in (True, False):
                for correct_5 in range(0, 10):
                    for correct_6 in (True, False):
                        for correct_7 in range(0, 10):
                            text_3 = get_command_type(correct_1) + (' ' * correct_2) + ('' if -1 == 2 else str(correct_3)) + (':' if correct_4 else '') + (' ' * correct_5) + get_sign(correct_6) + (' ' * correct_7) + '00556677'
                            if not correct_1:
                                test.append((text_3, 'incorrect_command_type'))
                            elif not correct_4:
                                test.append((text_3, '???'))
                            elif correct_5 == 0:
                                test.append((text_3, 'after_delimiter_system_numbers_not_found_space'))
                            elif correct_5 > 1:
                                test.append((text_3, 'before_sign_have_found_one_space'))
                            elif not correct_6:
                                test.append((text_3, 'before_sign_have_found_incorrect_symbols'))
                            elif correct_7 != 0:
                                test.append((text_3, 'after_sign_not_have_space'))
for i in tqdm(test):
    process = subprocess.Popen(
        exe_path,  # Путь к исполняемому файлу
        stdin=subprocess.PIPE,  # Включаем стандартный ввод
        stdout=subprocess.PIPE,  # Включаем стандартный вывод
        stderr=subprocess.PIPE,  # Включаем стандартный вывод ошибок
        text=True  # Используем текстовый режим
    )
    output, errors = process.communicate(input=i[0]+'\n')
    if str(output).strip() != error_type[i[1]]:
        print(i[0])
        print(i[1])
        print(str(output).strip())
        print('----------')