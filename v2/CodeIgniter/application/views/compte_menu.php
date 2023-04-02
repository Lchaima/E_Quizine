<?php
if($this->session->userdata('username') == null){
     echo "Session non Ouverte !";
     $this->load->helper('url'); 
     redirect('accueil/afficher'); 
}
?>
<main id="main" class="main">

	<div class="pagetitle">
	  <h1>Dashboard</h1>
	  <nav>
		<ol class="breadcrumb">
		  <li class="breadcrumb-item"><a href="index.html">Home</a></li>
		  <li class="breadcrumb-item active">Dashboard</li>
		</ol>
	  </nav>
	</div><!-- End Page Title -->

	<section class="section dashboard">
	  <div class="row">
		<div class="alert alert-success">
			<h2>Espace d'administration</h2>
			<br />
			<h2>Session ouverte ! Bienvenue
			<?php
			echo $this->session->userdata('username');
			?> 
			</h2>
		</div>
	  </div>
	</section>
