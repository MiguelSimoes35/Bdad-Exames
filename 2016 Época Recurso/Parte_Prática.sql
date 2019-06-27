/*
Os estudantes da FEUP decidiram organizar a sua rede social usando uma base de dados com o seguinte modelo relacional

Curso (ID, nome) PK(ID)
Estudante (ID, nome, curso->Curso, anoCurricular) PK(ID)
Amizade (ID1->Estudante, ID2->Estudante) PK(ID1, ID2)

O estudante com ID1 é amigo do estudante com ID2. Como as amizades são mútuas, se (1, 2) está na tabela Amizade (2, 1) também está.
*/

/*
(15)
Liste todos os estudantes que são amigos de alguém cujo nome comece por Gabriel
*/

select E2.nome 
from Estudante E1, Estudante E2, Amizade 
where Amizade.ID1 = E1.ID and Amizade.ID2 = E2.ID and E1.nome like "Gabriel %";

/*
(16)
Liste o nome dos estudantes com amigos em todos os anos curriculares
*/

select nome 
from (
    select E1.nome, count (distinct E2.anoCurricular) as years 
    from Estudante E1, Estudante E2, Amizade 
    where E1.ID = Amizade.ID1 
      and E2.ID = Amizade.ID2 
      group by Amizade.ID1
    ) 
where years = (
    select count(distinct anoCurricular) 
    from Estudante
);

/*
(17)
Considere que para todos os casos em que A é amigo de B e B é amigo de C, A é amigo de C.
Crie uma tabela com as novas amizades formadas, sem amizades duplicadas, auto-amizades e amizades que já existam na tabela Amizade.
*/

Select E1.id, E3.id 
from Estudante E1, Estudante E2, Estudante E3, Amizade A1, Amizade A2 
where E1.id = A1.ID1 
  AND E2.id = A1.ID2 
  AND E2.id = A2.ID1 
  AND E3.id = A2.ID2 
  AND E1.id <> E3.id 
  AND (E1.id, E3.id) not in Amizade
ORDER BY E1.id, E3.id;

/*
(18)
Liste todos os pares de amigos de cursos diferentes. A listagem não deve conter pares repetidos nem pares simétricos.
*/
select E1.nome, E2.nome 
from Estudante E1, Estudante E2, Amizade 
where E1.ID = Amizade.ID1 
  and E2.ID = Amizade.ID2 
  and E1.curso <> E2.curso 
  and E1.ID < E2.ID;

/*
(19)
Criar os triggers necessários para garantir que a amizade é mútua sempre que haja inserções ou eliminações na tabela Amizade.
Criar também um trigger que impeça atualizações à tabela Amizade
*/

-- Inserir Amizade mútua
create Trigger InsertAmizade
after insert on Amizade
begin
insert into Amizade
select E1.ID, E2.ID
from Estudante E1, Estudante E2
where E1.ID = New.ID2 and E2.ID = New.ID1;
end;

--Apagar Amizade mútua
create Trigger DeleteAmizade
after delete on Amizade
begin
delete from Amizade
where Amizade.ID1 = Old.ID2 and Amizade.ID2 = Old.ID1;
end;

create Trigger SuspendUpdates
before update on Amizade
begin
select raise(abort, 'No updates allowed');
end;
