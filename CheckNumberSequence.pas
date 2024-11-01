var
  ch: char;          // текущий символ
  isMatch: boolean;  // флаг для проверки совпадения с последовательностью
  expectedDigit: char; // следующая ожидаемая цифра в последовательности
  firstChar: boolean;  // флаг для первой цифры текста

// Функция для проверки, является ли символ цифрой
function IsDigit(c: char): boolean;
begin
  IsDigit := (c >= '0') and (c <= '9');
end;

begin
  writeln('Введите текст (только цифры и большие латинские буквы), заканчивающийся точкой:');
  
  isMatch := true;
  firstChar := true;

  while True do begin
    read(ch); // читаем очередной символ

    if ch = '.' then
      break; // выходим из цикла при встрече точки
      
    if (ord(ch) = 10) or (ord(ch) = 13) then begin
       writeln('Ошибка отсутвует точка.');
       exit();
    end;
    // Проверяем на недопустимые символы
    if not IsDigit(ch) then
    begin
      writeln('Введенный текст НЕ совпадает с частью последовательности 0123456789.');
      exit();
    end;

    // Определение начальной цифры последовательности
    if firstChar then
    begin
      expectedDigit := ch;
      firstChar := false;
    end
    else
    begin
      // Проверяем, что текущий символ соответствует ожидаемой цифре
      if ch <> expectedDigit then
      begin
        isMatch := false;
        break;
      end;
    end;

    // Определяем следующую ожидаемую цифру в последовательности 0123456789
    if expectedDigit = '9' then
      expectedDigit := '0'
    else
      expectedDigit := chr(ord(expectedDigit) + 1);

  end; // продолжаем, пока не введена точка

  if isMatch then
    writeln('Введенный текст совпадает с частью последовательности 0123456789.')
  else 
    writeln('Введенный текст НЕ совпадает с частью последовательности 0123456789.');
end.
