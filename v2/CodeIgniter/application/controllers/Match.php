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
		$data['code']=$code;
		$data['fini']=FALSE ;
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
		 //Chargement de la view haut.php
		 $this->load->view('templates/haut');
		 //Chargement de la view du milieu : afficher_match.php
		 $this->load->view('afficher_match',$data);
		 //Chargement de la view bas.php
		 $this->load->view('templates/bas');
		}
	}

}

public function remettre_zero($code=FALSE){

	$this->db_model->reset_match($code);
	$this->load->view('remettre_zero');

}

public function supprimer($code=FALSE){

	$this->db_model->delete_match($code);
	$this->load->view('supprimer_match');

}

public function activer_desactiver($code=FALSE){

	$this->db_model->activate_desactivate($code);
	$this->load->view('activer_desactiver_match');

}

public function creer(){

		$this->load->helper('form');
		$this->load->library('form_validation');
		$this->form_validation->set_rules('entitled', 'entitled', 'required');
		$this->form_validation->set_rules('etat', 'etat', 'required');

		$this->form_validation->set_rules('date', 'date', 'required');

		$username=$this->session->userdata('username');

		$data["quizs"]=$this->db_model->get_all_quiz();
		$data["message"]=NULL ;

		if ($this->form_validation->run() == FALSE)
		{
			$this->load->view('templates/hautAdmin');
			$this->load->view('templates/menuFormateur');
			$this->load->view('creer_match',$data);
			$this->load->view('templates/basAdmin');
		}else{
			$this->db_model->create_match($username);
			$data["message"]=" match created !";
			$this->load->view('templates/hautAdmin');
			$this->load->view('templates/menuFormateur');
			$this->load->view('creer_match',$data);
			$this->load->view('templates/basAdmin');


		}

	
}

}

?>