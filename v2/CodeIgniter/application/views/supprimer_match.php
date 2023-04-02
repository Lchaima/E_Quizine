<?php
if($this->session->userdata('username') == null){
     $this->load->helper('url'); 
     redirect('accueil/afficher'); 
}else{
$this->load->helper('url');
redirect('compte/afficher_matchs');
}
?>