
<?php
class Accueil extends CI_Controller {
 
public function __construct()
{
	parent::__construct();
	$this->load->model('db_model');
	$this->load->helper('url');
}


public function afficher()
{


    $this->load->helper('form');
	$this->load->library('form_validation');
	$this->form_validation->set_rules('code', 'code', 'required');

	$data['titre']="THE NEWS" ;
	$data['actualite']=$this->db_model->get_all_news();
	$data['erreur']= NULL ;


	if ($this->form_validation->run() == FALSE)

	{
		
		$this->load->view('templates/haut');
		$this->load->view('templates/menu_visiteur');
		$this->load->view('page_accueil',$data);
		$this->load->view('templates/bas');
	}
	else
	{
		$code=$this->input->post('code');
		$data['code']=$code;
		$data['Mdonnee']=$this->db_model->get_match($code);
		$data['verif']=$this->db_model->get_data_match($code);

		if( $data['verif']){

			if($data['verif']->mat_etat =='A' && $data['verif']->mat_debut != null && $data['verif']->mat_fin == null){

				$this->load->view('templates/haut');
				$this->load->view('page_pseudo',$data);
				$this->load->view('templates/bas');

			}else{

				$data['erreur']=" unreachable match !";
				$this->load->view('templates/haut');
				$this->load->view('templates/menu_visiteur');
				$this->load->view('page_accueil',$data);
				$this->load->view('templates/bas');
			}
			
		}else {
				$data['erreur']="there is no match corresponding to this code !";
				$this->load->view('templates/haut');
				$this->load->view('templates/menu_visiteur');
				$this->load->view('page_accueil',$data);
				$this->load->view('templates/bas');
		}
	}

}


}

?>