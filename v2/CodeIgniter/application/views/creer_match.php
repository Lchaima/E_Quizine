<?php
if($this->session->userdata('username') == null){
     $this->load->helper('url'); 
     redirect('accueil/afficher'); 
}
?>
<main id="main" class="main">

    <div class="pagetitle">
      <h1> Match </h1>
      <nav>
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="index.html">Home</a></li>
          <li class="breadcrumb-item"> Match </li>
          <li class="breadcrumb-item active"> Create Match </li>
        </ol>
      </nav>
    </div><!-- End Page Title -->

    <section class="section">
      <div class="row">
        <div class="col-lg-6">

          <div class="card">
              <?php if($message != NULL){ ?>
              <div class="alert alert-success">
              <strong>Success!</strong>
              <?php
                echo $message;
                echo "</div>" ;
               }
              ?>
            <div class="card-body">
              <h5 class="card-title"> Create Match </h5>

              <!-- General Form Elements -->
              <?php echo validation_errors(); ?>
              <?php echo form_open('creer_match'); ?>
                <div class="row mb-3">
                  <label for="entitled" class="col-sm-3 col-form-label"> Entitled </label>
                  <div class="col-sm-9">
                    <input type="input" name="entitled" class="form-control">
                  </div>
                </div>
                <div class="row mb-3">
                  <label for="quiz" class="col-sm-3 col-form-label"> Quiz </label>
                  <div class="col-sm-9">
                    <select name="quiz" id="quiz">               
                    <?php 
                    if($quizs)
                    {
                        foreach($quizs as $quiz)
                        {
                    ?>
                    <?php echo "<option value='".$quiz["qui_intitule"]."'>" ?> <?php echo $quiz["qui_intitule"]; ?></option>  
                    <?php
                      } 
                    }           
                    ?>
                   </select>
                  </div>
                </div>
                <div class="row mb-3">
                  <label for="etat" class="col-sm-3 col-form-label"> state </label>
                  <div class="col-sm-9">
                   <select name="etat" id="etat">
                   		<option value='A'> A </option> 
                   		<option value='D'> D </option> 
                   </select>
                  </div>
                </div>
                <div class="row mb-3">
                  <label for="date" class="col-sm-3 col-form-label"> start date  </label>
                  <div class="col-sm-9">
                    <input type="date" name="date" class="form-control">
                  </div>
                </div>
                <div class="row mb-3">
                  <div class="col-sm-10">
                    <button type="submit" name="submit" value="Créer un compte" class="btn btn-primary"> Create match </button>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
       </div>
    </section>

  </main