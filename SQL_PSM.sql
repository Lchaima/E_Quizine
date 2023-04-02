-- SQL PSM Pour aller plus loin --
-- Activite 2 -- 

DELIMITER //
CREATE FUNCTION  liste_joueurs ( match_id int ) RETURNS varchar(300) 
begin 
return (select GROUP_CONCAT(jou_pseudo) from T_JOUEUR_JOU where mat_id=match_id) ;
end ;
//
DELIMITER ;

--test--
select liste_joueurs(1) as joueurs ;


DELIMITER //
CREATE PROCEDURE Ajout_actualite (IN match_id INT )
BEGIN 
select mat_fin  into @match_date_fin from T_MATCH_MAT  where mat_id=match_id ;
select mat_debut into @match_date_debut from T_MATCH_MAT  where mat_id=match_id ;
select mat_intitule into @match_intitule from T_MATCH_MAT  where mat_id=match_id ;
select liste_joueurs(match_id) into @joueurs ;
set @actualite_description = concat(@match_intitule," started the ",@match_date_debut," and it finished the",@match_date_fin,".The participaters were : ",@joueurs) ;
if (@match_date_fin is not null) then 
	set @intitule = concat(@match_intitule," : NEWS ");
	insert into T_NEWS_NEW VALUES (NULL,@intitule,@actualite_description,now(),1);
end if ;
end;
//
DELIMITER ;

-- test --
call Ajout_actualite(1) ;

DELIMITER //
CREATE TRIGGER ajout
AFTER UPDATE ON T_MATCH_MAT
FOR EACH ROW
BEGIN
call Ajout_actualite(OLD.mat_id) ;
END;
//
DELIMITER ;


-- puis update d'une ligne de la table T_MATCH_MAT
UPDATE T_MATCH_MAT set mat_fin=now() where mat_id=3 ;


DELIMITER //
CREATE PROCEDURE nombre_matchs(OUT nombre_matchs_finis int , OUT nombre_matchs_en_cours int , out nombre_matchs_a_venir int)
BEGIN 
select count(mat_id) into nombre_matchs_finis from T_MATCH_MAT where mat_fin is not null ;
select count(mat_id) into nombre_matchs_en_cours from T_MATCH_MAT where mat_fin is null and mat_debut is not null ;
select count(mat_id) into nombre_matchs_a_venir from T_MATCH_MAT where mat_debut is null ;
end;
//
DELIMITER ;

-- test--
set @nombre_matchs_finis=0;
set @nombre_matchs_en_cours=0;
set @nombre_matchs_a_venir=0;
call nombre_matchs(@nombre_matchs_finis,@nombre_matchs_en_cours,@nombre_matchs_a_venir);
SELECT @nombre_matchs_finis,@nombre_matchs_en_cours,@nombre_matchs_a_venir;


/* le reste de code SQL/PSM */ 
-- CM  10/10/2022 -- 

set @nouvelle_id := (select max(pfl_id) from t_profil_pfl)  ;
                    
select @nouvelle_id;

select Max pfl_id into @num_max from t_profil_pfl;
select @num_max ;

set @annee:= (select min(YEAR(pfl_date)) from t_profil_pfl );
SELECT @annee ;

select min(Year(pfl_date)) into @annee1 from t_profil_pfl ;
select @annee ;

 
 -- CM 17/10/2022 
 
-- Activite 3 -- 

DELIMITER //
CREATE FUNCTION age( Ndate date ) returns int
begin 
set @age := (year(now())-year(Ndate)) ;
	if ((MONTH(Ndate) > MONTH(now())) or (MONTH(Ndate) = MONTH(now())) and (DAY(Ndate) > DAY(now()))) then 
        return @age-1;
    else 
        return @age;
    END if ;
END;
//
DELIMITER ;

 select pfl_prenom,age(pfl_date_naissance) as age from t_profil_pfl;
 
 
 -- Activite 4 -- 
 
 DELIMITER //
create procedure ageP(IN id int , OUT P_age int ) 
Begin 
set @naissance:= (select pfl_date_naissance from t_profil_pfl where pfl_id=id) ; 
select age(@naissance) into P_age ;
END;
//
DELIMITER ;


set @sonAge:=0 ;
call ageP(1,@sonAge) ;
select @sonAge;

 
 DELIMITER //
create procedure majeur(IN id_pfl int , out majeur_pfl char(30))
BEGIN 
DECLARE AGE INT DEFAULT 0 ;
select donner_age(pfl_date_naissance) into age from t_profil_pfl where pfl_id=id_pfl ;
if age < 18 THEN 
	set majeur_pfl:='mineur';
 else 
 	set majeur_pfl:= 'majeur';
 end if;
end;
//
DELIMITER ;


set @maj="";
call majeur(1,@maj);
select @maj;


-- Activite 5 -- 



DELIMITER //
CREATE TRIGGER date_now_verif
BEFORE INSERT ON t_profil_pfl
FOR EACH ROW
BEGIN
set new.pfl_date=CURDATE( ); 
END;
//
DELIMITER ;


DELIMITER //
CREATE  trigger maj_profil2
after update on t_compte_cpt
fro reach row 
begin 
update t_profil_pfl set pfl_date=curdate() where t_profil_pfl.pfl_id=new.pfl_id;
END;
//
DELIMITER ;

-- Activite 1 de SQL/PSM pour aller plus loin 

select cpt_pseudo,pfl_nom,pfl_prenom,new_description
from T_COMPTE_CPT 
Join T_PROFIL_PFL USING (cpt_id) 
LEFT OUTER JOIN T_NEWS_NEW USING (cpt_id)

--A--
select cpt_pseudo,pfl_nom,pfl_prenom 
from T_COMPTE_CPT 
Join T_PROFIL_PFL USING (cpt_id) 
LEFT OUTER JOIN T_NEWS_NEW USING (cpt_id)
where new_description is NULL ;

--B--
select cpt_pseudo , pfl_nom, pfl_prenom 
from T_COMPTE_CPT 
join T_PROFIL_PFL using(cpt_id)
EXCEPT
select cpt_pseudo , pfl_nom, pfl_prenom 
from T_PROFIL_PFL 
join T_COMPTE_CPT using(cpt_id)
join T_NEWS_NEW using (cpt_id) ;

