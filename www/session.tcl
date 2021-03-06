ad_page_contract {

    Show the result of a session.

    @author timo@timohentschel.de
    @date   2004-12-24
    @cvs-id $Id: 
} {
    session_id:integer
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

db_1row find_assessment {}

# Get the assessment data
as::assessment::data -assessment_id $assessment_id
permission::require_permission -object_id $assessment_id -privilege read
set admin_p [permission::permission_p -privilege admin -object_id [ad_conn package_id]]

#if { $admin_p } {
#    ad_return_complaint 1 "[_ anon-eval.permission_denied]"
#    ad_script_abort
#}

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set user_id [ad_conn user_id]
if {$subject_id != $user_id} {
    permission::require_permission -object_id $assessment_id -privilege admin
}

set page_title "[_ assessment.View_Results]"
set context_bar [ad_context_bar $page_title]
set format "[lc_get formbuilder_date_format], [lc_get formbuilder_time_format]"
set session_user_url [acs_community_member_url -user_id $subject_id]

# get start and end times
db_1row session_data {}
set session_time [as::assessment::pretty_time -seconds $session_time -hours]

# get the number of attempts
set session_attempt [db_string session_attempt {}]

set show_username_p 1
# only admins are allowed to see responses of other users
if {$assessment_data(anonymous_p) == "t" && $subject_id != $user_id} {
    set show_username_p 0
}

if {[empty_string_p $assessment_data(show_feedback)]} {
    set assessment_data(show_feedback) "all"
}

# show_feedback: none, all, incorrect, correct


set session_score 0
set assessment_score 0
db_multirow sections sections {} {
    if {[empty_string_p $points]} {
	set points 0
    }
    if {[empty_string_p $max_points]} {
	set max_points 0
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]
    incr session_score $points
    incr assessment_score $max_points
}

ad_return_template
