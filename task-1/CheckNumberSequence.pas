var
  ch: char;          // ������� ������
  isMatch: boolean;  // ���� ��� �������� ���������� � �������������������
  expectedDigit: char; // ��������� ��������� ����� � ������������������
  firstChar: boolean;  // ���� ��� ������ ����� ������

// ������� ��� ��������, �������� �� ������ ������
function IsDigit(c: char): boolean;
begin
  IsDigit := (c >= '0') and (c <= '9');
end;

begin
  writeln('������� ����� (������ ����� � ������� ��������� �����), ��������������� ������:');
  
  isMatch := true;
  firstChar := true;

  while True do begin
    read(ch); // ������ ��������� ������

    if ch = '.' then
      break; // ������� �� ����� ��� ������� �����
      
    if (ord(ch) = 10) or (ord(ch) = 13) then begin
       writeln('������ ��������� �����.');
       exit();
    end;
    // ��������� �� ������������ �������
    if not IsDigit(ch) then
    begin
      writeln('��������� ����� �� ��������� � ������ ������������������ 0123456789.');
      exit;
    end;

    // ����������� ��������� ����� ������������������
    if firstChar then
    begin
      expectedDigit := ch;
      firstChar := false;
    end
    else
    begin
      // ���������, ��� ������� ������ ������������� ��������� �����
      if ch <> expectedDigit then
      begin
        isMatch := false;
        break;
      end;
    end;

    if ord(expectedDigit) > ord('9') then begin
        writeln('��������� ����� �� ��������� � ������ ������������������ .');
      exit;
     end;
         expectedDigit := chr(ord(expectedDigit) + 1);
  end; // ����������, ���� �� ������� �����

  if isMatch then
    writeln('��������� ����� ��������� � ������ ������������������ 0123456789.')
  else 
    writeln('��������� ����� �� ��������� � ������ ������������������ 0123456789.');
end.
