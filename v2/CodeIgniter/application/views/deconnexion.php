<?php
if($this->session->userdata('username') == null){
     echo "Session non Ouverte !";
     $this->load->helper('url'); 
     redirect('accueil/afficher'); 
}

$this->load->helper('url');
$this->session->sess_destroy();
redirect('compte/connecter');
?>
	
