/* Actualités */

--> en tant que visiteur

--1--

select new_intitule,cpt_pseudo
from T_NEWS_NEW join T_COMPTE_CPT using (cpt_id) 

--2--

select * from T_NEWS_NEW 
where new_id=1;

--3--

select * from T_NEWS_NEW
order by (new_date) desc 
limit 5 ;

--4--
select * from T_NEWS_NEW
where new_intitule like '%modification%'

--5-- 

select cpt_pseudo,new_intitule,new_description,new_date
from T_NEWS_NEW join T_COMPTE_CPT using(cpt_id)
where new_date='2022-10-28 11:31:13'

--> en tant que  formateur /administrateur

select cpt_id ,cpt_pseudo,new_id,new_intitule,new_description,new_date from T_NEWS_NEW join T_COMPTE_CPT using (cpt_id)
where cpt_pseudo='responsable';


/* matchs */ 

--> En tant que joueur

--1--
select count(*) from T_MATCH_MAT
where mat_code='LJbv21?3' ;

--2--
insert into T_JOUEUR_JOU values (null,'Mcamille',6,0);

--3--
select count(*) from T_JOUEUR_JOU
where jou_pseudo='LOLA' and mat_id=6 ;

--4--
select mat_intitule,que_ordre,que_intitule,rep_texte 
from T_MATCH_MAT join T_QUESTION_QUE using (qui_id) 
join T_REPONSE_REP using (que_id ) 
where mat_id=1 ;

--> En tant que formateur 

--1--

select que_intitule,rep_texte 
from T_MATCH_MAT join T_QUESTION_QUE using (qui_id)
join T_REPONSE_REP using (que_id)
where mat_code='M15!chdo'

--2--

select count(*) as nombre_joueurs 
from T_JOUEUR_JOU 
where mat_id=1 ;

--3-- 
select jou_score 
from T_JOUEUR_JOU 
where jou_id=1 ;

--4--
select jou_pseudo , jou_score 
from T_JOUEUR_JOU

--5--
select * 
from T_MATCH_MAT 
where cpt_id=3

--6--
select * from T_MATCH_MAT 
where qui_id=1 ;

/* Profils */

--> En tant qu'administrateur et formateur 

--1--

select cpt_id , pfl_nom ,pfl_prenom,pfl_mail,cpt_etat,cpt_role 
from T_PROFIL_PFL join T_COMPTE_CPT using (cpt_id) ;

--2--
select cpt_id , pfl_nom ,pfl_prenom,pfl_mail,cpt_etat,cpt_role 
from T_PROFIL_PFL join T_COMPTE_CPT using (cpt_id) 
where cpt_role='A';

select cpt_id , pfl_nom ,pfl_prenom,pfl_mail,cpt_etat,cpt_role 
from T_PROFIL_PFL join T_COMPTE_CPT using (cpt_id) 
where cpt_role='F';

--3--

select * from T_COMPTE_CPT 
where cpt_pseudo='responsable'
and cpt_mdp='a77bae11cdc3fe9b90d390e69a2b442cc7782310ef170069515b0b14ebdfeacf'
and cpt_etat='A';

--4--

select pfl_nom,pfl_prenom,pfl_mail,cpt_etat,cpt_role
from T_COMPTE_CPT join T_PROFIL_PFL using (cpt_id) 
where cpt_pseudo='responsable'

--5-- 
select cpt_pseudo,cpt_etat 
From T_COMPTE_CPT

/* QUIZ */ 
--> En tant que formateur 

--1--
select * 
from T_QUIZ_QUI join T_QUESTION_QUE using (qui_id)
join T_REPONSE_REP using (que_id) 
where qui_id=1

--2--

select count(*) as nombre_questions from T_QUESTION_QUE 
where qui_id=1;


