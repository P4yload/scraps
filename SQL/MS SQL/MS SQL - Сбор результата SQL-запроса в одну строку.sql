-- �������
DECLARE @result nvarchar(max)
SET @result = '' -- ����������� ��������� ������ ������ �������
    SELECT @result = @result + CAST(IdUser AS nvarchar(20)) + ','
    FROM Users.Levels
    WHERE IdUser = 324
SELECT substring(@result, 0, len(@result) - 1) -- �������� ��������� �������

-- � ��� �������
SELECT CAST(IdUser AS nvarchar(20)) + ', '
FROM Users.Levels
WHERE IdUser = 324
FOR XML PATH('') -- ��� ��� ������ ��������

-- � ��� �� ��, �� �� � XML
SELECT CAST(
(SELECT CAST(IdUser AS nvarchar(20)) + ', '
FROM Users.Levels
WHERE IdUser = 324
FOR XML PATH(''))
AS VARCHAR(MAX))