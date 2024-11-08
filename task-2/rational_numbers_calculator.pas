(*
 * Project: RationalNumbersCalculator
 * Date: 27.10.2024
 * User: BerhtAdal
 * Email: berhtadal@gmail.com
 * Telegram: https://t.me/BerhtAdal
 *)
program rational_numbers_calculator;
uses execute_helper, custom_types, parser_helper, arguments_helper, output_helper;

var
  input: char;  // Переменная для хранения текущего символа, введенного пользователем
  input_buffer: custom_types.buffer_array_t;  // Буфер для хранения введенных символов
  command: custom_types.command_t;  // Команда
  sign: custom_types.sign_t;  // Знак чисел (например, + или -)
  status: custom_types.status_t;  // Текущий статус выполнения программы
  finish_status: custom_types.finish_status_t;  // Статус завершения программы
  number_system: Word;  // Система счисления (например, 16 для шестнадцатиричной)
  pointer: Integer;  // Указатель на текущую позицию в буфере
  numerator_first_num, denominator_first_num, comment: Boolean;  // Флаги, помечающие различные состояния
  numerator: longint;  // Числитель
  denominator, numerator_temp, denominator_temp: longword;  // Знаменатель и временные переменные для числителя и знаменателя
  number_system_array: custom_types.number_system_t;  // Массив с система счисления
  i: Integer;



begin
  // Инициализация начальных значений
  status := 0;
  command := 0;
  finish_status := 0;
  sign := 0;

  number_system := 0;
  pointer := 1;

  numerator_first_num := true;  // Флаг для отслеживания первого числа числителя
  denominator_first_num := true;  // Флаг для отслеживания первого числа знаменателя

  numerator := 0;  // Начальный числитель
  denominator := 1;  // Начальный знаменатель (не может быть 0)
  numerator_temp := 0;  // Переменная куда записываеться числителя введен с консоли
  denominator_temp := 1;  // Переменная куда записываеться знаментаель введен с консоли

  comment := false;  // Флаг для определения, находится ли программа в состоянии комментария

  number_system_array := GetNumberSystems();


  WriteLn('=========================================');

  while true do
  begin
    Read(input);  // Чтение ввода от пользователя (один символ за раз)
    // Обработка команды и обновление статуса
    status := ExecuteCommand(input, numerator_first_num, denominator_first_num, sign, comment,
                              number_system, pointer, status, command,
                              numerator_temp, numerator, denominator_temp,
                              denominator);

    // Проверка, если текущий символ является частью комментария, пропускаем его
    if CheckHaveComment(input, comment) and (status <> -3) then continue;

    // Проверка на завершение программы
    status := CheckFihish(input, status, finish_status);


    // В зависимости от текущего статуса, вызываем соответствующие функции
    case status of
      -3: status := 0;  // Статус -3: сброс состояния
      -2: break;  // Статус -2: завершение программы
      -1: continue;  // Статус -1: продолжение обработки (пропустить текущий символ)
        // Основные этапы обработки ввода:
      0: status := InputCommandSymbol(input, command);  // Обработка символа команды (например, +, -, *, /)
      1: status := InputSpaceAfterCommand(input);  // Ожидание пробела после команды
      2: status := InputFirstSymbolsNumberSystems(input, number_system);  // Обработка первого символа системы счисления
      3: status := InputSymbolsNumberSystems(input, number_system);  // Обработка символов системы счисления
      4: status := InputSpaceAfterColomn(input);  // Ожидание пробела после двоеточия
      5: status := InputSignOrFirstNumbersNumerator(input, sign, numerator_first_num, input_buffer, numerator_temp, number_system, pointer);  // Ввод знака или чисел числителя
      6: status := InputNumbersNumerator(input, numerator_first_num, input_buffer, numerator_temp, number_system, pointer);  // Ввод чисел числителя
      7: status := InputNumbersDenominator(input, input_buffer, denominator_temp, denominator_first_num, number_system, pointer);  // Ввод чисел знаменателя
    end;
  end;
  WriteLn('=========================================');
  WriteLn(numerator);
  WriteLn(denominator);
  for i:=1 to MAX_NUMBER_SYSTEM do
  begin
    if number_system_array[i] = -1 then continue;
    WriteNumeratorDenominatorToBase(numerator, denominator, number_system_array[i]);
  end;

end.
