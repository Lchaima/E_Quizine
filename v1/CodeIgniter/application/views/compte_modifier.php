<?php
if($this->session->userdata('username') == null){
     echo "Session non Ouverte !";
     $this->load->helper('url'); 
     redirect('accueil/afficher'); 
}
?>
<main id="main" class="main">

	<div class="pagetitle">
	  <h1> Menu <?php echo $this->session->userdata('role'); ?> </h1>
	  <nav>
		<ol class="breadcrumb">
		  <li class="breadcrumb-item"><a href="index.html"> Settings account </a></li>
		  <li class="breadcrumb-item active"> Menu <?php echo $this->session->userdata('role'); ?> </li>
		</ol>
	  </nav>
	</div><!-- End Page Title -->

	<section class="section dashboard">
	  <div class="row">
	  	<?php if ($erreur!=NULL ){
          echo '<div class="alert alert-warning">';
          echo '<strong> Warning! </strong>' ; echo $erreur ; 
          echo '</div>' ;
          }

          if($message!= NULL){
          echo '<div class="alert alert-success">';
          echo '<strong> Success! </strong>' ; echo $message ; 
          echo '</div>' ;
          }
          ?>
		<?php echo validation_errors(); ?>
          <?php echo form_open('compte_modifier'); ?>
          <label for="pseudo" > pseudo : </label>
          <br>
          <input type="text" name="pseudo" value ="<?php echo $donnee->cpt_pseudo ; ?>"  class="form-control" >
          <label for="nom" > Nom : </label>
          <br>
          <input type="text" name="nom" value ="<?php  echo $donnee->pfl_nom; ?>" class="form-control" >
          <label for="prenom" > Prenom : </label>
          <br>
          <input type="text" name="prenom" value ="<?php  echo $donnee->pfl_prenom ?>" class="form-control" >
          <label for="mdp" > new password : </label>
          <br>
          <input type="password" name="mdp" class="form-control" >
          <label for="mdp1" > confirmation of new  password : </label>
          <br>
          <input type="password" name="mdp1" class="form-control" >
        <br>
          <button type="submit" name="submit" value="modifier mot de passe" class="btn btn-primary"> confirm !</button>
          <a href="<?php echo $this->config->base_url();?>index.php/compte/afficher" class="btn btn-primary" role="button" aria-pressed="true"> cancel ! </a>
          </form>
	  </div>
	</section>