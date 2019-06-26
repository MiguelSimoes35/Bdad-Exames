/*
(14)
*/

/*
(15)
*/

/*
(16)
Listar o nome e ano curricular dos estudantes que apenas têm amigos do mesmo ano curricular.
*/

select Estudante.nome, Estudante.anoCurricular 
from Estudante 
where Estudante.ID In (
    select E1.ID
    from Estudante E1, Estudante E2, Amizade
    where Amizade.ID1 = E1.ID and Amizade.ID2 = E2.ID and E1.anoCurricular = E2.anoCurricular) 
and Estudante.ID not in (
    select E1.ID 
    from Estudante E1, Estudante E2, Amizade 
    where Amizade.ID1 = E1.ID and Amizade.ID2 = E2.ID and E1.anoCurricular <> E2.anoCurricular)
;

/*
(17)
*/

/*
(18)
*/

/*
(19)
*/