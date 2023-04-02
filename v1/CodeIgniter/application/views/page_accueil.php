

<!-- ======= Welcome Section ======= -->
  <section id="hero" class="d-flex align-items-center">

    <div class="container-fluid" data-aos="fade-up">
      <div class="row justify-content-center">
        <div class="col-xl-5 col-lg-6 pt-3 pt-lg-0 order-2 order-lg-1 d-flex flex-column justify-content-center">
          <h1> Guess the 2000's Song </h1>
          <h2> Test your musical culture online by taking part in quizzes. There are several types, choose your favorite and go for it.</h2>
          <div><a href=#match class="btn-get-started scrollto">Get Started</a></div>
        </div>
        <div class="col-xl-4 col-lg-6 order-1 order-lg-2 hero-img" data-aos="zoom-in" data-aos-delay="150">
          <img src="<?php echo $this->config->base_url();?>images/hero-img.png" class="img-fluid animated" alt="">
        </div>
      </div>
    </div>
   </section><!-- Welcome Section -->

  <section id="match" class="services section-bg">
      <div class="container" data-aos="fade-up">
        <?php if($erreur != NULL) {
         echo '<div class="alert alert-danger">';
          echo '<strong>Warning!</strong>' ; echo $erreur ; 
          echo '</div>' ;
          }
        ?>
        <div class="section-title">
          <h2> MATCH </h2>
          <p> enter a valid code to participate in a match </p>
          <br>
          <?php echo validation_errors(); ?>
          <?php echo form_open('page_accueil'); ?>
          <label for="code" > Code: </label>
          <br>
          <input type="input" name="code" class="form-control" >
        <br>
          <button type="submit" name="submit" value="afficher code" class="btn btn-primary"> GO !</button>
          </form>
      </div>
   </section>

  <!-- ======= News Section ======= -->
    <section id="News" class="features">
      <div class="container" data-aos="fade-up">

        <div class="section-title">
          <h2> <?php echo $titre ?> </h2>
          <p class="lead"> Don't miss anything , look here for all the news about your favorit quizzes ! </p>
        </div>
        <div class="row">
        	<table class="table table-hover">
			    <thead>
			      <tr>
			        <th> TITLE </th>
			        <th> DESCRIPTION </th>
			        <th> DATE </th>
			        <th> Publisher </th>
			      </tr>
			    </thead>
			    <tbody>
			      <tr>
			      	<?php
			      	if($actualite != NULL) {
						foreach($actualite as $news){
						echo "<tr>";
					        echo"<td>"; echo "<a href=".$this->config->base_url()."index.php/actualite/afficher/".$news["new_id"].">"; 
					        echo $news["new_intitule"]; echo "</td>" ;
					        echo"<td>".$news["new_description"]."</td>" ;
					        echo"<td>".$news["new_date"]."</td>" ;
					        echo"<td>".$news["cpt_pseudo"]."</td>" ;
					    echo "</a>" ;
					    echo "</tr>" ;
					    }
					}else{
						echo "<h3> There is no news yet ! </h3>" ;
					}
			        ?>
			      </tr>			        
			    </tbody>
		    </table>						
        </div>

      </div>
    </section><!-- End News Section -->

    



