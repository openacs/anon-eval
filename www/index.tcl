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

#if { $admin_p } {
#    ad_return_complaint 1 "[_ anon-eval.permission_denied]"
#    ad_script_abort
#}

# create a list with all open assessments
template::list::create \
    -name assessments \
    -multirow assessments \
    -key assessment_id \
    -elements {
        title {
            label "[_ anon-eval.Open_Evaluations]"
            display_template {<a href="@assessments.assessment_url@">@assessments.title@</a>}
        }
    } -main_class {
        narrow
    }

# get the information of all open assessments
template::multirow create assessments assessment_id title description assessment_url
db_foreach open_asssessments {} {
    if {([empty_string_p $start_time] || $start_time <= $cur_time) && ([empty_string_p $end_time] || $end_time >= $cur_time)} {
	if {[empty_string_p $password]} {
	    set assessment_url [export_vars -base "assessment" {assessment_id}]
	} else {
	    set assessment_url [export_vars -base "assessment-password" {assessment_id}]
	}
	template::multirow append assessments $assessment_id $title $description $assessment_url
    }
}

# create a list with all answered assessments and their sessions
template::list::create \
    -name sessions \
    -multirow sessions \
    -key assessment_id \
    -elements {
        title {
            label "[_ assessment.Assessments]"
            display_template {@sessions.title@}
        }
        edit {
	    display_template {<center><a href=assessment?assessment_id=@sessions.assessment_id@&session_id=@sessions.session_id@><img border=0 src=/resources/Edit16.gif></a></center>}
        }
        view {
	    display_template {<center><a href=session?assessment=@sessions.assessment_id@&session_id=@sessions.session_id@><img border=0 src=/resources/Zoom16.gif></a></center>}
        }

    } -main_class {
        narrow
    }

# get the information of all assessments store in the database

db_multirow -extend { session_id } sessions answered_asssessments {} {
    as::assessment::data -assessment_id $assessment_id
    set assessment_rev_id $assessment_data(assessment_rev_id)
    set session_id [db_string last_session {select max(session_id) as session_id from as_sessions where assessment_id = :assessment_rev_id  and subject_id = :user_id}]
    
}

set admin_p [ad_permission_p $package_id create]

ad_return_template
