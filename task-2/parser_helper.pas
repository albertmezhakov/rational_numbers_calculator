(*
 * Project: RationalNumbersCalculator
 * Date: 08.11.2024
 * User: BerhtAdal
 * Email: berhtadal@gmail.com
 * Telegram: https://t.me/BerhtAdal
 *)
unit parser_helper;

interface

uses custom_types;

  function  CheckFihish(input: char;
                           var status: custom_types.status_t;
                           var finish_status: custom_types.finish_status_t
                         ): custom_types.status_t;

  function CheckHaveComment(input: char; var comment: Boolean): Boolean;

  function ConvertCharNumberToInteger(number: char): Integer;

  function CovertNumberToInteger(var input_buffer: custom_types.buffer_array_t;
                                    number_system: Word): Integer;

  function InputCommandSymbol(input: char;
                                 var command: custom_types.command_t
                               ): custom_types.status_t;

  function InputSpaceAfterCommand(input: char): custom_types.status_t;

  function InputSpaceAfterColomn(input: char): custom_types.status_t;

  function InputNumbersNumerator(input: char;
                                    var numerator_first_num: Boolean;
                                    var input_buffer: custom_types.buffer_array_t;
                                    var numerator: LongWord; var number_system: word;
                                    var pointer: Integer
                                  ): custom_types.status_t;

  function InputSignOrFirstNumbersNumerator(input: char;
                                               var sign: custom_types.sign_t;
                                               var numerator_first_num: Boolean;
                                               var input_buffer: custom_types.buffer_array_t;
                                               var numerator: LongWord;
                                               var number_system: Word;
                                               var pointer: Integer
                                             ): custom_types.status_t;

  function  InputNumbersDenominator(input: char;
                                       var input_buffer: custom_types.buffer_array_t;
                                       var denominator: LongWord;
                                       var denominator_first_num: Boolean;
                                       var number_system: Word;
                                       var pointer: Integer
                                     ): custom_types.status_t;

  function InputFirstSymbolsNumberSystems(input: char;
                                             var number_system: Word
                                           ): custom_types.status_t;

  function InputSymbolsNumberSystems(input: char;
                                        var number_system: Word
                                      ): custom_types.status_t;


implementation

uses limits_helper, sysutils;

{
 Функция для проверки корректности ввода команды "finish" и для отслеживания
 начада ввода этой команды.
 Функция анализирует символы, вводимые пользователем, чтобы убедиться,
 что они соответствуют правильной последовательности для команды "finish".
 Если последовательность нарушена, функция завершит программу с ошибкой.

 input - символ, который пользователь вводит в консоль.
 status - текущее состояние парсинга команды. Этот параметр 
            используется, чтобы понять, на каком этапе находится процесс ввода.
 finish_status - переменная, которая отражает текущий 
                  этап ввода команды "finish" (от 0 до 6).

 Функция возвращает следующий статус:
   -1 - если символ успешно обработан и процесс продолжается.
   -2 - если ввод завершен успешно и команда "finish" завершена.
   status - если команда не была введена и начался ввод команды
                                                      калькулятора( + 10: ...)
}
function CheckFihish(input: char; var status: custom_types.status_t;
                        var finish_status: custom_types.finish_status_t
                      ): custom_types.status_t;
begin
  {
    Если статус равен 0 или -1, это означает, что команда "finish" может быть введена.
    Проверяем последовательность символов на каждом этапе ввода.
  }
  if (status = 0) or (status = -1) then
  begin
    {
      Если на текущем этапе введен символ 'f' и finish_status = 0 (начальный этап),
      то команда начинается, и состояние finish_status обновляется на 1.
    }
    if (input = 'f') and (finish_status = 0) then
    begin
      finish_status := 1;  // Переход на первый этап команды "finish"
      exit(-1);  // Завершаем обработку символа на этом шаге
    end;

    {
      Если на этапе 1 введен символ 'i', переходим на следующий этап (finish_status = 2).
    }
    if (input = 'i') and (finish_status = 1) then
    begin
      finish_status := 2;  // Переход на второй этап команды
      exit(-1);  // Завершаем обработку символа на этом шаге
    end;

    {
      Если на этапе 2 введен символ 'n', переходим на следующий этап (finish_status = 3).
    }
    if (input = 'n') and (finish_status = 2) then
    begin
      finish_status := 3;  // Переход на третий этап команды
      exit(-1);  // Завершаем обработку символа на этом шаге
    end;

    {
      Если на этапе 3 введен символ 'i', переходим на следующий этап (finish_status = 4).
    }
    if (input = 'i') and (finish_status = 3) then
    begin
      finish_status := 4;  // Переход на четвертый этап команды
      exit(-1);  // Завершаем обработку символа на этом шаге
    end;

    {
      Если на этапе 4 введен символ 's', переходим на следующий этап (finish_status = 5).
    }
    if (input = 's') and (finish_status = 4) then
    begin
      finish_status := 5;  // Переход на пятый этап команды
      exit(-1);  // Завершаем обработку символа на этом шаге
    end;

    {
      Если на этапе 5 введен символ 'h', команда завершена, и мы завершаем работу калькулятора.
    }
    if (input = 'h') and (finish_status = 5) then
    begin
      finish_status := 6;  // Завершение команды "finish"
      exit(-2);  // Завершаем ввод команды и возвращаем статус завершения работы калькулятора
    end;

    {
      Если команда не была введена или начата, возвращаем статус 0.
      Это может происходить, если ввели команду калькулятора(+-*.).
    }
    if (finish_status = 0) then
    begin
      exit(0);  // Команда не была начата, вернем 0
    end else begin
      // Если последовательность команд нарушена, выводим ошибку и завершаем выполнение программы.
      WriteLn('finish_structure_error');
      Halt;
    end;
  end else
  begin
    // Если статус не равен 0 или -1 (например, команда(+-*/) уже была введена), возвращаем текущий статус.
    exit(status);
  end;
end;

{
  Функция для проверки наличия комментария в строке
  Эта функция проверяет символ на наличие начала комментария (символ '#').
  Если комментарий еще не начался, символ '#' запускает его, устанавливая флаг
                                                            'comment' в true.
  Если комментарий уже начался, функция возвращает true, чтобы подтвердить,
                                                  что находимся в комментарии.
  
  input - символ, который пользователь вводит в консоль.
  comment - флаг означающий, что комментарий уже начался
}
function CheckHaveComment(input: char; var comment: Boolean): Boolean;
begin
  {
    Если флаг comment уже установлен в true, это означает, что комментарий
    уже начался, и функция сразу возвращает true, указывая, что мы находимся 
                                                                  в комментарии.
  }
  if comment then exit(true);

  {
    Если текущий символ равен '#', это начало комментария.
    В этом случае мы устанавливаем флаг comment в true и возвращаем true, чтобы
    подтвердить, что комментарий начался.
  }
  if (input = '#') then
  begin
    comment := true;  // Начинаем комментарий
    CheckHaveComment := true;  // Возвращаем true, что комментарий начался
  end
  else
      {
        Если символ не равен '#', комментарий не начинается, и функция
        возвращает false. Это означает, что мы еще не находимся в комментарии.
      }
    CheckHaveComment := false;
end;

{
   Функция для преобразования символа, представляющего цифру в шестнадцатеричной
   системе, в целое число. Функция поддерживает символы от '0' до '9' и 
   от 'a' до 'f'.
  
   Примечания:
     - Функция автоматически приводит символ к нижнему регистру с помощью 
         функции LowerCase, что позволяет обрабатывать как заглавные,
                                                          так и строчные буквы.
}
function ConvertCharNumberToInteger(number: char): Integer;
begin
  case LowerCase(number) of
    '0': ConvertCharNumberToInteger := 0;
    '1': ConvertCharNumberToInteger := 1;
    '2': ConvertCharNumberToInteger := 2;
    '3': ConvertCharNumberToInteger := 3;
    '4': ConvertCharNumberToInteger := 4;
    '5': ConvertCharNumberToInteger := 5;
    '6': ConvertCharNumberToInteger := 6;
    '7': ConvertCharNumberToInteger := 7;
    '8': ConvertCharNumberToInteger := 8;
    '9': ConvertCharNumberToInteger := 9;
    'a': ConvertCharNumberToInteger := 10;
    'b': ConvertCharNumberToInteger := 11;
    'c': ConvertCharNumberToInteger := 12;
    'd': ConvertCharNumberToInteger := 13;
    'e': ConvertCharNumberToInteger := 14;
    'f': ConvertCharNumberToInteger := 15;
  end;
end;

{
    Функция для конвертации двух символов, кодирующих цифру в системе счисления,
    в целое число в 10 системе счиления. Функция проверяет, что число не 
    превышает указанную систему счисления.
    
    input_buffer - массив, содержащий два символа, представляющих цифры в
                    системе счисления.
    number_system - система счисления, в которой ожидается число (до 256).
}
function CovertNumberToInteger(var input_buffer: custom_types.buffer_array_t; number_system: Word): Integer;
var
  number: Integer;
begin
  // Конвертируем два символа в число. Первый символ умножается на 16, второй — просто добавляется.
  // 16 - максимально колличество значаний которое кодирует 1 символ
  number := ConvertCharNumberToInteger(input_buffer[1]) * 16 + ConvertCharNumberToInteger(input_buffer[2]);

  // Проверка, что число не больше или равно системе счисления.
  if number >= number_system then
  begin
    // Если число больше или равно системе счисления, выводится ошибка.
    WriteLn('incorrect_number (number_bigger_than_number_system)');
    Halt;  // Программа завершается с ошибкой.
  end;

  // Возвращаем конвертированное число.
  CovertNumberToInteger := number;
end;

{
    Функция для обработки ввода символа команды калькулятора. 
    Эта функция обрабатывает символ операции (+, -, *, /), присваивает
    соответствующую команду 
    и проверяет корректность ввода. Если введен неправильный символ, программа 
    завершает выполнение.
    
    input - символ, введенный пользователем, который необходимо обработать. 
            Это может быть один из символов операций:
                  '+', '-', '*', '/'.
    command - переменная типа command_t, в которой будет сохранена команда, 
              соответствующая введенному символу. Каждому символу операции 
              присваивается числовое значение:
                      '+' - 1
                      '-' - 2
                      '*' - 3
                      '/' - 4
    
    Функция возвращает:
        0 - если введен пробел (символ игнорируется).
        1 - если успешно обработан символ операции.
        В случае ошибки (например, если введена цифра или нераспознанный символ),
          выводится сообщение об ошибке и программа завершается.
}
function InputCommandSymbol(input: char; var command: custom_types.command_t): custom_types.status_t;
begin
  // Если введен пробел, то ничего не делаем и выходим с кодом 0
  if input = ' ' then exit(0);

  // Обрабатываем символы операций калькулятора и присваиваем соответствующее значение переменной command
  case input of
    '+': command := 1;  // Операция сложения
    '-': command := 2;  // Операция вычитания
    '*': command := 3;  // Операция умножения
    '/': command := 4;  // Операция деления
  else
  begin
    // Если введен символ, который является цифрой, но операция не указана, выводим ошибку
    if ('0' <= input) and (input <= '9') then
    begin
      WriteLn('missing_operation');  // Ошибка: операция не указана
      Halt;  // Программа завершится с ошибкой
    end;

    // Если символ не является допустимой операцией или цифрой, выводим сообщение об ошибке
    WriteLn('invalid_operation_symbol');  // Ошибка: недопустимый символ операции
    Halt;  // Программа завершится с ошибкой
  end;
  end;

  // Возвращаем статус 1, если символ успешно обработан
  InputCommandSymbol := 1;
end;

{
    Функция для проверки наличия пробела после ввода команды калькулятора. 
    Эта функция проверяет, был ли введен пробел сразу после символа операции.
    Если пробел отсутствует, программа выводит ошибку и завершает выполнение.
    
    input - символ, введенный пользователем после ввода операции.               
    
    Функция возвращает:
        2 - если введен пробел, что означает, что пробел после операции был найден.
        В случае ошибки (если пробела нет после операции), выводится сообщение 
              об ошибке, и программа завершается.
}
function InputSpaceAfterCommand(input: char): custom_types.status_t;
begin
  // Если введен пробел, возвращаем код 2, что означает, что пробел после операции найден.
  if input = ' ' then
  begin
    InputSpaceAfterCommand := 2;
  end
  else
  begin
    // Если пробела нет, выводим сообщение об ошибке.
    WriteLn('missing_required_whitespace_after_operation');
    Halt;  // Завершаем выполнение программы.
  end;
end;

{
    Функция для обработки первого символа, введенного для системы счисления.
    Эта функция проверяет, является ли введенный символ допустимым для
    обозначения системы счисления. Если символ является пробелом, программа
    продолжает выполнение. Если символ неверный, программа завершает 
    выполнение с ошибкой.
    
    input - символ, введенный пользователем, который должен быть первой цифрой
                                                системы счисления или пробелом.
    number_system - переменная типа Word, в которую будет записана система
                              счисления, если первый символ является корректным.
    
    Функция возвращает:
        2 - если введен пробел (символ игнорируется).
        3 - если первый символ является корректным числом, продолжает обработку.
        В случае ошибки (например, если символ не цифра или двоеточие), 
                          выводится сообщение об ошибке и программа завершится.
}
function InputFirstSymbolsNumberSystems(input: char; var number_system: Word): custom_types.status_t;
begin
  // Если введен пробел, то ничего не делаем и выходим с кодом 2
  if input = ' ' then exit(2);

  // Если введен символ ":", то выводим ошибку
  if input = ':' then
  begin
    WriteLn('missing_radix');  // Ошибка: отсутствует основание системы счисления
    Halt;  // Завершаем выполнение программы
  end;

  // Если введен нецифровой символ, выводим ошибку
  if not (('0' <= input) and (input <= '9')) then
  begin
    WriteLn('invalid_radix_format');  // Ошибка: неверный формат основания
    Halt;  // Завершаем выполнение программы
  end;

  // Если символ корректный, возвращаем код 3 и продолжаем обработку
  InputFirstSymbolsNumberSystems := 3;

  // Вызываем дополнительную функцию для обработки символов системы счисления
  InputSymbolsNumberSystems(input, number_system);
end;

{
    Функция для обработки символов, представляющих число системы счисления.
    Эта функция обновляет систему счисления (number_system) на основе введенных
    символов.Если введен неверный символ или система счисления выходит за
    допустимые пределы, программа завершит выполнение с ошибкой.
    
    input - символ, который ввел пользователь, представляющий цифру системы
                                                        счисления или двоеточие.
    number_system - переменная типа Word, которая хранит текущую систему
                         счисления. Эта переменная обновляется в процессе ввода.
    
    Функция возвращает:
        4 - если введен символ ":", что указывает на завершение ввода системы счисления.
        В случае ошибки (например, если введено недопустимое число или символ), 
                    выводится соответствующее сообщение, и программа завершится.
}
function InputSymbolsNumberSystems(input: char; var number_system: Word): custom_types.status_t;
begin
  // Если введен пробел, выводим ошибку "missing_colomn"
  if input = ' ' then
  begin
    WriteLn('missing_colomn');  // Ошибка: пропущен двоеточие
    Halt;  // Завершаем выполнение программы
  end;

  // Если введен символ ":", проверяем допустимость числа системы счисления.
  if input = ':' then
  begin
    // Если система счисления меньше 2 или больше 256, выводим ошибку "radix_out_of_range"
    if (number_system < 2) or (number_system > 256) then
    begin
      WriteLn('radix_out_of_range');  // Ошибка: основание системы счисления выходит за допустимые пределы
      Halt;  // Завершаем выполнение программы
    end;

    // Если все условия соблюдены, возвращаем статус 4, что означает завершение ввода системы счисления
    exit(4);
  end;

  // Если введен нецифровой символ, выводим ошибку "invalid_radix_format"
  if not (('0' <= input) and (input <= '9')) then
  begin
    WriteLn('invalid_radix_format');  // Ошибка: неверный формат числа
    Halt;  // Завершаем выполнение программы
  end;

  // Обновляем систему счисления на основе введенной цифры.
  number_system := number_system * 10 + StrToInt(input);

  // Если система счисления выходит за пределы 256, выводим ошибку
  if number_system > 256 then
  begin
    WriteLn('radix_out_of_range');  // Ошибка: основание системы счисления слишком велико
    Halt;  // Завершаем выполнение программы
  end;
end;

{
    Функция для проверки наличия пробела после двоеточия, который требуется 
    для корректного ввода данных. Если после двоеточия введен пробел, функция 
    возвращает статус 5, иначе завершает выполнение с ошибкой.
    
    input - символ, который ввел пользователь, который должен быть
                                                      пробелом после двоеточия.
    
    Функция возвращает:
        5 - если введен пробел после двоеточия.
        В случае ошибки (если нет пробела), программа выводит 
                         сообщение о недостающем пробеле и завершает выполнение.
}
function InputSpaceAfterColomn(input: char): custom_types.status_t;
begin
  // Проверяем, что после двоеточия введен пробел.
  if input = ' ' then
  begin
    // Если это пробел, возвращаем статус 5, который указывает на успешный ввод пробела.
    InputSpaceAfterColomn := 5;
  end
  else
  begin
    // Если вместо пробела введен другой символ, выводим ошибку "missing_required_whitespace_after_colomn" и завершаем программу.
    WriteLn('missing_required_whitespace_after_colomn');  // Ошибка: пропущен обязательный пробел после двоеточия.
    Halt;  // Завершаем выполнение программы.
  end;
end;

{
    Функция для обработки ввода чисел (числителя) в калькуляторе.
    Она проверяет корректность ввода чисел для числителя, учитывая разные
    условия и проверку на переполнение.

    input - символ, введенный пользователем, который должен быть частью числителя.
    numerator_first_num - флаг, показывающий, является ли введенное число первым числом числителя.
    input_buffer - буфер для хранения введенных символов числителя.
    numerator - переменная для хранения результата числителя.
    number_system - система счисления (например, десятичная, шестнадцатеричная и т.д.).
    pointer - указатель на текущую позицию в буфере для числителя.

    Функция возвращает:
        6 - если обработка символа была успешной, но ожидается дальнейший ввод.
        7 - если закончен ввод числителя и начинаем ввод знаменателя
        В случае ошибки программа выводит сообщения и завершает выполнение.
}
function InputNumbersNumerator(input: char; var numerator_first_num: Boolean;
                                  var input_buffer: custom_types.buffer_array_t;
                                  var numerator: LongWord; var number_system: word;
                                  var pointer: Integer): custom_types.status_t;
begin
  // Проверка на ошибку: если введен символ '/' и это первый ввод числителя, то выводится ошибка.
  if (input = '/') and numerator_first_num then
  begin
    WriteLn('missing_numerator');  // Ошибка: пропущен числитель перед знаком "/".
    Halt;  // Завершаем выполнение программы.
  end;

  // Ошибка: если перед знаком пробел, это неожиданное поведение при вводе числителя.
  if (pointer = 1) and (input = ' ') and numerator_first_num then
  begin
    WriteLn('unexpected_whitespace_after_sign');  // Ошибка: неожиданный пробел после знака.
    Halt;  // Завершаем выполнение программы.
  end;

  // Ошибка: если после первого символа в паре вводится пробел, это недопустимо.
  if (pointer = 2) and (input = ' ') then
  begin
    WriteLn('unexpected_whitespace_in_number(numerator)');  // Ошибка: неожиданный пробел в паре символов
    Halt;  // Завершаем выполнение программы.
  end;

  // Если после пары символом введен пробел, ожидаем продолжение ввода.
  if (pointer = 1) and (input = ' ') then
  begin
    exit(6);  // Ожидаем продолжение ввода.
  end;

  // Если введен символ '/', и числитель уже введен, начинаем ввод знаменателя.
  if (input = '/') and not numerator_first_num then
  begin
    exit(7);  // Ожидаем ввод знаменателя.
  end;

  // Теперь числитель больше не является первым числом, продолжаем обработку.
  numerator_first_num := false;

  // Проверка, что введенный символ является цифрой или символом в диапазоне 'a'..'f'
  if ((('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f'))) and (pointer < 3) then
  begin
    input_buffer[pointer] := input;  // Сохраняем введенный символ в буфер.
    pointer := pointer + 1;  // Увеличиваем указатель на следующую позицию в буфере.
  end;

  // Когда буфер заполнился (2 символа), проверяем, что полученное число не превышает ограничений LongInt.
  if (pointer = 3) then
  begin
    if not IsWithinLongIntLimits(numerator, number_system, CovertNumberToInteger(input_buffer, number_system)) then
    begin
      WriteLn('limit_longint');  // Ошибка: переполнение лимита LongInt.
      Halt;  // Завершаем выполнение программы.
    end;

    // Преобразуем введенные символы в число и добавляем его к числителю.
    numerator := numerator * number_system + CovertNumberToInteger(input_buffer, number_system);
    pointer := 1;  // Сбрасываем указатель для следующего числа.
  end;

  // Возвращаем статус 6, что означает, что обработка символа завершена и ожидается дальнейший ввод.
  InputNumbersNumerator := 6;
end;

{
    Функция для обработки ввода знака или первого числа числителя.
    Она проверяет корректность символа, который ввел пользователь, и в 
    зависимости от этого выполняет дальнейшую обработку.

    input - символ, который был введен пользователем.
    sign - переменная, в которой сохраняется знак числителя: 0 для "+" и 1 для "-".
    numerator_first_num - флаг, который указывает, является ли ввод первым числом числителя.
    input_buffer - буфер для хранения введенных символов числителя.
    numerator - переменная, в которой хранится числитель.
    number_system - система счисления (например, десятичная или шестнадцатеричная).
    pointer - указатель на текущую позицию в буфере числителя.

    Функция возвращает:
        6 - успешная обработка символа, продолжение ввода числителя.
}
function InputSignOrFirstNumbersNumerator(input: char;
                                             var sign: custom_types.sign_t;
                                             var numerator_first_num: Boolean;
                                             var input_buffer: custom_types.buffer_array_t;
                                             var numerator: LongWord;
                                             var number_system: Word;
                                             var pointer: Integer): custom_types.status_t;
begin
  // Проверка на недопустимый символ (кроме цифр, букв 'a'..'f', знаков '+' и '-').
  if not ((('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f')) or (input = '+') or (input = '-')) then
  begin
    // Если введен пробел, выводим ошибку о том, что после двоеточия не может быть более одного пробела.
    if input = ' ' then
    begin
      WriteLn('max_one_whitespace_after_colon');  // Ошибка: только один пробел после двоеточия.
      Halt;  // Завершаем выполнение программы.
    end;
    // Если введен символ '/', выводим ошибку о пропущенном числителе.
    if input = '/' then
    begin
      WriteLn('missing_numerator');  // Ошибка: пропущен числитель.
      Halt;  // Завершаем выполнение программы.
    end;
    // Если введен недопустимый символ, выводим ошибку.
    WriteLn('invalid_sign_or_numerator_symbol');  // Ошибка: недопустимый символ для знака или числителя.
    Halt;  // Завершаем выполнение программы.
  end;

  // Обработка знаков '+' и '-', присваиваем значение в переменную sign.
  case input of
    '+': sign := 0;  // Знак "+" сохраняется как 0.
    '-': sign := 1;  // Знак "-" сохраняется как 1.
  else sign := 0;  // Если знак не "+" и не "-", по умолчанию стоит знак "+"
  end;

  // Если введен символ цифры или буквы в пределах '0'..'9' или 'a'..'f',
  // вызываем функцию для обработки числителя.
  if (('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f')) then
  begin
    // Вызываем функцию для обработки ввода числителя.
    InputNumbersNumerator(input, numerator_first_num, input_buffer, numerator, number_system, pointer);
    // Возвращаем статус 6, что означает успешную обработку и продолжение ввода числителя.
    InputSignOrFirstNumbersNumerator := 6;
  end
  else begin
    // Если это знак, возвращаем статус 6 для начала ввода числителя.
    InputSignOrFirstNumbersNumerator := 6;
  end;
end;

{
    Функция для обработки ввода чисел знаменателя. Эта функция обрабатывает ввод
    символов для числителя в зависимости от состояния указателя и текущего 
    символа. Если введены числа, они конвертируются и добавляются к знаменателю.

    input - символ, который был введен пользователем.
    input_buffer - буфер для хранения введенных символов знаменателя.
    denominator - переменная для хранения числителя знаменателя.
    denominator_first_num - флаг, который указывает, является ли ввод первым числом знаменателя.
    number_system - система счисления, в которой вводится число.
    pointer - указатель на текущую позицию в буфере знаменателя.

    Функция возвращает:
        7 - успешная обработка символа и продолжение ввода.
}
function InputNumbersDenominator(input: char;
                                    var input_buffer: custom_types.buffer_array_t;
                                    var denominator: LongWord;
                                    var denominator_first_num: Boolean;
                                    var number_system: Word;
                                    var pointer: Integer): custom_types.status_t;
begin
  // Если указатель на вторую позицию и введен пробел, выводим ошибку.
  if (pointer = 2) and (input = ' ') then
  begin
    WriteLn('unexpected_whitespace_in_number(denominator)');  // Ошибка: неожиданный пробел в числе знаменателя.
    Halt;  // Завершаем выполнение программы.
  end;

  // Если указатель на первую позицию и введен пробел, ожидаем ввод символа.
  if (pointer = 1) and (input = ' ') then
  begin
    exit(7);  // Успешно завершаем, ожидаем ввод символа.
  end;

  // Если введен допустимый символ (цифра или буква a..f) и указатель меньше 3,
  // сохраняем символ в буфер и увеличиваем указатель.
  if ((('0' <= input) and (input <= '9')) or (('a' <= input) and (input <= 'f'))) and (pointer < 3) then
  begin
    input_buffer[pointer] := input;  // Сохраняем символ в буфер.
    pointer := pointer + 1;  // Увеличиваем указатель.
  end;

  // Если указатель равен 3, это означает, что введено два символа.
  if (pointer = 3) then
  begin
    // Проверка, чтобы число не выходило за пределы LongWord.
    if not IsWithinLongWordLimits(denominator, number_system, CovertNumberToInteger(input_buffer, number_system)) then
    begin
      WriteLn('limit_longword');  // Ошибка: число выходит за пределы LongWord.
      Halt;  // Завершаем выполнение программы.
    end;

    // Если это первое число знаменателя, инициализируем его значением 0.
    if denominator_first_num then
      denominator := 0;  // Устанавливаем знаменатель в 0.

    // Сбрасываем флаг первого числа.
    denominator_first_num := false;

    // Преобразуем введенные символы в число и добавляем его к знаменателю.
    denominator := denominator * number_system + CovertNumberToInteger(input_buffer, number_system);
    pointer := 1;  // Сбрасываем указатель для следующего ввода.
  end;

  // Возвращаем статус 7, который указывает на успешную обработку.
  InputNumbersDenominator := 7;
end;


end.