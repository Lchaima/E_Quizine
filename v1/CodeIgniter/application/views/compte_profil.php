<?php
if($this->session->userdata('username') == null){
     echo "Session non Ouverte !";
     $this->load->helper('url'); 
     redirect('accueil/afficher'); 
}
?>
<main id="main" class="main">

	<div class="pagetitle">
	  <h1>Espace <?php echo $this->session->userdata('role'); ?> </h1>
	  <nav>
		<ol class="breadcrumb">
		  <li class="breadcrumb-item"><a href="index.html"> Profil</a></li>
		  <li class="breadcrumb-item active">Espace <?php echo $this->session->userdata('role'); ?> </li>
		</ol>
	  </nav>
	</div><!-- End Page Title -->

	<section class="section dashboard">
	  <div class="row">
		<ul class="list-group">
		  <li class="list-group-item"> <span> Pseudo : </span> <?php echo $donnee->cpt_pseudo ?> </li>
		  <li class="list-group-item"> <span> Nom : </span> <?php echo $donnee->pfl_nom ?> </li>
		  <li class="list-group-item"> <span> Prenom : </span> <?php echo $donnee->pfl_prenom ?> </li>
		  <li class="list-group-item"> <span> Email : </span> <?php echo $donnee->pfl_mail ?> </li>
		</ul> 

		<a href="<?php echo $this->config->base_url();?>index.php/compte/modifier" class="btn btn-primary btn-lg active" role="button" aria-pressed="true">data Settings </a> 
	  </div>
	</section>