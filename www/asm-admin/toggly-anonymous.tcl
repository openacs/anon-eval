# packages/anon-eval/www/asm-admin/toggly-anonymous.tcl

ad_page_contract {
    
    Toggle if assessment is anonymous or not
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-02-04
    @arch-tag: 4ef548a2-c1f2-47ef-a1f5-61bffbdd7a00
    @cvs-id $Id$
} {
    assessment_id:integer,notnull
    return_url:notnull
} -properties {
} -validate {
} -errors {
}

