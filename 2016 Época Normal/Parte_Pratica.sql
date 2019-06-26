/*
(14)
Listar o nome de cada estudante inscrito no 3º ano curricular, e o curso em que está inscrito
*/

/*
(15)
Listar o nome dos estudantes com mais de 3 amigos
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
Listar os id's dos amigos em 3º grau do aluno Miguel Sampaio.
Um amigo em 3º grau é um amigo de um amigo de um amigo.
A listagem não deve ter tuplos repetidos.
*/

/*
(18)
Indicar o nome e ano curricular dos estudantes que têm o maior número de amigos.
*/

/*
(19)
Criar um gatilho que na inserção de um estudante o torne amigo de todos os estudantes do mesmo curso.
Nota: As amizades são mútuas.
*/