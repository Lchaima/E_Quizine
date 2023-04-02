/* Matchs */ 

--> En tant que joueur 

--5--

select que_intitule, rep_texte from  T_MATCH_MAT  join T_QUESTION_QUE using (qui_id) join T_REPONSE_REP using (que_id)
where mat_id=1 and rep_validite=1 ;

--6--

select rep_validite from T_REPONSE_REP 
where que_id=1 and rep_texte='British' ;

--7--

update T_JOUEUR_JOU set jou_score=40 where jou_pseudo='Liheouel fatma' and mat_id=1 ;

--8--

select jou_score from T_JOUEUR_JOU where jou_pseudo='Liheouel fatma' and mat_id=1 ;

--> En tant que formateur 

--7--

insert into T_MATCH_MAT values (null,code_alea(),'Fifth harmony test ','A',2,6,now(),null);

--8--

update T_MATCH_MAT set mat_fin=now() where mat_id=10;

--9--

delete from  T_MATCH_MAT where mat_id=11 ;

--10--

update T_MATCH_MAT set mat_etat='A' where mat_id=10 ;

update T_MATCH_MAT set mat_etat='D' where mat_id=10 ;

--11--

update T_MATCH_MAT set mat_debut="2023-01-01 10:00:00" , mat_fin=null where mat_id=10 ;

/* Quiz */ 

--> En tant que formateur 

--3--

select * from T_QUIZ_QUI ;

--4--

DELIMITER //
CREATE FUNCTION  pseudo(compte_id int) returns varchar(20)
BEGIN 
SELECT cpt_pseudo into @pseudo from T_COMPTE_CPT where cpt_id=compte_id ;
RETURN @pseudo ;
END ; 
//
DELIMITER ;

select qui_intitule , pseudo(T_QUIZ_QUI.cpt_id) , mat_intitule , pseudo(T_MATCH_MAT.cpt_id)
from T_QUIZ_QUI join T_MATCH_MAT using (qui_id) ;

--5--

select * from T_QUIZ_QUI 
where cpt_id=3;

--6--

select *  from T_QUIZ_QUI where cpt_id=null ;

--7--

select T_COMPTE_CPT.cpt_pseudo , qui_id , qui_intitule , mat_id , mat_intitule
from T_COMPTE_CPT 
left OUTER  join  T_QUIZ_QUI USING (cpt_pseudo),
left outer join T_MATCH_MAT using (qui_id),
where T_COMPTE_CPT.cpt_pseudo='Singer2000';

