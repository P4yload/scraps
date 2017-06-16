-------------------------------------------------
-- ������ �������� ����������� �������������
-- �� ������ view � ������� ������
-------------------------------------------------
-- �������
CREATE TABLE tab
(
  num integer NOT NULL,
  "name" character varying(50),
  addr character varying(30),
  CONSTRAINT tab_pkey PRIMARY KEY (num)
)
WITH (OIDS=FALSE);
ALTER TABLE tab OWNER TO postgres;

-- �������������
-------------------------------------------------
CREATE OR REPLACE VIEW mytab AS 
 SELECT tab.num, tab.name, tab.addr
   FROM tab;
ALTER TABLE mytab OWNER TO postgres;

-- ������� �� ������������� (������ ���������)
-- �� INSERT UPDATE DELETE
-- new - �������� ����� (���������� �������)
-- old - �������� ������ �������
-------------------------------------------------
CREATE OR REPLACE RULE rule_sel AS
    ON INSERT TO mytab DO INSTEAD   -- ��� �������
INSERT INTO tab (num, name, addr)  -- ���� ��������
  VALUES (new.num, new.name, new.addr);

CREATE OR REPLACE RULE test_upd AS
    ON UPDATE TO mytab DO INSTEAD  
UPDATE tab SET num = new.num, name = new.name, addr = new.addr
  WHERE tab.num = old.num;   -- ������� ������� (����� � �������� �� �����)

CREATE OR REPLACE RULE test_del AS
    ON DELETE TO mytab DO INSTEAD  
DELETE FROM tab
  WHERE tab.num = old.num;

--������� �������� 
-------------------------------------------------
insert into mytab values (1,'sally','spb')

update mytab set num=20 where num>110

delete from mytab where name='sally'