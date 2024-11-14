(*
 * Project: RationalNumbersCalculator
 * Date: 08.11.2024
 * User: BerhtAdal
 * Email: berhtadal@gmail.com
 * Telegram: https://t.me/BerhtAdal
 *)
unit output_helper;

interface
  // ‘ункци€ ConvertNumberToChar преобразует число от 0 до 15 в символ, представл€ющий его в шестнадцатеричной системе счислени€.
  function ConvertNumberToChar(number: Integer): Char;

  // ѕроцедура ConvertFrom10ToBase рекурсивно преобразует число из дес€тичной системы счислени€ в указанную систему счислени€ (base).
  procedure ConvertFrom10ToBase(numerator: longword; base: Word);

  // ѕроцедура WriteNumeratorDenominatorToBase выводит числитель и знаменатель в заданной системе счислени€ (base).
  procedure WriteNumeratorDenominatorToBase(numerator: LongInt; denominator: longword; base: Word);

implementation

{
    ‘ункци€ ConvertNumberToChar преобразует число от 0 до 15 в символ
    дл€ представлени€ в системах счислени€ с основанием до 16.
}
function ConvertNumberToChar(number: Integer): Char;
begin
  case number of
    0: ConvertNumberToChar := '0';
    1: ConvertNumberToChar := '1';
    2: ConvertNumberToChar := '2';
    3: ConvertNumberToChar := '3';
    4: ConvertNumberToChar := '4';
    5: ConvertNumberToChar := '5';
    6: ConvertNumberToChar := '6';
    7: ConvertNumberToChar := '7';
    8: ConvertNumberToChar := '8';
    9: ConvertNumberToChar := '9';
    10: ConvertNumberToChar := 'a';
    11: ConvertNumberToChar := 'b';
    12: ConvertNumberToChar := 'c';
    13: ConvertNumberToChar := 'd';
    14: ConvertNumberToChar := 'e';
    15: ConvertNumberToChar := 'f';
  end;
end;

{
   ѕроцедура ConvertFrom10ToBase рекурсивно преобразует число из дес€тичной системы
   в систему счислени€ с основанием base, вывод€ результат в виде последовательности символов.
}
procedure ConvertFrom10ToBase(numerator: longword; base: Word);
begin
  if numerator < base then
  begin
    // ¬ыводим результат дл€ последней цифры числа
    write(ConvertNumberToChar(numerator div 16));
    write(ConvertNumberToChar(numerator mod 16));
    Write(' ');
    exit;
  end;

  // –екурсивный вызов дл€ более значимых разр€дов числа
  ConvertFrom10ToBase(numerator div base, base);
  // ¬ыводим остаточные значени€
  write(ConvertNumberToChar((numerator mod base) div 16));
  write(ConvertNumberToChar((numerator mod base) mod 16));
  Write(' ');
end;

{
   ѕроцедура WriteNumeratorDenominatorToBase выводит числитель и знаменатель
   в заданной системе счислени€, учитыва€ формат и разр€дность.
}
procedure WriteNumeratorDenominatorToBase(numerator: LongInt; denominator: longword; base: Word);
begin
  // ¬ыводим основание системы счислени€
  Write(base);

  // ‘орматирование вывода в зависимости от величины основани€
  case base of
    0..9: Write('     ');
    10..99: Write('    ');
    100..256: Write('   ');
  end;

  // ≈сли числитель отрицательный, выводим минус
  if numerator < 0 then Write('-');

  // ѕреобразуем числитель в строку в системе счислени€ base
  ConvertFrom10ToBase(abs(numerator), base);

  // ¬ыводим дробь (знак '/' дл€ разделени€ числител€ и знаменател€)
  Write('/ ');

  // ѕреобразуем знаменатель в строку в системе счислени€ base
  ConvertFrom10ToBase(abs(denominator), base);

  // ѕечатаем переход на новую строку после вывода
  WriteLn();
end;

end.