ad_page_contract {

    Presents a form to upload a QTI ZIP file,
    lists all assessments and shows a link to 
    assessment editor and another to assessment
    catalog.
    
    @author eperez@it.uc3m.es
    @creation-date 2004-09-21
} {
} -properties {
    zipfile
    context:onevalue
}
set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
set title "[_ assessment.Administration]"
set context [list "[_ assessment.admin]"]
set package_id [ad_conn package_id]
set categories_url [db_string get_category_url {}]
set user_id [ad_conn user_id]
set package_admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege "admin"]
set dotlrn_admin_p [dotlrn::admin_p]

if { !$dotlrn_admin_p } {
    ad_return_complaint 1 "[_ anon-eval.admin_permission_denied]"
    ad_script_abort
}


if { $package_admin_p == 0} {
    set m_name "get_all_assessments_admin"
} else {
    set m_name "get_all_assessments"
}

#form to upload a QTI ZIP file
ad_form -name form_upload_file -action {unzip-file} -html {enctype multipart/form-data}  -form {
    {zipfile:file {label "[_ assessment.Import_QTI_ZIP_File]"}}
}

set actions [list "[_ anon-eval.New_Evaluation]" assessment-form "[_ anon-eval.lt_Create_New_Evaluation]"]

if {[ad_permission_p [acs_magic_object "security_context_root"] "admin"]} {
    # lappend actions "[_ assessment.Admin_catalog]" "catalog/" "[_ assessment.Admin_catalog]"
}

#get all assessments order by title
db_multirow -extend { export permissions admin_request} assessments $m_name {} {
    set export "[_ assessment.Export]"
    set permissions "[_ assessment.permissions]"
    set admin_request "[_ assessment.Request] [_ assessment.Administration]"
}

#list all assessments
list::create \
    -name assessments \
    -key assessment_id \
    -no_data "[_ assessment.None]" \
    -elements {
	title {
	    label "[_ assessment.Title]"
	    display_template { <center><a href=[export_vars -base one-a { assessment_id }]>@assessments.title@</a></center>}
	}
	
    } -actions $actions

ad_return_template
