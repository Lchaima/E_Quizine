-- Activite 4 -- 

-- vues -- 
Create view  Affichage_Joueur_Match_Score as
Select Jou_pseudo , mat_intitule , jou_score 
from T_JOUEUR_JOU join T_MATCH_MAT using (mat_id);

-- fonctions--

--> fonction qui calcule le taux de réussite global des joueurs  d'un match 

DELIMITER //
Create function taux_reussite_globale(match_code char(8)) returns double 
begin
set @moyenne:= (select avg(jou_score) as taux from T_JOUEUR_JOU where mat_id=match_id);
return @moyenne;
end ;
//
DELIMITER ;

--> fonction qui calcule le  nombre des joueurs  d'un match 

DELIMITER //
Create function nombre_joueur_match(match_id int) returns int 
begin
set @nombre:= (select count(jou_id) as nombre_joueur_par_match from T_JOUEUR_JOU where mat_id=match_id);
return @nombre;
end ;
//
DELIMITER ;

--> fonction qui crée un code pour un match : une chaine composée de 8 caractères aléatoires 


DELIMITER //
CREATE FUNCTION code_alea() returns char(8)
BEGIN
	DECLARE intervalle varchar(100);
	DECLARE counter INT DEFAULT 8;
    DECLARE Mcode char(8);
	set intervalle="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ?@_!";
	set Mcode="";
	WHILE counter > 0 DO
    	set @a:=substr(intervalle,round(rand()*66,0),1);
        set Mcode=concat(Mcode,@a);
    	SET counter := counter - 1;
  END WHILE;
return Mcode;                    
END;
//
DELIMITER ;

-- procédure --

--> verification si un joueur qui a déjà participé à un match, il a reparticipé  avec le même pseudo.

DELIMITER //
Create procedure Participation(IN joueur_pseudo varchar(45) , IN match_id int ,OUT verif boolean)
begin  
set @nombre:= (select count(jou_id) from T_JOUEUR_JOU where jou_pseudo=joueur_pseudo and mat_id=match_id) ;
if (@nombre = 0 ) then 
	set verif := false ;
else
	set verif := true ;
end if ;
end ;
//
DELIMITER ;

-- trigger -- 
 
 --> trigger qui permet de supprimer les actualités publiés par un compte si celui ci sera supprimé par la suite 
 
DELIMITER //
CREATE TRIGGER suppression_compte
BEFORE DELETE ON T_COMPTE_CPT
FOR EACH ROW
BEGIN
Delete from T_PROFIL_PFL where cpt_id=old.cpt_id ;
Delete from T_NEWS_NEW where cpt_id=old.cpt_id ;
update T_QUIZ_QUI set cpt_id=null where cpt_id=old.cpt_id ;
END;
//
DELIMITER ;

--> trigger qui permet de désactiver/activer les questions d'un quiz lors de son désactivation/activation 

DELIMITER //
CREATE TRIGGER desactivation_Activation_quiz
AFTER UPDATE ON  T_QUIZ_QUI
FOR EACH ROW
BEGIN
if (new.qui_etat = 'A') then 
	UPDATE T_QUESTION_QUE set que_etat='A' where qui_id=new.qui_id ;
end if ;
if (new.qui_etat ='D') then 
	UPDATE T_QUESTION_QUE set que_etat='D' where qui_id=new.qui_id ;
end if ;
END;
//
DELIMITER ;


-- Activite 5 -- 

/* trigger 1 */ 

/* une fonction qui retourne la liste de codes de matchs associés à un quiz et les formateurs concernés  */
DELIMITER //
CREATE FUNCTION  match_formateur_quiz (quiz_id int) returns varchar(500)
BEGIN 
select GROUP_CONCAT(mat_code) into @listeCode from T_MATCH_MAT where qui_id=quiz_id ;
select GROUP_CONCAT(DISTINCT (cpt_pseudo)) into @listeFormateurs from T_MATCH_MAT join T_COMPTE_CPT  using(cpt_id) where qui_id=quiz_id ;
if (@listeCode is null ) then 
	return "No matches associated with this quiz yet";
else 
	return CONCAT("The match codes associated with this quiz are:",@listeCode," and the trainers concerned are ",@listeFormateurs);
end if;
END ; 
//
DELIMITER ;


DELIMITER //
CREATE TRIGGER suppression_question
AFTER DELETE ON T_QUESTION_QUE
FOR EACH ROW
BEGIN
DECLARE texte varchar(100) ;
Delete from T_NEWS_NEW where new_intitule like CONCAT("Modification of QUIZ n°",LTRIM(old.qui_id )) ;
select count(*) into @nombre_question from T_QUESTION_QUE where qui_id=old.qui_id ;
case @nombre_question 
	when 0 then set texte:=" Empty quiz. ";
	when 1 then set texte:= " WARNING ! there is only one question. " ;
	else  set texte:= " Deleting a question." ;
end case ;
select match_formateur_quiz (old.qui_id) into @texte1 ;
insert into T_NEWS_NEW values (null,concat("Modification of QUIZ n°",LTRIM(old.qui_id)),concat(texte,@texte1),now(),1);
END ;
//
DELIMITER ;

/* trigger 2 */ 

DELIMITER //
CREATE TRIGGER remise_zero_match
AFTER UPDATE ON T_MATCH_MAT
FOR EACH ROW
BEGIN
if (old.mat_intitule=new.mat_intitule and old.mat_code=new.mat_code and new.mat_etat = old.mat_etat ) then 
	if (new.mat_debut > now() and new.mat_fin is null ) then 
		delete from T_JOUEUR_JOU where mat_id=new.mat_id ;
	end if ;
end if ;
END ;
//
DELIMITER ;

