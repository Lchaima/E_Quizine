<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Compte extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
		$this->load->model('db_model');
		$this->load->helper('url_helper');
	}
	public function lister()
	{
		$data['titre'] = 'List of pseudos :';
		$data['pseudos'] = $this->db_model->get_all_compte();
		$data['nombre'] = $this->db_model->get_number_compte();
		
		$this->load->view('templates/hautAdmin');
		$this->load->view('templates/menuAdmin');
		$this->load->view('compte_liste',$data);
		$this->load->view('templates/basAdmin');
	}
	public function creer()
	{
		$this->load->helper('form');
		$this->load->library('form_validation');

		$this->form_validation->set_rules('id', 'id', 'required');
		$this->form_validation->set_rules('mdp', 'mdp', 'required');
		$this->form_validation->set_rules('etat', 'etat', 'required');
		$this->form_validation->set_rules('role','role','required');

		if ($this->form_validation->run() == FALSE)
		{
			$this->load->view('templates/hautAdmin');
			$this->load->view('templates/menuAdmin');
			$this->load->view('compte_creer');
			$this->load->view('templates/basAdmin');
		}
		else
		{
			$this->db_model->set_compte();
			$data['message']=" a new number of accounts ";
			$data['le_nombre']=$this->db_model->get_number_compte();
			$this->load->view('templates/hautAdmin');
			$this->load->view('templates/menuAdmin');
			$this->load->view('compte_success',$data);
			$this->load->view('templates/basAdmin');
		}
	}
	public function connecter(){



		$this->load->helper('form');
		$this->load->library('form_validation');
		$this->form_validation->set_rules('pseudo', 'pseudo', 'required');
		$this->form_validation->set_rules('mdp', 'mdp', 'required');
		$data['erreur']=NULL;

		if ($this->form_validation->run() == FALSE)
		{
			$this->load->view('templates/hautAdmin');
			$this->load->view('compte_connecter',$data);
			$this->load->view('templates/basAdmin');
		}
		else
		{
			
			$username = $this->input->post('pseudo');
			$password = $this->input->post('mdp');
			$salt = "OnRajouteDuSelPourAllongerleMDP123!!45678__Test";
			$password_hash=hash('sha256', $salt.$password);
			if($this->db_model->connect_compte($username,$password_hash))
			{
				$role=$this->db_model->role_compte($username);
				$etat=$this->db_model->state_compte($username);
				$role1=$role->cpt_role ;
				$session_data = array('username' => $username , 'role' => $role1);
				$this->session->set_userdata($session_data);
				if ($etat->cpt_etat == 'A'){
					if ($role->cpt_role == 'A'){
						$this->load->view('templates/hautAdmin');
						$this->load->view('templates/menuAdmin');
						$this->load->view('compte_menu');
						$this->load->view('templates/basAdmin');
					}
					else
					{
						$this->load->view('templates/hautAdmin');
						$this->load->view('templates/menuFormateur');
						$this->load->view('compte_menu');
						$this->load->view('templates/basAdmin');

					}
				}
				else
				{
					$data['erreur']=" account disabled ! " ;
					$this->load->view('templates/hautAdmin');
					$this->load->view('compte_connecter',$data);
					$this->load->view('templates/basAdmin');

				}
			}
			else
			{
				$data['erreur']=" invalid pseudo and password " ;
				$this->load->view('templates/hautAdmin');
				$this->load->view('compte_connecter',$data);
				$this->load->view('templates/basAdmin');
			}
		}
	}


	public function afficher(){

		$pseudo=$this->session->userdata('username');
		$role=$this->session->userdata('role');
		$data['donnee']=$this->db_model->get_compte($pseudo);
		if ($role=='A'){
			$this->load->view('templates/hautAdmin');
			$this->load->view('templates/menuAdmin');
			$this->load->view('compte_profil',$data);
			$this->load->view('templates/basAdmin');
		}else{
			$this->load->view('templates/hautAdmin');
			$this->load->view('templates/menuFormateur');
			$this->load->view('compte_profil',$data);
			$this->load->view('templates/basAdmin');
		}
	}

	public function modifier(){


		$this->load->helper('form');
		$this->load->library('form_validation');
		$this->form_validation->set_rules('pseudo', 'pseudo', 'required');
		$this->form_validation->set_rules('nom', 'nom', 'required');
		$this->form_validation->set_rules('prenom', 'prenom', 'required');
		$this->form_validation->set_rules('mdp', 'mdp', 'required');
		$this->form_validation->set_rules('mdp1', 'mdp1', 'required');

		$pseudo=$this->session->userdata('username');
		$role=$this->session->userdata('role');
		$data['donnee']=$this->db_model->get_compte($pseudo);
		$data['message']=NULL;
		$data['erreur']=NULL;
		$mdp= $this->input->post('mdp');
		$mdp1= $this->input->post('mdp1');
		$salt = "OnRajouteDuSelPourAllongerleMDP123!!45678__Test";

		if ($this->form_validation->run() == FALSE)
		{
			$this->load->view('templates/hautAdmin');
			if( $role == 'F'){
				$this->load->view('templates/menuFormateur');
			}else{
				$this->load->view('templates/menuAdmin');
			}
			$this->load->view('compte_modifier',$data);
			$this->load->view('templates/basAdmin');
		}else{

			if(strcmp($mdp,$mdp1) == 0){
				$data["message"]=" password is modified succefully";
				$password_hash=hash('sha256',$salt.$mdp);
				$this->db_model->update_password($pseudo,$password_hash);
				$this->load->view('templates/hautAdmin');
				if( $role == 'F'){
					$this->load->view('templates/menuFormateur');
				}else{
					$this->load->view('templates/menuAdmin');
				}
				$this->load->view('compte_modifier',$data);
				$this->load->view('templates/basAdmin');

			}else{
				$data["erreur"]=" the 2 passwords are not the same";
				$this->load->view('templates/hautAdmin');
				if($this->session->userdata('role')  == 'F'){
					$this->load->view('templates/menuFormateur');
				}else{
					$this->load->view('templates/menuAdmin');
				}
				$this->load->view('compte_modifier',$data);
				$this->load->view('templates/basAdmin');
			}
		}
		

		

	}

	public function deconnecter(){

			$this->load->view('templates/hautAdmin');
			if($this->session->userdata('role')  == 'F'){
				$this->load->view('templates/menuFormateur');
			}else{
				$this->load->view('templates/menuAdmin');
			}
			$this->load->view('deconnexion');
			$this->load->view('templates/basAdmin');

	}

	public function afficher_matchs(){

		$data['match_donnee']=$this->db_model->get_all_matchs() ;
		
		$this->load->view('templates/hautAdmin');
		if($this->session->userdata('role')  == 'F'){
			$this->load->view('templates/menuFormateur');
		}else{
			$this->load->view('templates/menuAdmin');
		}
		$this->load->view('afficher_matchs',$data);
		$this->load->view('templates/basAdmin');
	}


}
?>