(*
 * Project: RationalNumbersCalculator
 * Date: 08.11.2024
 * User: BerhtAdal
 * Email: berhtadal@gmail.com
 * Telegram: https://t.me/BerhtAdal
 *)
unit output_helper;

interface
  function ConvertNumberToChar(number: Integer): Char;
  procedure ConvertFrom10ToBase(numerator: longword; base: Word);
  procedure WriteNumeratorDenominatorToBase(numerator: LongInt;
                                               denominator: longword; base: Word);

implementation

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

procedure ConvertFrom10ToBase(numerator: longword; base: Word);
begin
  if numerator < base then
  begin
    write(ConvertNumberToChar(numerator div 16));
    write(ConvertNumberToChar(numerator mod 16));
    Write(' ');
    exit;
  end;
  ConvertFrom10ToBase(numerator div base, base);
  write(ConvertNumberToChar((numerator mod base) div 16));
  write(ConvertNumberToChar((numerator mod base) mod 16));
  Write(' ');
end;

procedure WriteNumeratorDenominatorToBase(numerator: LongInt;
                                             denominator: longword; base: Word);
begin
  Write(base);
  case base of
    0..9: Write('     ');
    10..99: Write('    ');
    100..256: Write('   ');
  end;
  if numerator < 0 then Write('-');
  ConvertFrom10ToBase(abs(numerator), base);
  Write('/ ');
  ConvertFrom10ToBase(abs(denominator), base);
  WriteLn();
end;
end.