# packages/anon-eval/www/asm-admin/warning.tcl

ad_page_contract {
    
    Warning page
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-02-09
    @arch-tag: 93f32c53-37cd-4603-8a1d-5c646bd724d3
    @cvs-id $Id$
} {
    next_url:notnull
} -properties {
} -validate {
} -errors {
}

set index_url [ad_conn package_url]
set next_url [export_vars -base $next_url { {override_p 1} }]