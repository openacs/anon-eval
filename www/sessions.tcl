ad_page_contract {

        Lists the identifier of sessions, the name of subjects that took
	this assessment, the name of assessment and the finish time 
	of assessment for an assessment.

	@author Eduardo Pérez Ureta (eperez@it.uc3m.es)
	@creation-date 2004-09-03
} {
    assessment_id:notnull
    {subject_id:integer,optional ""}
    {admin_sessions hide}
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set page_title "[_ assessment.Show_Sessions]"
set context_bar [ad_context_bar $page_title]
set format "[lc_get formbuilder_date_format], [lc_get formbuilder_time_format]"
set user_id [ad_conn user_id]
permission::require_permission -object_id $assessment_id -privilege read
set dotlrn_admin_p [dotlrn::admin_p]
set package_id [ad_conn package_id]

if { !$dotlrn_admin_p } {
    ad_return_complaint 1 "[_ anon-eval.permission_denied]"
    ad_script_abort
}


# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set assessment_rev_id $assessment_data(assessment_rev_id)
set admin_p [ad_permission_p $assessment_id admin]

#if the user is admin he will display all sessions from all subjects
if {$admin_p && [empty_string_p $subject_id]} {
    set query "sessions_of_assessment_of_subject"
} else {
    set query "sessions_of_assessment"
}

if {[empty_string_p $subject_id] || !$admin_p} {
    set subject_id $user_id
}

if {$assessment_data(survey_p) == "t"} {
    # Lists the identifier of sessions, the name of subjects that took this assessment,
    # the name of assessment and the finished time 
    # of assessment for an assessment.

    template::list::create \
	-name sessions \
	-multirow sessions \
	-key sessions_id \
	-elements {
	    session_id {
		label {[_ assessment.Session]}
		link_url_eval {[export_vars -base "session" {session_id}]}
	    }
	    completed_datetime {
		label {[_ assessment.Finish_Time]}
		html {nowrap}
	    }
	} -main_class {
	    narrow
	} \
	-filters {
	    assessment_id {}
	    admin_sessions {
		label "[_ anon-eval.lt_Display_Admin_Session]"
		values {
		    {"[_ acs-subsite.Show]" "show"}
		    {"[_ acs-subsite.Hide]" "hide"}
		}
		where_clause {
		    (case when :admin_sessions = 'hide'
		     then not s.subject_id in (select grantee_id 
					       from acs_permissions_all 
					       where privilege = 'admin' 
					       and object_id = :package_id)
		     else true end)
		}
	    }
	}
} else {
    template::list::create \
	-name sessions \
	-multirow sessions \
	-key sessions_id \
	-elements {
	    session_id {
		label {[_ assessment.Session]}
		link_url_eval {[export_vars -base "session" {session_id}]}
	    }
	    completed_datetime {
		label {[_ assessment.Finish_Time]}
		html {nowrap}
	    }
	    percent_score {
		label {[_ assessment.Percent_Score]}
		html {align right nowrap}
	    }
	} -main_class {
	    narrow
	} \
	-filters {
	    assessment_id {}
	    admin_sessions {
		label "[_ anon-eval.lt_Display_Admin_Session]"
		values {
		    {"[_ acs-subsite.Hide]" "hide"}
		    {"[_ acs-subsite.Show]" "show"}
		}
		where_clause {
		    (case when :admin_sessions = 'hide'
		     then not s.subject_id in (select grantee_id 
					       from acs_permissions_all 
					       where privilege = 'admin' 
					       and object_id = :package_id)
		     else true end)
		}
	    }
	}
}


db_multirow -extend { subject_url assessment_url } sessions $query {
} {
    if {([empty_string_p $start_time] || $start_time <= $cur_time) && ([empty_string_p $end_time] || $end_time >= $cur_time)} {
	set assessment_url [export_vars -base "assessment" {assessment_id}]
    } else {
	set assessment_url ""
    }
    if {$assessment_data(anonymous_p) == "t" && $subject_id != $user_id} {
	set subject_name "[_ assessment.anonymous_name]"
	set subject_url ""
    } else {
	set subject_url [acs_community_member_url -user_id $subject_id]
    }
}


ad_return_template
