<?php
class Match extends CI_Controller {
 
public function __construct()
{
	parent::__construct();
	$this->load->model('db_model');
	$this->load->helper('url_helper');
}


public function afficher($code=FALSE)
{

	if ($code==FALSE){
		$url=base_url(); header("Location:$url");
	}else{
		$data['Mdonnee'] = $this->db_model->get_match($code);	
		$data['date'] = $this->db_model->get_data_match($code);	
		if($data['date']->mat_fin != NULL){
		 $data['fini']=TRUE ;
		 $data['score']=$this->db_model->get_score($code);
		 //Chargement de la view haut.php
		 $this->load->view('templates/haut');
		 //Chargement de la view du milieu : afficher_match.php
		 $this->load->view('afficher_match',$data);
		 //Chargement de la view bas.php
		 $this->load->view('templates/bas');
		}else{
		  $data['fini']=FALSE ;
		 //Chargement de la view haut.php
		 $this->load->view('templates/haut');
		 //Chargement de la view du milieu : afficher_match.php
		 $this->load->view('afficher_match',$data);
		 //Chargement de la view bas.php
		 $this->load->view('templates/bas');
		}
	}

}

}

?>