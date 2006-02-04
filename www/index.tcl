ad_page_contract {

	Lists all the assessments that can be taken and their sessions.

	@author Eduardo Pérez Ureta (eperez@it.uc3m.es)
	@creation-date 2004-09-03
} {
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set page_title "[_ anon-eval.Show_Evaluations]"
set context_bar [list]
set package_id [ad_conn package_id]
set folder_id [as::assessment::folder_id -package_id $package_id]
set user_id [ad_conn user_id]
set admin_p [permission::permission_p -privilege admin -object_id [ad_conn package_id]]