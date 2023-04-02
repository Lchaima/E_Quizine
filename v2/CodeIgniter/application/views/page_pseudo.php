

<section id="match" class="services section-bg">
      <div class="container" data-aos="fade-up">
        <?php if ($erreur!=NULL ){
          echo '<div class="alert alert-warning">';
          echo '<strong>Warning! </strong>' ; echo $erreur ; 
          echo '</div>' ;
        } ?>
        <div class="section-title">
          <h2> PSEUDO </h2>
          <p> enter your pseudo  </p>
        </div>
          <?php echo validation_errors(); ?>
          <?php echo form_open('page_pseudo'); ?>
          <label for="pseudo"> Pseudo: </label>
          <input type="input" name="pseudo" class="form-control" >
          <input type="hidden" name="code" value="<?php echo $code ?>">
          <br>
          <button type="submit" name="submit" value="ajouter_pseudo" class="btn btn-primary"> GO !</button>
          </form>
      </div>
</section>
