<div class="container">
<div class="row align-self-center"> 
<div class="card">
    <div class="card-body">
      <h5 class="card-title"> log in </h5>
      <div class="container">
      	<div class="row justify-content-center" >
      <!-- Horizontal Form -->
       <?php 
        if($erreur != NULL) {
         echo '<div class="alert alert-danger">';
          echo '<strong>Warning!</strong>' ; echo $erreur ; 
          echo '</div>' ;
          }
        ?>
      <?php echo validation_errors(); ?>
	    <?php echo form_open('compte/connecter'); ?>
        <div class="row mb-3 ">
          <label for="pseudo" class="col-sm-2 col-form-label">Your Pseudo</label>
          <div class="col-sm-10">
            <input type="text" name="pseudo" class="form-control" >
          </div>
        </div>
        <div class="row mb-3">
          <label for="mdp" class="col-sm-2 col-form-label">Password</label>
          <div class="col-sm-10">
            <input type="password" name="mdp" class="form-control">
          </div>
        </div>
        <div class="text-center">
          <button type="submit" value="Connexion" class="btn btn-primary"> log in </button>
        </div>
      	</form><!-- End Horizontal Form -->
      </div>
  	</div>
    </div>
</div>
</div>
</div>