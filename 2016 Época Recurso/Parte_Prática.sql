/*
Os estudantes da FEUP decidiram organizar a sua rede social usando uma base de dados com o seguinte modelo relacional

Curso (ID, nome) PK(ID)
Estudante (ID, nome, curso->Curso, anoCurricular) PK(ID)
Amizade (ID1->Estudante, ID2->Estudante) PK(ID1, ID2)

O estudante com ID1 é amigo do estudante com ID2. Como as amizades são mútuas, se (1, 2) está na tabela Amizade (2, 1) também está.
*/

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
