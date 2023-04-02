<?php
class Joueur extends CI_Controller {
 
public function __construct()
{
	parent::__construct();
	$this->load->model('db_model');
	$this->load->helper('url');
}


public function ajouter()
{
	
	$this->load->helper('form');
	$this->load->library('form_validation');
	$this->form_validation->set_rules('pseudo', 'pseudo', 'required');
	$data['erreur']=NULL ;
	$code=$this->input->post('code');
	$data['code']=$code ;
	if ($this->form_validation->run() == FALSE)

		{
			$this->load->view('templates/haut');
			$this->load->view('page_pseudo',$data);
			$this->load->view('templates/bas');
		}
		else
		{
			$data['existe']=$this->db_model->verif_pseudo($data['code'])->existe;
			$data['fini']=FALSE ;
			if( $data['existe'] == 0 ){
				$this->db_model->add_joueur();
				$data['Mdonnee']=$this->db_model->get_match($code);
				$this->load->view('templates/haut');
				$this->load->view('afficher_match',$data);
				$this->load->view('templates/bas');
			}else{
				$data['erreur']='this pseudo already exists, please insert another one !';
				$this->load->view('templates/haut');
				$this->load->view('page_pseudo',$data);
				$this->load->view('templates/bas');
			}
		}

}


}
?>