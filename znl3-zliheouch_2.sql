-- phpMyAdmin SQL Dump
-- version 5.1.3
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : dim. 11 déc. 2022 à 18:43
-- Version du serveur : 10.5.12-MariaDB-0+deb11u1
-- Version de PHP : 7.4.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `znl3-zliheouch_2`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`zliheouch`@`%` PROCEDURE `Ajout_actualite` (IN `match_id` INT)   BEGIN 
select mat_fin  into @match_date_fin from T_MATCH_MAT  where mat_id=match_id ;
select mat_debut into @match_date_debut from T_MATCH_MAT  where mat_id=match_id ;
select mat_intitule into @match_intitule from T_MATCH_MAT  where mat_id=match_id ;
select liste_joueurs(match_id) into @joueurs ;
set @actualite_description = concat(@match_intitule," started the ",@match_date_debut," and it finished the",@match_date_fin,".The participaters were : ",@joueurs) ;
if (@match_date_fin is not null and @match_date_fin > @match_date_debut ) then 
	set @intitule = concat(@match_intitule," : NEWS ");
	insert into T_NEWS_NEW VALUES (NULL,@intitule,@actualite_description,now(),1);
end if ;
end$$

CREATE DEFINER=`zliheouch`@`%` PROCEDURE `nombre_matchs` (OUT `nombre_matchs_finis` INT, OUT `nombre_matchs_en_cours` INT, OUT `nombre_matchs_a_venir` INT)   BEGIN 
select count(mat_id) into nombre_matchs_finis from T_MATCH_MAT where mat_debut < mat_fin and  mat_fin is not null ;
select count(mat_id) into nombre_matchs_en_cours from T_MATCH_MAT where mat_fin is null and mat_debut < now() ;
select count(mat_id) into nombre_matchs_a_venir from T_MATCH_MAT where mat_debut is null or mat_debut > now() ;
end$$

CREATE DEFINER=`zliheouch`@`%` PROCEDURE `Participation` (IN `joueur_pseudo` VARCHAR(45), IN `match_id` INT, OUT `verif` BOOLEAN)   begin  
set @nombre:= (select count(jou_id) from T_JOUEUR_JOU where jou_pseudo=joueur_pseudo and mat_id=match_id) ;
if (@nombre = 0 ) then 
	set verif := false ;
else
	set verif := true ;
end if ;
end$$

--
-- Fonctions
--
CREATE DEFINER=`zliheouch`@`%` FUNCTION `code_alea` () RETURNS CHAR(8) CHARSET utf8mb4  BEGIN
	DECLARE intervalle varchar(100);
	DECLARE counter INT DEFAULT 8;
    DECLARE Mcode char(8);
	set intervalle="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_";
	set Mcode="";
	WHILE counter > 0 DO
    	set @a:=substr(intervalle,round(rand()*63,0),1);
        set Mcode=concat(Mcode,@a);
    	SET counter := counter - 1;
  END WHILE;
return Mcode;                    
END$$

CREATE DEFINER=`zliheouch`@`%` FUNCTION `liste_joueurs` (`match_id` INT) RETURNS VARCHAR(300) CHARSET utf8mb4  begin 
select count(mat_id) into @nombre from T_MATCH_MAT where mat_id=match_id ;
select GROUP_CONCAT(jou_pseudo) into @liste from T_JOUEUR_JOU where mat_id=match_id ;
if (@nombre = 0 ) then 
     return " cet identifiant de match n'existe pas !" ;
end if ;
if (@liste is null ) then 
    return " il n'y a pas des joueurs pour ce match pour le moment !";
else 
	return @liste ;
end if ;
end$$

CREATE DEFINER=`zliheouch`@`%` FUNCTION `match_formateur_quiz` (`quiz_id` INT) RETURNS VARCHAR(500) CHARSET utf8mb4  BEGIN 
select GROUP_CONCAT(mat_code) into @listeCode from T_MATCH_MAT where qui_id=quiz_id ;
select GROUP_CONCAT(DISTINCT (cpt_pseudo)) into @listeFormateurs from T_MATCH_MAT join T_COMPTE_CPT  using(cpt_id) where qui_id=quiz_id ;
if (@listeCode is null ) then 
	return "No matches associated with this quiz yet";
else 
	return CONCAT("The match codes associated with this quiz are:",@listeCode," and the trainers concerned are ",@listeFormateurs);
end if;
END$$

CREATE DEFINER=`zliheouch`@`%` FUNCTION `nombre_joueur_match` (`match_id` INT) RETURNS INT(11)  begin
set @nombre:= (select count(jou_id) as nombre_joueur_par_match from T_JOUEUR_JOU where mat_id=match_id);
return @nombre;
end$$

CREATE DEFINER=`zliheouch`@`%` FUNCTION `pseudo` (`compte_id` INT) RETURNS VARCHAR(20) CHARSET utf8mb4  BEGIN 
SELECT cpt_pseudo into @pseudo from T_COMPTE_CPT where cpt_id=compte_id ;
RETURN @pseudo ;
END$$

CREATE DEFINER=`zliheouch`@`%` FUNCTION `taux_reussite_globale` (`match_code` CHAR(8)) RETURNS DOUBLE  begin
set @moyenne:= (select avg(jou_score) as taux from T_JOUEUR_JOU join T_MATCH_MAT using (mat_id) where mat_code=match_code);
return @moyenne;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `Affichage_Joueur_Match_Score`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `Affichage_Joueur_Match_Score` (
`Jou_pseudo` varchar(45)
,`mat_intitule` varchar(200)
,`jou_score` double
);

-- --------------------------------------------------------

--
-- Structure de la table `T_COMPTE_CPT`
--

CREATE TABLE `T_COMPTE_CPT` (
  `cpt_id` int(11) NOT NULL,
  `cpt_pseudo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `cpt_mdp` char(64) NOT NULL,
  `cpt_role` char(1) NOT NULL,
  `cpt_etat` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `T_COMPTE_CPT`
--

INSERT INTO `T_COMPTE_CPT` (`cpt_id`, `cpt_pseudo`, `cpt_mdp`, `cpt_role`, `cpt_etat`) VALUES
(1, 'responsable', 'e6c8344f799b8c899eaaae2b730ac9df549aa58ab2382270175e2be7e74f24a5', 'A', 'A'),
(2, 'MusicTeacher', '047aa03bc38265e653e668620f2cef3c2f171c67278caeaf2e3f875cae60cd3d', 'F', 'A'),
(3, 'Singer2000', '5bb1ded030696f8f4467b31e97059934aa2339c43d697b4adc8f4af36825b2c0', 'F', 'A'),
(4, 'ProMusic', '55bb69fb2dc0658e3e022ff542e59c2466c6898a57cba7e72212ba02edba05d2', 'F', 'D'),
(5, 'Musicstart\'up', '731dbd23ef4a9cc22b61ab75c5e405f537afd6f038115f75c584cb82f2685a21', 'F', 'D'),
(7, 'Lchaima', '23461ea370fb833fc2e606dcdb7d41e7f1d541d8ae23b9719829e4851cecbe09', 'F', 'A');

--
-- Déclencheurs `T_COMPTE_CPT`
--
DELIMITER $$
CREATE TRIGGER `suppression_compte` BEFORE DELETE ON `T_COMPTE_CPT` FOR EACH ROW BEGIN
Delete from T_PROFIL_PFL where cpt_id=old.cpt_id ;
Delete from T_NEWS_NEW where cpt_id=old.cpt_id ;
update T_QUIZ_QUI set cpt_id=null where cpt_id=old.cpt_id ;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `T_JOUEUR_JOU`
--

CREATE TABLE `T_JOUEUR_JOU` (
  `jou_id` int(11) NOT NULL,
  `jou_pseudo` varchar(45) NOT NULL,
  `mat_id` int(11) NOT NULL,
  `jou_score` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `T_JOUEUR_JOU`
--

INSERT INTO `T_JOUEUR_JOU` (`jou_id`, `jou_pseudo`, `mat_id`, `jou_score`) VALUES
(1, 'Liheouel Achraf', 2, 66.66),
(2, 'Liheouel fatma', 1, 40),
(3, 'musicMyLife', 1, 100),
(4, 'player', 1, 60),
(5, 'sarrah', 1, 40),
(6, 'Tgamer', 2, 33.33),
(7, 'khouloud', 2, 83.33),
(15, 'jacob', 2, 33.33),
(16, 'jeremy', 1, 0),
(17, 'Anne', 1, 80),
(18, 'jalal', 1, 80),
(37, 'chaima', 1, 0),
(42, 'chachou', 1, 0),
(43, 'chouchou', 1, 0),
(46, 'sami', 2, 0),
(47, 'lala', 2, 0),
(48, 'chaima', 2, 0),
(62, 'jannet', 2, 0),
(63, 'ali', 2, 0),
(66, 'fafa', 2, 0),
(67, 'aivha', 5, 0),
(68, 'nadia', 5, 0),
(69, 'mourad', 5, 0),
(71, 'VAVA29', 14, 0);

-- --------------------------------------------------------

--
-- Structure de la table `T_MATCH_MAT`
--

CREATE TABLE `T_MATCH_MAT` (
  `mat_id` int(11) NOT NULL,
  `mat_code` char(8) NOT NULL,
  `mat_intitule` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `mat_etat` char(1) NOT NULL,
  `cpt_id` int(11) NOT NULL,
  `qui_id` int(11) NOT NULL,
  `mat_debut` datetime DEFAULT NULL,
  `mat_fin` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `T_MATCH_MAT`
--

INSERT INTO `T_MATCH_MAT` (`mat_id`, `mat_code`, `mat_intitule`, `mat_etat`, `cpt_id`, `qui_id`, `mat_debut`, `mat_fin`) VALUES
(1, 'M15_chdo', 'First round of Alicia\'s Keys Quiz', 'A', 3, 1, '2022-10-09 14:00:00', '2022-10-09 14:18:00'),
(2, 'ch21KAdo', 'Guess the FIFA soundtrack by hani', 'A', 5, 2, '2022-10-15 20:22:00', NULL),
(4, 'QCKFJ74L', 'First round of British music quiz', 'A', 3, 3, NULL, NULL),
(5, 'OKS48JF8', 'Second round of British music Quiz', 'A', 3, 3, '2022-10-28 11:11:27', NULL),
(12, '9QyhMWet', 'Alicia Quiz', 'D', 2, 1, '2023-01-01 10:00:00', NULL),
(14, 'Fhuw4WgB', 'Quiz Alicya by chaima', 'A', 7, 1, '2023-01-01 10:00:00', NULL),
(18, 'agQqADo7', 'let', 'A', 7, 1, '2022-12-22 00:00:00', NULL),
(19, 'bqzx0p20', 'test', 'A', 3, 1, '2022-12-26 00:00:00', NULL);

--
-- Déclencheurs `T_MATCH_MAT`
--
DELIMITER $$
CREATE TRIGGER `ajout_actualite_match` AFTER UPDATE ON `T_MATCH_MAT` FOR EACH ROW BEGIN
if (OLD.mat_fin is null and NEW.mat_fin is not null ) then 
call Ajout_actualite(new.mat_id) ;
end if ;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `remise_zero_match` AFTER UPDATE ON `T_MATCH_MAT` FOR EACH ROW BEGIN
if (old.mat_intitule=new.mat_intitule and old.mat_code=new.mat_code and new.mat_etat = old.mat_etat ) then 
	if (new.mat_debut > now() and new.mat_fin is null ) then 
		delete from T_JOUEUR_JOU where mat_id=new.mat_id ;
	end if ;
end if ;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `T_NEWS_NEW`
--

CREATE TABLE `T_NEWS_NEW` (
  `new_id` int(11) NOT NULL,
  `new_intitule` varchar(200) NOT NULL,
  `new_description` varchar(500) DEFAULT NULL,
  `new_date` datetime NOT NULL,
  `cpt_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `T_NEWS_NEW`
--

INSERT INTO `T_NEWS_NEW` (`new_id`, `new_intitule`, `new_description`, `new_date`, `cpt_id`) VALUES
(1, 'Our site is coming soon!', 'the launch of our site is soon.On our site, you can take part in 2000\'s songs quizes', '2022-10-05 23:12:13', 1),
(2, 'Can you guess the 2000\'s song', 'take part of these quizes and taste your Music Culture.Many Quizes of songs that 2000\'s kid grew up with', '2022-10-08 09:00:00', 1),
(4, 'A fan of Alicia Keys ?', 'participate in Alicia Key\'s Quiz and test how much fan you are!', '2022-10-10 09:01:11', 3),
(7, 'First round of Alicia\'s Keys Quiz : NEWS ', 'First round of Alicia\'s Keys Quiz started the 2022-10-09 14:00:00 and it is finished the2022-10-09 14:18:00.The participators were : +Liheouel fatma,musicMyLife', '2022-10-23 22:10:26', 1),
(11, 'Guess the FIFA soundtrack by hani : NEWS ', 'Guess the FIFA soundtrack by hani started the 2022-10-15 20:22:00 and it is finished the2022-10-28 11:28:28.The participators were : +Liheouel Achraf,Tgamer,khouloud', '2022-10-28 11:28:33', 1),
(22, 'Modification of QUIZ n°5', ' Empty quiz. The match codes associated with this quiz are:t154ghjt,treaghf7 and the trainers concerned are MusicTeacher,Singer2000', '2022-11-10 11:20:58', 1),
(24, 'Fifth harmony test  : NEWS ', 'Fifth harmony test  started the 2022-11-12 23:55:00 and it finished the2022-11-12 23:58:34.The participaters were :  il n\'y a pas des joueurs pour ce match pour le moment !', '2022-11-12 23:58:34', 1),
(26, 'Modification of QUIZ n°6', ' Empty quiz. The match codes associated with this quiz are:jRcy2G8I and the trainers concerned are MusicTeacher', '2022-11-13 00:14:40', 1),
(29, 'Modification of QUIZ n°3', ' Deleting a question.The match codes associated with this quiz are:QCKFJ74L,OKS48JF8 and the trainers concerned are Singer2000', '2022-12-06 01:01:26', 1);

-- --------------------------------------------------------

--
-- Structure de la table `T_PROFIL_PFL`
--

CREATE TABLE `T_PROFIL_PFL` (
  `cpt_id` int(11) NOT NULL,
  `pfl_nom` varchar(60) NOT NULL,
  `pfl_prenom` varchar(60) NOT NULL,
  `pfl_mail` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `T_PROFIL_PFL`
--

INSERT INTO `T_PROFIL_PFL` (`cpt_id`, `pfl_nom`, `pfl_prenom`, `pfl_mail`) VALUES
(1, 'Marc', 'Valérie', 'vmarc@univ-brest.fr'),
(2, 'Le Roux', 'Samuel', 'LeRoux.Samuel@gmail.com'),
(3, 'Ouihya', 'Faouzia', 'OuihyaFaouzia@gmail.com'),
(4, 'Amine', 'Aicha', 'AmineAicha@gmail.com'),
(5, 'Ghorbel', 'Hani', 'GorbelHani@gmail.com'),
(7, 'liheouel', 'chaima', 'liheouel.chaima@gmail.com');

-- --------------------------------------------------------

--
-- Structure de la table `T_QUESTION_QUE`
--

CREATE TABLE `T_QUESTION_QUE` (
  `que_id` int(11) NOT NULL,
  `que_intitule` varchar(200) NOT NULL,
  `que_ordre` int(11) NOT NULL,
  `que_etat` char(1) NOT NULL,
  `qui_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `T_QUESTION_QUE`
--

INSERT INTO `T_QUESTION_QUE` (`que_id`, `que_intitule`, `que_ordre`, `que_etat`, `qui_id`) VALUES
(1, 'what\'s the nationnality of Alicia Keys ?', 1, 'A', 1),
(2, 'what\'s the name of her first song ?', 2, 'A', 1),
(3, 'her song Fallin won 3 Grammy Awards .', 3, 'A', 1),
(4, '\'Some people think That the physical things Define what\'s within And I\'ve been there before That life\'s a bore So full of the superficial\' those lyrics are excerpt from : ', 4, 'A', 1),
(5, 'this image is the cover of the Album :', 5, 'A', 1),
(7, 'Adele\'s first album is titled :', 1, 'A', 3),
(8, 'MAKE YOU FEEL MY LOVE is song by :', 2, 'A', 3),
(9, 'Fill the blanks of Hello\'s lyrics: Hello, can you hear me? I\'m in ... dreaming about who we used to be When we were younger and free I\'ve forgotten how it felt before the world fell at our feet', 3, 'A', 3),
(13, 'guess the year : on top of the world by Imagine Dragons', 1, 'A', 2),
(14, 'the 2016\'s FIFA soundtrack \'way down we gon \' is by :', 2, 'A', 2),
(15, 'the world cup  song \' Wavin\' flag \' is a coca-cola promotion ?', 3, 'A', 2),
(16, ' \' Feel the magic in the air\' is : ', 4, 'A', 2),
(17, ' complete the lyrics : You\'re a good ... , choosing your battles\r\nPick yourself up and dust yourself off, get back in the saddle', 5, 'A', 2),
(18, 'the name of the official 1998 FIFA world cup song is :', 6, 'A', 2),
(34, 'Baby, I have no story to be told But I\'ve heard one on you, now I\'m gonna make your head burn Think of me in the depths of your despair Make a home down there, as mine sure won\'t be shared', 4, 'A', 3),
(35, 'ED SHEERAN song \'Perfect\' came out in :', 5, 'A', 3),
(36, 'thinking out loud\'s lyrics: Take me into your loving arms Kiss me under the light of a thousand stars Place your head on my ... I\'m thinking out loud Maybe we found love right where we are', 6, 'A', 3),
(37, 'the title \'Fire on Fire \' is came out by :', 6, 'A', 3);

--
-- Déclencheurs `T_QUESTION_QUE`
--
DELIMITER $$
CREATE TRIGGER `suppression_question` AFTER DELETE ON `T_QUESTION_QUE` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `T_QUIZ_QUI`
--

CREATE TABLE `T_QUIZ_QUI` (
  `qui_id` int(11) NOT NULL,
  `qui_intitule` varchar(200) NOT NULL,
  `qui_image` varchar(200) NOT NULL,
  `qui_etat` char(1) NOT NULL,
  `cpt_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `T_QUIZ_QUI`
--

INSERT INTO `T_QUIZ_QUI` (`qui_id`, `qui_intitule`, `qui_image`, `qui_etat`, `cpt_id`) VALUES
(1, 'Alicia Keys', 'alicia_keys.jpeg', 'A', 3),
(2, 'FIFA soundtrack and WORLD CUP anthems.', 'FIFA.png', 'A', 5),
(3, 'British Music', 'british_music.jpg', 'A', 2),
(4, 'Latino Hits', 'Latino_hits.jpg', 'A', 4),
(5, 'Old Arabic tarab song', 'tarab.jpg', 'A', 7);

--
-- Déclencheurs `T_QUIZ_QUI`
--
DELIMITER $$
CREATE TRIGGER `desactivation_Activation_quiz` AFTER UPDATE ON `T_QUIZ_QUI` FOR EACH ROW BEGIN
if (new.qui_etat = 'A') then 
	UPDATE T_QUESTION_QUE set que_etat='A' where qui_id=new.qui_id ;
end if ;
if (new.qui_etat ='D') then 
	UPDATE T_QUESTION_QUE set que_etat='D' where qui_id=new.qui_id ;
end if ;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `T_REPONSE_REP`
--

CREATE TABLE `T_REPONSE_REP` (
  `rep_id` int(11) NOT NULL,
  `rep_texte` varchar(200) NOT NULL,
  `rep_validite` tinyint(4) NOT NULL,
  `que_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `T_REPONSE_REP`
--

INSERT INTO `T_REPONSE_REP` (`rep_id`, `rep_texte`, `rep_validite`, `que_id`) VALUES
(1, 'British', 0, 1),
(2, 'American', 1, 1),
(3, 'south african', 0, 1),
(4, 'Canadian', 0, 1),
(5, 'if i ain\'t got you', 0, 2),
(6, 'Girl on fire', 0, 2),
(7, 'NO one', 0, 2),
(8, 'Fallin\'', 1, 2),
(9, 'TRUE', 1, 3),
(10, 'FALSE', 0, 3),
(11, 'Empire State of Mind Broken Down', 0, 4),
(12, 'A Woman\'s Worth', 0, 4),
(13, 'if i ain\'t got you', 1, 4),
(14, 'Keys', 0, 5),
(15, 'Here', 1, 5),
(16, 'Songs in A minor', 0, 5),
(17, 'FIFA 13', 1, 13),
(18, 'FIFA 10', 0, 13),
(19, 'FIFA 15', 0, 13),
(20, 'Kygo', 0, 14),
(21, 'Kaleo', 1, 14),
(22, 'Huntar', 0, 14),
(23, 'YES', 1, 15),
(24, 'NO', 0, 15),
(25, 'British song', 0, 16),
(26, 'Spanish song', 0, 16),
(27, 'Frensh song', 1, 16),
(28, 'player', 0, 17),
(29, 'soldier', 1, 17),
(30, 'human', 0, 17),
(31, 'La Copa de la Vida (The Cup of Life)', 1, 18),
(32, 'Boom', 0, 18),
(33, 'The Time of Our Lives', 0, 18),
(38, 'Adele 19', 1, 7),
(39, 'Adele 25', 0, 7),
(40, 'Adele 16', 0, 7),
(41, 'Sam Smith', 0, 8),
(42, 'Adele', 1, 8),
(43, 'Ed sheren', 0, 8),
(44, 'California', 1, 9),
(45, 'chicago', 0, 9),
(46, 'new york', 0, 9),
(47, '2017', 1, 35),
(48, '2018', 0, 35),
(49, '2019', 0, 35),
(50, 'Easy on me', 0, 34),
(51, 'hello', 0, 34),
(52, 'Rolling in the deep', 1, 34),
(53, 'shoulder', 0, 36),
(54, 'my beating heart', 1, 36),
(55, 'knee', 0, 36),
(56, 'Sam Smith', 1, 37),
(57, 'Adele', 0, 37),
(58, 'Ed sheren', 0, 37);

-- --------------------------------------------------------

--
-- Structure de la vue `Affichage_Joueur_Match_Score`
--
DROP TABLE IF EXISTS `Affichage_Joueur_Match_Score`;

CREATE ALGORITHM=UNDEFINED DEFINER=`zliheouch`@`%` SQL SECURITY DEFINER VIEW `Affichage_Joueur_Match_Score`  AS SELECT `T_JOUEUR_JOU`.`jou_pseudo` AS `Jou_pseudo`, `T_MATCH_MAT`.`mat_intitule` AS `mat_intitule`, `T_JOUEUR_JOU`.`jou_score` AS `jou_score` FROM (`T_JOUEUR_JOU` join `T_MATCH_MAT` on(`T_JOUEUR_JOU`.`mat_id` = `T_MATCH_MAT`.`mat_id`))  ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `T_COMPTE_CPT`
--
ALTER TABLE `T_COMPTE_CPT`
  ADD PRIMARY KEY (`cpt_id`);

--
-- Index pour la table `T_JOUEUR_JOU`
--
ALTER TABLE `T_JOUEUR_JOU`
  ADD PRIMARY KEY (`jou_id`),
  ADD KEY `fk_T_JOUEUR_JOU_T_MATCH_MAT1_idx` (`mat_id`);

--
-- Index pour la table `T_MATCH_MAT`
--
ALTER TABLE `T_MATCH_MAT`
  ADD PRIMARY KEY (`mat_id`),
  ADD UNIQUE KEY `mat_code_UNIQUE` (`mat_code`),
  ADD KEY `fk_T_MATCH_MAT_T_COMPTE_CPT1_idx` (`cpt_id`),
  ADD KEY `fk_T_MATCH_MAT_T_QUIZ_QUI1_idx` (`qui_id`);

--
-- Index pour la table `T_NEWS_NEW`
--
ALTER TABLE `T_NEWS_NEW`
  ADD PRIMARY KEY (`new_id`),
  ADD KEY `fk_T_NEWS_NEW_T_COMPTE_CPT1_idx` (`cpt_id`);

--
-- Index pour la table `T_PROFIL_PFL`
--
ALTER TABLE `T_PROFIL_PFL`
  ADD PRIMARY KEY (`cpt_id`);

--
-- Index pour la table `T_QUESTION_QUE`
--
ALTER TABLE `T_QUESTION_QUE`
  ADD PRIMARY KEY (`que_id`),
  ADD KEY `fk_T_QUESTION_QUS_T_QUIZ_QUI1_idx` (`qui_id`);

--
-- Index pour la table `T_QUIZ_QUI`
--
ALTER TABLE `T_QUIZ_QUI`
  ADD PRIMARY KEY (`qui_id`),
  ADD KEY `fk_T_QUIZ_QUI_T_COMPTE_CPT1_idx` (`cpt_id`);

--
-- Index pour la table `T_REPONSE_REP`
--
ALTER TABLE `T_REPONSE_REP`
  ADD PRIMARY KEY (`rep_id`),
  ADD KEY `fk_T_REPONSE_REP_T_QUESTION_QUS1_idx` (`que_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `T_COMPTE_CPT`
--
ALTER TABLE `T_COMPTE_CPT`
  MODIFY `cpt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT pour la table `T_JOUEUR_JOU`
--
ALTER TABLE `T_JOUEUR_JOU`
  MODIFY `jou_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT pour la table `T_MATCH_MAT`
--
ALTER TABLE `T_MATCH_MAT`
  MODIFY `mat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT pour la table `T_NEWS_NEW`
--
ALTER TABLE `T_NEWS_NEW`
  MODIFY `new_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT pour la table `T_PROFIL_PFL`
--
ALTER TABLE `T_PROFIL_PFL`
  MODIFY `cpt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pour la table `T_QUESTION_QUE`
--
ALTER TABLE `T_QUESTION_QUE`
  MODIFY `que_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT pour la table `T_QUIZ_QUI`
--
ALTER TABLE `T_QUIZ_QUI`
  MODIFY `qui_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `T_REPONSE_REP`
--
ALTER TABLE `T_REPONSE_REP`
  MODIFY `rep_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `T_JOUEUR_JOU`
--
ALTER TABLE `T_JOUEUR_JOU`
  ADD CONSTRAINT `fk_T_JOUEUR_JOU_T_MATCH_MAT1` FOREIGN KEY (`mat_id`) REFERENCES `T_MATCH_MAT` (`mat_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_MATCH_MAT`
--
ALTER TABLE `T_MATCH_MAT`
  ADD CONSTRAINT `fk_T_MATCH_MAT_T_COMPTE_CPT1` FOREIGN KEY (`cpt_id`) REFERENCES `T_COMPTE_CPT` (`cpt_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_T_MATCH_MAT_T_QUIZ_QUI1` FOREIGN KEY (`qui_id`) REFERENCES `T_QUIZ_QUI` (`qui_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_NEWS_NEW`
--
ALTER TABLE `T_NEWS_NEW`
  ADD CONSTRAINT `fk_T_NEWS_NEW_T_COMPTE_CPT1` FOREIGN KEY (`cpt_id`) REFERENCES `T_COMPTE_CPT` (`cpt_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_PROFIL_PFL`
--
ALTER TABLE `T_PROFIL_PFL`
  ADD CONSTRAINT `fk_T_PROFIL_PFL_T_COMPTE_CPT1` FOREIGN KEY (`cpt_id`) REFERENCES `T_COMPTE_CPT` (`cpt_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_QUESTION_QUE`
--
ALTER TABLE `T_QUESTION_QUE`
  ADD CONSTRAINT `fk_T_QUESTION_QUS_T_QUIZ_QUI1` FOREIGN KEY (`qui_id`) REFERENCES `T_QUIZ_QUI` (`qui_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_QUIZ_QUI`
--
ALTER TABLE `T_QUIZ_QUI`
  ADD CONSTRAINT `fk_T_QUIZ_QUI_T_COMPTE_CPT1` FOREIGN KEY (`cpt_id`) REFERENCES `T_COMPTE_CPT` (`cpt_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `T_REPONSE_REP`
--
ALTER TABLE `T_REPONSE_REP`
  ADD CONSTRAINT `fk_T_REPONSE_REP_T_QUESTION_QUS1` FOREIGN KEY (`que_id`) REFERENCES `T_QUESTION_QUE` (`que_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
