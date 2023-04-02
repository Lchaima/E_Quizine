<main id="main">

    <!-- ======= About Section ======= -->
    <section id="about" class="about">
      <div class="container">

        <div class="row">
          <div class="col-lg-6 order-1 order-lg-2" data-aos="zoom-in" data-aos-delay="150">
            <img src="<?php echo $this->config->base_url();?>images/assets/img/about.jpg" class="img-fluid" alt="">
          </div>
          <div class="col-lg-6 pt-4 pt-lg-0 order-2 order-lg-1 content" data-aos="fade-right">  
            <h3><?php echo $titre;?></h3>
            <br />
            <?php
            if(isset($actu)) {
              echo $actu->new_id;
              echo(" -- ");
              echo $actu->new_description;
            }
            else {echo "<br />";
              echo "pas d’actualité !";
            }
            ?>
             
          </div>
        </div>

      </div>
    </section><!-- End About Section -->
</main>