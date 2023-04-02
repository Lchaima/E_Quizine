<?php
if($this->session->userdata('username') == null){
     echo "Session non Ouverte !";
     $this->load->helper('url'); 
     redirect('accueil/afficher'); 
}
?>

<main id="main" class="main">

	<div class="pagetitle">
	  <h1>Espace Formateur</h1>
	  <nav>
		<ol class="breadcrumb">
		  <li class="breadcrumb-item"><a href="index.html"> Match </a></li>
		  <li class="breadcrumb-item active">Espace Formateur</li>
		</ol>
	  </nav>
	</div><!-- End Page Title -->

	<section class="section dashboard">
		<div class="row">
		<div class="container">
	  	<h2> the list of match </h2> 
	  	<br> 
	  	<?php 
	  	 if ($this->session->userdata('role') == 'F'){
	  	 echo "<a href=".$this->config->base_url()."index.php/match/creer >";
		 echo '<button type="button" class="btn btn-primary"> <i class="bi bi-plus-square-fill"></i> create match </button>' ;
		 echo "</a>";
		}
		?>
	  	<table class="table table-condensed">
	    <thead>
	      <tr>
	        <th> QUIZ </th>
	        <th> QUIZ AUTHOR </th>
	        <th> MATCH ENTITLED </th>
	        <th> MATCH AUTHOR </th>
	        <th> DATE BEGIN + DATE END</th>
	        <th> ACTIONS </th>
	      </tr>
	    </thead>
	    <tbody>
	      	<?php
			      	if($match_donnee != NULL) {
						foreach($match_donnee as $match){
						if (strcmp($match['match_auteur'],$this->session->userdata('username')) != 0 )
						{
						echo "<tr>";
							echo "<td>".$match["qui_intitule"]."</td>" ;
							echo "<td>".$match["quiz_auteur"]."</td>" ;
							if ($match["mat_intitule"] != NULL) {
					        echo "<td>";  echo $match["mat_intitule"];  echo "</td>" ;
					        echo "<td>".$match["match_auteur"]."</td>" ;
					        echo "<td>"; echo" commence le ".$match["mat_debut"]." fini le ".$match["mat_fin"]."</td>" ;
					    	}
					    echo "</tr>" ;
					    }else{
					    echo "<tr>";
							echo "<td>".$match["qui_intitule"]."</td>" ;
							echo "<td>".$match["quiz_auteur"]."</td>" ;
							if ($match["mat_intitule"] != NULL) {
					        echo "<td>"; echo "<a href=".$this->config->base_url()."index.php/match/afficher/".$match['mat_code']." >";
					        echo $match["mat_intitule"]; echo"</a>"; echo "</td>" ;
					        echo "<td>".$match["match_auteur"]."</td>" ;
					        echo "<td>"; echo" commence le ".$match["mat_debut"]." fini le ".$match["mat_fin"]."</td>" ;
					        echo "<td>"; echo '<div class="btn-group btn-group-sm" role="group" aria-label="Basic example">';
					        if ($match["mat_etat"]== 'A'){
					        	echo"<a href=".$this->config->base_url()."index.php/match/activer_desactiver/".$match['mat_code']." >" ;
  								echo '<button type="button" class="btn btn-secondary"> <i class="bi bi-toggle-on"></i> desactivate </button> </a>';
  							}else{
  								echo"<a href=".$this->config->base_url()."index.php/match/activer_desactiver/".$match['mat_code']." >" ;
  								echo '<button type="button" class="btn btn-secondary"> <i class="bi bi-toggle-on"></i> activate </button> </a>';
  							}
  							echo"<a href=".$this->config->base_url()."index.php/match/remettre_zero/".$match['mat_code']." >" ;
  							 echo'<button type="submit" name="submit" value="remttre a zero" class="btn btn-secondary"><i class="bi bi-arrow-clockwise"></i> resete </button></a>';
  							echo"<a href=".$this->config->base_url()."index.php/match/supprimer/".$match['mat_code']." >" ;
  							echo '<button type="submit" name="submit" value="supprimer match" class="btn btn-secondary"> <i class="bi bi-trash3-fill"></i> delete </button></a>';
							echo '</div>' ;
							echo "</td>";
						}
					    echo "</tr>" ;
					    }
						}
					}else{
						echo "<h3> There is no Match yet ! </h3>" ;
					}
			 ?>
	    </tbody>
	  </table>
	</div>

		  </div>
	</section>