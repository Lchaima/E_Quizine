
<main id="main" class="main">

    <div class="pagetitle">
      <h1>Form Elements</h1>
      <nav>
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="index.html">Home</a></li>
          <li class="breadcrumb-item">Forms</li>
          <li class="breadcrumb-item active">Elements</li>
        </ol>
      </nav>
    </div><!-- End Page Title -->

    <section class="section">
      <div class="row">
        <div class="col-lg-6">

          <div class="card">
            <div class="card-body">
              <h5 class="card-title"> Create Account </h5>

              <!-- General Form Elements -->
              <?php echo validation_errors(); ?>
              <?php echo form_open('compte_creer'); ?>
                <div class="row mb-3">
                  <label for="id" class="col-sm-3 col-form-label"> Pseudo </label>
                  <div class="col-sm-9">
                    <input type="input" name="id" class="form-control">
                  </div>
                </div>
                <div class="row mb-3">
                  <label for="mdp" class="col-sm-3 col-form-label">Password</label>
                  <div class="col-sm-9">
                    <input type="password" name="mdp" class="form-control">
                  </div>
                </div>
                <div class="row mb-3">
                  <label for="etat" class="col-sm-3 col-form-label"> state </label>
                  <div class="col-sm-9">
                    <input type="input" name="etat" class="form-control">
                  </div>
                </div>
                <div class="row mb-3">
                  <label for="role" class="col-sm-3 col-form-label"> role </label>
                  <div class="col-sm-9">
                    <input type="input" name="role" class="form-control">
                  </div>
                </div>
                <div class="row mb-3">
                  <div class="col-sm-10">
                    <button type="submit" name="submit" value="Créer un compte" class="btn btn-primary"> Create account</button>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
       </div>
    </section>

  </main