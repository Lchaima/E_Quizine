<main id="main">
    <section id="services" class="services section-bg">
      <div class="container" data-aos="fade-up"> 
        <?php
        if($Mdonnee){ 
          foreach($Mdonnee as $d){
            if (!isset($traite[$d["mat_intitule"]]) && !isset($traite[$d["qui_intitule"]])) {
              echo '<div class="section-title">';
              echo "<h2>"; echo $d['mat_intitule'];  echo"</h2>"; 
              echo '<div class="col-sm-12">';
              echo "<h3> associated QUIZ  : "; echo $d['qui_intitule'];  echo"</h3>";  
              echo "<h3> code  : "; echo $code ; echo"</h3>"; 
              echo "</div>";
              echo "</div>";
              foreach($Mdonnee as $m){
                if (!isset($traite[$m["que_intitule"]])){
                  $que_texte=$m["que_intitule"];
                  echo '<div class="row gy-4">';
                  echo '<ul class="list-group">';
                  echo '<li class="list-group-item">';echo $m['que_intitule']; echo'</li> ';
                    foreach($Mdonnee as $md){
                      echo "<ul>";
                      if(strcmp($que_texte,$md["que_intitule"])==0){
                        echo "<li>";
                        echo $md["rep_texte"];
                        echo "</li>";
                      }
                      echo "</ul>";
                    }
                  echo '</ul>';
                  $traite[$m["que_intitule"]]=1;
                  echo "</div>";
                }
              }
              $traite[$d["mat_intitule"]]=1;
              $traite[$d["qui_intitule"]]=1;
            }
          }
        }else{
          echo '<div class="row gy-4">';
          echo " there is no match corresponding to this code !";
          echo "</div>";
      }
      echo "<br>" ;
      if ($fini){
          echo '<div class="container">
                <div class="row">
               <div class="col-sm-12">
                    <div class="card border-info mb-3" style="max-width: 18rem;">
                    <div class="card-header">SCORE</div>
                    <div class="card-body text-info">
                        <p class="card-text">'.$score->score.'<span> % </span> </p>
                   </div>
                  </div>
                </div>
                </div>
                </div> ';
      }else{ 
       if ($this->session->userdata('role') == 'F'){
          echo '<button type="button" class="btn btn-success"> Terminer </button>';
        }
      }
      ?>        
      </div>
    </section><!-- End Services Section -->
</main>
