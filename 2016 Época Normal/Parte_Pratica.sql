/*
Os estudantes da FEUP decidiram organizar a sua rede social usando uma base de dados com o seguinte modelo relacional

Curso (ID, nome) PK(ID)
Estudante (ID, nome, curso->Curso, anoCurricular) PK(ID)
Amizade (ID1->Estudante, ID2->Estudante) PK(ID1, ID2)

O estudante com ID1 é amigo do estudante com ID2. Como as amizades são mútuas, se (1, 2) está na tabela Amizade (2, 1) também está.
*/

/*
(14)
Listar o nome de cada estudante inscrito no 3º ano curricular, e o curso em que está inscrito
*/
select Estudante.nome, Curso.nome 
from Estudante, Curso 
where anoCurricular = 3 and Estudante.curso = curso.ID;

/*
(15)
Listar o nome dos estudantes com mais de 3 amigos
*/

select Estudante.nome 
from Estudante, Amizade 
where Estudante.ID = Amizade.ID1 
group by Amizade.ID1 
having count(Amizade.ID2) > 3;

/*
(16)
Listar o nome e ano curricular dos estudantes que apenas têm amigos do mesmo ano curricular.
*/

select Estudante.nome, Estudante.anoCurricular 
from Estudante 
where Estudante.ID In (
    select E1.ID
    from Estudante E1, Estudante E2, Amizade
    where Amizade.ID1 = E1.ID and Amizade.ID2 = E2.ID and E1.anoCurricular = E2.anoCurricular
) 
and Estudante.ID not in (
    select E1.ID 
    from Estudante E1, Estudante E2, Amizade 
    where Amizade.ID1 = E1.ID and Amizade.ID2 = E2.ID and E1.anoCurricular <> E2.anoCurricular
);

/*
(17)
Listar os id's dos amigos em 3º grau do aluno Miguel Sampaio.
Um amigo em 3º grau é um amigo de um amigo de um amigo.
A listagem não deve ter tuplos repetidos.
*/

Select distinct E4.id 
from Estudante E1, Estudante E2, Estudante E3, Estudante E4, Amizade A1, Amizade A2, Amizade A3 
where E1.id = A1.ID1 AND E2.id = A1.ID2 
  AND E2.id = A2.ID1 AND E3.id = A2.ID2 
  and E3.id = A3.ID1 and E4.id = A3.ID2 
  and E1.nome = "Miguel Sampaio";

/*
(18)
Indicar o nome e ano curricular dos estudantes que têm o maior número de amigos.
*/

select Estudante.nome, Estudante.anoCurricular 
from Estudante, Amizade 
where Estudante.ID = Amizade.ID1 
group by Amizade.ID1 
having count(Amizade.ID2) = (
    select max(friends) 
    from (
        select count(Amizade.ID2) as friends 
        from Estudante, Amizade 
        where Estudante.ID = Amizade.ID1 
        group by Amizade.ID1
    )
);

/*
(19)
Criar um gatilho que na inserção de um estudante o torne amigo de todos os estudantes do mesmo curso.
Nota: As amizades são mútuas.
*/

create trigger NewFriends
after insert on Estudante
for each row
Begin
insert into Amizade
    select New.ID, Estudante.ID
    from Estudante
    where Estudante.curso = New.curso and Estudante.ID <> New.ID;
insert into Amizade 
    select Estudante.ID, New.ID
    from Estudante
    where Estudante.curso = new.curso and Estudante.ID <> New.ID;
End;
