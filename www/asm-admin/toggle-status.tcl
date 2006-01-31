# packages/anon-eval/www/asm-admin/toggle-status.tcl

ad_page_contract {
    
    Toggle published/unpublished
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-01-24
    @arch-tag: 7146ee14-d5e7-4971-bed3-abb0d59d4b83
    @cvs-id $Id$
} {
    assessment_id:integer,notnull
    return_url:notnull
} -properties {
} -validate {
} -errors {
}

if { [content::item::get_live_revision -item_id $assessment_id] eq "" } {
    item::publish -item_id $assessment_id
} else {
    item::unpublish -item_id $assessment_id
}

ad_returnredirect $return_url