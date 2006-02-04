# packages/anon-eval/www/asm-admin/toggle-anonymous.tcl

ad_page_contract {
    
    Toggle if assessment is anonymous or not    
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-02-04
    @arch-tag: 8714d788-72c8-491c-8f96-4c146aeedc37
    @cvs-id $Id$
} {
    assessment_id:integer,notnull
    return_url:notnull    
} -properties {
} -validate {
} -errors {
}

db_dml toggle_anonymous {}

ad_returnredirect $return_url