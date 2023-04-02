
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
  			<strong>Success!</strong> Form completed, data entered in the database!
  			<?php
			echo $message;
			echo $le_nombre->number_accounts;
			?>
		</div>
      </div>
    </section>

 </main>